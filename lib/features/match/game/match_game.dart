// lib/features/match/game/match_game.dart
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart'; // PanDetector, ScaleDetector
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volleyball_manager/shared/log/live_log_overlay.dart';

// Visual & shared
import '../../../shared/models/team_style.dart';
import '../../../shared/models/player_lite.dart';

// Engine & state
import '../engine/sim/sim_controller.dart';
import '../state/match_state.dart' show TeamSide, MatchPhase;
import '../engine/events/events.dart';

// Positioning
import '../engine/positions/position_resolver.dart'; // resolveRoles(), resolveAnchor()
import '../engine/positions/position_models.dart' show Role; // roster role tags
import '../engine/positions/tactic_layout_key.dart'
    show receiveTacticSuffix, serveTacticSuffix;

// Tactics (canonical)
import '../state/tactics_state.dart'
    show tacticsProvider, ServeReceiveTacticSpec;

// Planners
import 'package:volleyball_manager/features/match/engine/presentation/serve_receive_planner.dart'
    hide ServeReceiveTacticSpec; // use the canonical one from state
import 'package:volleyball_manager/features/match/engine/presentation/serve_target_planner.dart';

// UI components
import 'components/court_component.dart';
import 'components/player_component.dart';
import 'components/zone_overlay_component.dart';
import 'components/ball_component.dart';
import 'model/move_command.dart';
import 'services/move_scheduler.dart';

// Debug UI
import 'package:volleyball_manager/features/match/presentation/debug/serve_recieve_debug_button.dart';
import 'package:volleyball_manager/features/match/presentation/debug/serve_recieve_debug_overlay.dart';

/// World wrapper so the camera can pan/zoom the whole playfield.
class CourtWorld extends World {}

class MatchGame extends FlameGame
    with KeyboardEvents, ScaleDetector {
  MatchGame({
    required this.sim,
    required this.ref,
    required this.positionResolver,
    this.playerRadius = 22,
    this.courtPadding = 16.0,
  });

  // ----------------- Engine & DI -----------------
  final SimController sim;
  final WidgetRef ref;
  final PositionResolver positionResolver;

  // ----------------- Visual params -----------------
  final double playerRadius;
  final double courtPadding;

  // ----------------- Styles -----------------
  final TeamStyle homeStyle = TeamStyle.homeDefault();
  final TeamStyle awayStyle = TeamStyle.awayDefault();

  // ----------------- RNG for tiny variations -----------------
  final Random _rng = Random();

  // ----------------- Rosters (STARTING 7) -----------------
  final List<PlayerLite> homePlayers = const [
    PlayerLite(id: 1, number: 1, role: Role.oh),
    PlayerLite(id: 2, number: 2, role: Role.oh),
    PlayerLite(id: 3, number: 3, role: Role.mb),
    PlayerLite(id: 4, number: 4, role: Role.mb),
    PlayerLite(id: 5, number: 5, role: Role.s),
    PlayerLite(id: 6, number: 6, role: Role.opp),
    PlayerLite(id: 7, number: 7, role: Role.l),
  ];
  final List<PlayerLite> awayPlayers = const [
    PlayerLite(id: 8, number: 8, role: Role.oh),
    PlayerLite(id: 9, number: 9, role: Role.oh),
    PlayerLite(id: 10, number: 10, role: Role.mb),
    PlayerLite(id: 11, number: 11, role: Role.mb),
    PlayerLite(id: 12, number: 12, role: Role.s),
    PlayerLite(id: 13, number: 13, role: Role.opp),
    PlayerLite(id: 14, number: 14, role: Role.l),
  ];

  // ----------------- Camera/World -----------------
  late final CourtWorld worldLayer;
  CameraComponent? cameraComp; // nullable + guarded

  // Zoom constraints & pinch state
  static const double minZoom = 0.5; // Will be overridden to ensure court width >= 1/2 screen
  static const double maxZoom = 3.0;
  double _zoomAtGestureStart = 1.0;
  Vector2? _lastFingerPosition; // Track finger position for direct camera control

  // Court bounds (computed on resize)
  Rect _courtBounds = Rect.zero;

  // Gesture control
  bool _gesturesEnabled = false;

  // Camera view state
  Vector2? _smallCourtPosition;
  double? _smallCourtZoom;

  @override
  Color backgroundColor() => const Color(0xFF1FB4DB);

  // ----------------- Game state (render-only) -----------------
  int _rotationTick = 0;

  // ----------------- Components -----------------
  CourtComponent? _court;
  final overlay = ZoneOverlayComponent(isEnabled: false);
  final Map<int, PlayerComponent> _playerNodes = {};
  late final MoveScheduler _moveScheduler;
  BallComponent? _ball;

  // ----------------- Labels -----------------
  final _surnames = [
    'Smith',
    'Jones',
    'Taylor',
    'Brown',
    'Williams',
    'Wilson',
    'Davis',
    'Miller',
    'Anderson',
    'Clark',
    'Lewis',
    'Walker',
    'Hall',
    'Allen',
    'Young',
    'King',
  ];
  int _nameIdx = 0;
  String _nextSurname() => _surnames[_nameIdx++ % _surnames.length];

  String _roleAbbr(Role r) {
    switch (r) {
      case Role.s:
        return 'S';
      case Role.oh:
        return 'OH';
      case Role.mb:
        return 'MB';
      case Role.opp:
        return 'OPP';
      case Role.l:
        return 'L';
    }
  }

  // Map JSON role tags -> player id (handles OH1/2, MB1/2)
  Map<String, int> _roleTagToPlayerId(List<PlayerLite> roster) {
    int pick(List<PlayerLite> list, int idx) =>
        list[(list.isEmpty ? 0 : (idx < list.length ? idx : 0))].id;

    final s = roster.where((p) => p.role == Role.s).toList();
    final opp = roster.where((p) => p.role == Role.opp).toList();
    final lib = roster.where((p) => p.role == Role.l).toList();
    final oh = roster.where((p) => p.role == Role.oh).toList();
    final mb = roster.where((p) => p.role == Role.mb).toList();

    return {
      if (s.isNotEmpty) 'S': pick(s, 0),
      if (opp.isNotEmpty) 'OPP': pick(opp, 0),
      if (lib.isNotEmpty) 'L': pick(lib, 0),
      if (oh.isNotEmpty) 'OH1': pick(oh, 0),
      if (oh.isNotEmpty) 'OH2': pick(oh, oh.length > 1 ? 1 : 0),
      if (mb.isNotEmpty) 'MB1': pick(mb, 0),
      if (mb.isNotEmpty) 'MB2': pick(mb, mb.length > 1 ? 1 : 0),
    };
  }

  // ----------------- Step scheduler -----------------
  bool _isStepping = false;
  bool _serveInFlight = false;
  bool _pendingStep = false;

  void _requestStep() {
    if (_isStepping) {
      _pendingStep = true;
    } else {
      _stepSim();
    }
  }

  Future<void> _stepSim() async {
    if (_isStepping) return;
    _isStepping = true;
    try {
      final res = await sim.advance();
      _handleEvents(res.events);
      _syncRotationFromEngine();
    } finally {
      _isStepping = false;
      if (_pendingStep) {
        _pendingStep = false;
        Future.microtask(_stepSim);
      }
    }
  }

  // ----------------- Lifecycle -----------------
  @override
  Future<void> onLoad() async {
    // 1) Build world and camera
    worldLayer = CourtWorld();
    await add(worldLayer);

    final cam = CameraComponent(world: worldLayer);
    cameraComp = cam;

    // Start centered and with a sensible default zoom
    cam.viewfinder
      ..anchor = Anchor.center
      ..zoom = _computeZoomToFitWidth()
      ..position = Vector2(size.x / 2, size.y / 2);
    add(cam);

    // 2) Add playfield components to the WORLD (so they pan/zoom)
    await _addCourt(); // adds _court to worldLayer
    worldLayer.add(overlay);

    _ball = BallComponent(radius: 10);
    worldLayer.add(_ball!);

    // Create player nodes (in the world)
    for (final p in [...homePlayers, ...awayPlayers]) {
      final isHome = homePlayers.any((hp) => hp.id == p.id);
      final style = isHome ? homeStyle : awayStyle;

      final node = PlayerComponent.fromTeamStyle(
        number: p.number,
        teamStyle: style,
        radius: playerRadius,
        role: p.role,
        position: Vector2.zero(),
        anchor: Anchor.center,
        priority: 2,
        displayName: _nextSurname(),
        roleLabel: _roleAbbr(p.role),
      );
      _playerNodes[p.id] = node;
      worldLayer.add(node);
    }
    _moveScheduler = MoveScheduler(_playerNodes);

    _syncRotationFromEngine();
    _layoutFromCanvas(size);

    // Default to large court view
    positionCourtTopTwoThirds();

    // Kick after first frame
    add(
      TimerComponent(period: 0.05, removeOnFinish: true, onTick: _requestStep),
    );
  }

  @override
  void onMount() {
    super.onMount();
    print('🎮 MatchGame mounted - ScaleDetector should be active');

    // Debug toggle & overlay (Flutter overlays: unaffected by camera zoom)
    overlays.addEntry(
      'srToggle',
      (context, game) => ServeReceiveDebugButton(
        onPressed: () {
          if (overlays.isActive('srDebug')) {
            overlays.remove('srDebug');
          } else {
            overlays.add('srDebug');
          }
        },
      ),
    );

    overlays.addEntry(
      'srDebug',
      (context, game) => Stack(
        children: [
          ServeReceiveDebugOverlay(
            getCurrentRotationIndex: rotationIndexForSide,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: 'Close',
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => overlays.remove('srDebug'),
              ),
            ),
          ),
        ],
      ),
    );

    overlays.add('srToggle');

    overlays.addEntry('liveLog', (context, game) => const LiveLogOverlay());
    overlays.add('liveLog');
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    if (event is KeyDownEvent &&
        event.logicalKey.keyLabel.toLowerCase() == 'o') {
      overlay.isEnabled = !overlay.isEnabled;
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ----------------- Camera controls (public) -----------------
  /// Snap camera to center of current canvas with optional zoom.
  void centerCourt({double? zoom}) {
    final cam = cameraComp;
    if (cam == null) return;
    cam.viewfinder
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, size.y / 2);
    if (zoom != null) {
      cam.viewfinder.zoom = zoom.clamp(minZoom, maxZoom);
    }
  }

  /// Fit full court width to viewport, then center.
  void fitCourtToWidth() {
    final cam = cameraComp;
    if (cam == null) return;
    cam.viewfinder.zoom = _computeZoomToFitWidth();
    centerCourt();
  }

  /// Pin world origin to top-left of the screen (tactical view), optional zoom.
  void pinCourtTopLeft({double? zoom}) {
    final cam = cameraComp;
    if (cam == null) return;
    cam.viewfinder
      ..anchor = Anchor.topLeft
      ..position = Vector2.zero();
    if (zoom != null) {
      cam.viewfinder.zoom = zoom.clamp(minZoom, maxZoom);
    }
  }

  /// Set explicit zoom.
  void setCourtZoom(double z) {
    final cam = cameraComp;
    if (cam == null) return;
    cam.viewfinder.zoom = z.clamp(minZoom, maxZoom);
  }

  /// Position court in top-left quarter with padding
  void positionCourtTopLeftQuarter({double padding = 50.0, bool restorePrevious = true}) {
    final cam = cameraComp;
    if (cam == null) return;

    // If we have a previous position saved and should restore it, use that
    if (restorePrevious && _smallCourtPosition != null && _smallCourtZoom != null) {
      cam.viewfinder.zoom = _smallCourtZoom!;
      cam.viewfinder.position = _smallCourtPosition!.clone();
      return;
    }

    // Court should fit in top-left quadrant (half screen width, half screen height)
    final quadrantWidth = size.x / 2;
    final quadrantHeight = size.y / 2;
    final courtWidth = _courtBounds.width;
    final courtHeight = _courtBounds.height;

    // Calculate zoom to fit court in quadrant with padding
    final zoomX = (quadrantWidth - padding * 2) / courtWidth;
    final zoomY = (quadrantHeight - padding * 2) / courtHeight;
    final zoom = zoomX < zoomY ? zoomX : zoomY;

    cam.viewfinder.zoom = zoom.clamp(minZoom, maxZoom);

    // Calculate where court should appear on screen
    final courtWidthOnScreen = courtWidth * zoom;
    final courtHeightOnScreen = courtHeight * zoom;

    // We want court edges at 'padding' pixels from screen edges
    // So court center should be at (padding + courtWidth/2) on screen
    final targetScreenX = padding + courtWidthOnScreen / 2;
    final targetScreenY = padding + courtHeightOnScreen / 2;

    // Camera looks at center of viewport, convert target screen pos to world pos
    // World offset = (target screen pos - viewport center) / zoom
    final worldOffsetX = (targetScreenX - size.x / 2) / zoom;
    final worldOffsetY = (targetScreenY - size.y / 2) / zoom;

    final position = Vector2(
      _courtBounds.left + _courtBounds.width / 2 - worldOffsetX,
      _courtBounds.top + _courtBounds.height / 2 - worldOffsetY,
    );

    cam.viewfinder.position = position;
    _smallCourtPosition = position.clone();
    _smallCourtZoom = cam.viewfinder.zoom;
  }

  /// Position court in top 2/3 of screen with padding
  void positionCourtTopTwoThirds({double padding = 96.0}) {
    final cam = cameraComp;
    if (cam == null) return;

    // Calculate zoom to fit court width with padding
    final availableWidth = size.x;
    final courtWidth = _courtBounds.width;

    // Make court slightly thinner by increasing effective padding
    final effectivePadding = padding * 1.2;
    final zoom = (availableWidth - effectivePadding * 2) / courtWidth;

    cam.viewfinder.zoom = zoom.clamp(minZoom, maxZoom);

    // Calculate court dimensions on screen
    final courtWidthOnScreen = courtWidth * zoom;
    final courtHeightOnScreen = _courtBounds.height * zoom;

    // Calculate actual horizontal padding (space left after court fits on screen)
    final actualHorizontalPadding = (availableWidth - courtWidthOnScreen) / 2;

    // Use same padding for top - court top edge at actualHorizontalPadding pixels from top
    final courtCenterScreenY = actualHorizontalPadding + courtHeightOnScreen / 2;

    // Camera viewfinder.position is in world coordinates
    // To position court center at courtCenterScreenY on screen:
    // We need to offset the camera from the court's world center
    final screenCenterY = size.y / 2;
    final offsetFromScreenCenter = courtCenterScreenY - screenCenterY;

    // Convert screen offset to world offset
    final worldYOffset = offsetFromScreenCenter / zoom;

    cam.viewfinder.position = Vector2(
      _courtBounds.left + _courtBounds.width / 2, // horizontally centered
      _courtBounds.top + _courtBounds.height / 2 - worldYOffset,
    );
  }

  // ----------------- Gestures: drag to pan, pinch to zoom -----------------
  @override
  void onScaleStart(ScaleStartInfo info) {
    if (!_gesturesEnabled) return;

    final cam = cameraComp;
    if (cam == null) return;
    _zoomAtGestureStart = cam.viewfinder.zoom;

    // Get the focal point in screen coordinates
    try {
      final focalPoint = (info.eventPosition as dynamic).global;
      if (focalPoint is Offset) {
        _lastFingerPosition = Vector2(focalPoint.dx, focalPoint.dy);
      } else if (focalPoint is Vector2) {
        _lastFingerPosition = focalPoint.clone();
      }
    } catch (_) {
      _lastFingerPosition = null;
    }
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    if (!_gesturesEnabled) return;

    final cam = cameraComp;
    if (cam == null) return;

    final double scaleFactor = _asScaleFromInfo(info.scale);

    // Compute minimum zoom to ensure court width is at least 1/2 screen width
    final courtWidth = _courtBounds.width;
    final screenWidth = size.x;
    final minZoomForCourtSize = courtWidth > 0 ? (screenWidth / 2) / courtWidth : minZoom;
    final effectiveMinZoom = minZoomForCourtSize.clamp(minZoom, maxZoom);

    // Update zoom
    final newZoom = (_zoomAtGestureStart * scaleFactor).clamp(effectiveMinZoom, maxZoom);
    cam.viewfinder.zoom = newZoom;

    // Get current finger position in screen coordinates
    Vector2? currentFingerPos;
    try {
      final focalPoint = (info.eventPosition as dynamic).global;
      if (focalPoint is Offset) {
        currentFingerPos = Vector2(focalPoint.dx, focalPoint.dy);
      } else if (focalPoint is Vector2) {
        currentFingerPos = focalPoint.clone();
      }
    } catch (_) {}

    // If we have both positions, move camera based on finger movement
    if (_lastFingerPosition != null && currentFingerPos != null) {
      final fingerDelta = currentFingerPos - _lastFingerPosition!;
      print('👆 Finger delta: $fingerDelta, last: $_lastFingerPosition, current: $currentFingerPos');

      // Move camera opposite to finger movement (pan feels natural this way)
      final currentPos = cam.viewfinder.position;
      final newPos = currentPos - fingerDelta;

      // Constrain panning based on zoom level
      // Calculate viewport size in world coordinates
      final viewportWidth = size.x / cam.viewfinder.zoom;
      final viewportHeight = size.y / cam.viewfinder.zoom;

      // Use court bounds with some extra margin for panning
      // Allow panning so court edges can reach screen edges
      final paddedLeft = _courtBounds.left - courtPadding;
      final paddedRight = _courtBounds.right + courtPadding;
      final paddedTop = _courtBounds.top - courtPadding;
      final paddedBottom = _courtBounds.bottom + courtPadding;

      final paddedWidth = paddedRight - paddedLeft;
      final paddedHeight = paddedBottom - paddedTop;

      // Only apply bounds if zoomed in enough (viewport smaller than padded area)
      Vector2 finalPos;
      if (viewportWidth < paddedWidth && viewportHeight < paddedHeight) {
        // Zoomed in - apply bounds to keep court in view
        final minX = paddedLeft + viewportWidth / 2;
        final maxX = paddedRight - viewportWidth / 2;
        final minY = paddedTop + viewportHeight / 2;
        final maxY = paddedBottom - viewportHeight / 2;

        finalPos = Vector2(
          newPos.x.clamp(minX, maxX),
          newPos.y.clamp(minY, maxY),
        );
      } else {
        // Zoomed out - no bounds, allow free panning
        finalPos = newPos;
      }

      cam.viewfinder.position = finalPos;

      // Update last position
      _lastFingerPosition = currentFingerPos;
    }
  }

  @override
  void onScaleEnd(ScaleEndInfo info) {
    if (!_gesturesEnabled) return;
    _lastFingerPosition = null;
  }

  double _computeZoomToFitWidth() {
    final vpSize = cameraComp?.viewport.size ?? size; // fallback to canvas size
    if (vpSize.x == 0) return 1.0;
    // Keep simple; your court is already fitted within _courtRectFromCanvas.
    return 1.0.clamp(minZoom, maxZoom);
  }

  // ----------------- Engine event handling -----------------
  void _handleEvents(List<EngineEvent> events) {
    final queued = <MoveCommand>[];

    for (final e in events) {
      e.when(
        serveBallFlight: (fromSide, durationSec) {
          if (_serveInFlight) return;
          _serveInFlight = true;

          bool finished = false;
          void finishOnce() {
            if (finished) return;
            finished = true;
            _serveInFlight = false;
            _requestStep();
          }

          _animateServe(
            fromSide: fromSide,
            durationSec: durationSec,
            onDone: finishOnce,
          );

          // watchdog
          Future.delayed(
            Duration(milliseconds: (durationSec * 1000).ceil() + 100),
            finishOnce,
          );
        },
        playerMove: (playerId, toX, toY, durationSec) {
          queued.add(
            MoveCommand(
              playerId: playerId,
              to: Offset(toX, toY),
              durationSec: durationSec,
            ),
          );
        },
        scoreChanged: (home, away) {},
        rotationAdvanced: (rotationTick, serverSide) {
          _rotationTick = rotationTick;
          _layoutFromCanvas(size);
        },
        phaseChanged: (phase, rallyId) {
          if (phase == MatchPhase.preServe) {
            _serveInFlight = false;
            _requestStep();
            return;
          }
          if (phase != MatchPhase.serve) {
            _requestStep();
          }
        },
        rallyEnded: (pointTo, rallyId) {
          _serveInFlight = false;
          Future.delayed(const Duration(seconds: 3), () {
            if (!isMounted) return;
            _requestStep();
          });
        },
      );
    }

    if (queued.isNotEmpty) {
      _moveScheduler.startSimultaneous(queued);
    }
  }

  void _syncRotationFromEngine() {
    _rotationTick = sim.state.rotationTick;
  }

  // For debug overlay (UI expects 1..6)
  int rotationIndexForSide(TeamSide side) {
    final offset = side == TeamSide.home
        ? (_rotationTick ~/ 2)
        : ((_rotationTick + 1) ~/ 2);
    return (offset % 6) + 1;
  }

  // ----------------- Court + layout -----------------
  Future<void> _addCourt() async {
    _court = CourtComponent(
      size: size - Vector2.all(courtPadding * 2),
      position: Vector2(courtPadding, courtPadding),
      anchor: Anchor.topLeft,
      orientation: CourtOrientation.horizontalNetVertical,
      arenaColor: const Color(0xFF1FB4DB),
      floorColor: const Color(0xFFE28E6C),
      lineColor: Colors.white,
      courtScale: 0.70,
      lineWidth: 3,
    );
    worldLayer.add(_court!);
  }

  TeamSide get _serverSide => sim.state.serverSide;

  Rect _courtRectFromCanvas(Vector2 canvasSize) {
    final arena = Rect.fromLTWH(
      courtPadding,
      courtPadding,
      canvasSize.x - courtPadding * 2,
      canvasSize.y - courtPadding * 2,
    );
    const aspect = 18 / 9;
    late double w, h;
    if (arena.width / arena.height >= aspect) {
      h = arena.height;
      w = h * aspect;
    } else {
      w = arena.width;
      h = w / aspect;
    }
    final fitted = Rect.fromLTWH(
      arena.left + (arena.width - w) / 2,
      arena.top + (arena.height - h) / 2,
      w,
      h,
    );
    const scale = 0.70;
    return Rect.fromLTWH(
      fitted.left + fitted.width * (1 - scale) / 2,
      fitted.top + fitted.height * (1 - scale) / 2,
      fitted.width * scale,
      fitted.height * scale,
    );
  }

  Rect _halfRect(Rect court, TeamSide side) {
    final cx = court.left + court.width / 2;
    return (side == TeamSide.home)
        ? Rect.fromLTRB(court.left, court.top, cx, court.bottom)
        : Rect.fromLTRB(cx, court.top, court.right, court.bottom);
  }

  void _layoutFromCanvas(Vector2 canvasSize) {
    final court = _courtRectFromCanvas(canvasSize);
    _courtBounds = court; // Update bounds for camera constraints

    final serving = _serverSide;
    final rotHome = rotationIndexForSide(TeamSide.home);
    final rotAway = rotationIndexForSide(TeamSide.away);

    // --- SERVE layouts (serve tactic currently fixed to "default")
    final serveHome = positionResolver.resolveRoles(
      phase: 'serve',
      side: TeamSide.home,
      rotationIndex1to6: rotHome,
      courtRect: court,
      tactic: 'default',
    );
    final serveAway = positionResolver.resolveRoles(
      phase: 'serve',
      side: TeamSide.away,
      rotationIndex1to6: rotAway,
      courtRect: court,
      tactic: 'default',
    );

    // --- RECEIVE layouts (tactic-aware)
    final homeSpec = ref
        .read(tacticsProvider.notifier)
        .getSpec(TeamSide.home, rotHome);
    final awaySpec = ref
        .read(tacticsProvider.notifier)
        .getSpec(TeamSide.away, rotAway);

    final recvHome = positionResolver.resolveRoles(
      phase: 'receive',
      side: TeamSide.home,
      rotationIndex1to6: rotHome,
      courtRect: court,
      tactic: receiveTacticSuffix(homeSpec),
    );
    final recvAway = positionResolver.resolveRoles(
      phase: 'receive',
      side: TeamSide.away,
      rotationIndex1to6: rotAway,
      courtRect: court,
      tactic: receiveTacticSuffix(awaySpec),
    );

    Map<String, int> tagToId(List<PlayerLite> roster) =>
        _roleTagToPlayerId(roster);

    void placeFromRoleMap(
      Map<String, Offset> baseRoles,
      List<PlayerLite> roster,
    ) {
      final ids = tagToId(roster);
      final onCourt = <int>{};

      baseRoles.forEach((tag, pos) {
        final pid = ids[tag];
        if (pid == null) return;
        _playerNodes[pid]
          ?..position = Vector2(pos.dx, pos.dy)
          ..setHidden(false)
          ..setRoleLabel(tag);
        onCourt.add(pid);
      });

      for (final p in roster) {
        if (!onCourt.contains(p.id)) _playerNodes[p.id]?.setHidden(true);
      }
    }

    void placeReceiving(TeamSide side) {
      final rot = side == TeamSide.home ? rotHome : rotAway;
      final roster = side == TeamSide.home ? homePlayers : awayPlayers;

      // 1) Which tactic key is active?
      final specRaw = ref.read(tacticsProvider.notifier).getSpec(side, rot);

      // 2) Get base ROLE POSITIONS from the PositionBook for that tactic.
      final baseRoles = positionResolver.resolveRoles(
        phase: 'receive',
        side: side,
        rotationIndex1to6: rot,
        courtRect: court,
        tactic: receiveTacticSuffix(specRaw),
      ); // Map<String, Offset>

      // 3) Only compute planner overrides if the book gave us nothing.
      Map<int, Offset> overrides = const {};
      if (baseRoles.isEmpty) {
        final planner = ServeReceivePlanner(positionResolver);
        final plan = planner.plan(
          side: side,
          rotationIndex1to6: rot,
          courtRect: court,
          spec: ServeReceiveTacticSpec(
            numPassers: specRaw.numPassers,
            passingRoles: specRaw.passingRoles,
          ),
          roleTagToPlayerId: _roleTagToPlayerId(roster),
        );
        overrides = plan.receiveSpots;
      }

      // 4) Place players
      final tagToId = _roleTagToPlayerId(roster);
      final onCourt = <int>{};
      baseRoles.forEach((tag, basePos) {
        final pid = tagToId[tag];
        if (pid == null) return;

        final finalPos = overrides[pid] ?? basePos; // book wins if present
        _playerNodes[pid]
          ?..position = Vector2(finalPos.dx, finalPos.dy)
          ..setHidden(false)
          ..setRoleLabel(tag);
        onCourt.add(pid);
      });
      for (final p in roster) {
        if (!onCourt.contains(p.id)) _playerNodes[p.id]?.setHidden(true);
      }
    }

    if (serving == TeamSide.home) {
      placeFromRoleMap(serveHome, homePlayers);
      placeReceiving(TeamSide.away);
    } else {
      placeFromRoleMap(serveAway, awayPlayers);
      placeReceiving(TeamSide.home);
    }

    overlay
      ..courtRect = court
      ..rotationTick = _rotationTick
      ..servingLabel = _serverSide == TeamSide.home ? 'HOME' : 'AWAY';
  }

  // ----------------- Serve animation using ServeTargetPlanner -----------------
  void _animateServe({
    required TeamSide fromSide,
    required double durationSec,
    required VoidCallback onDone,
  }) {
    final court = _courtRectFromCanvas(size);
    final recvSide = _other(fromSide);

    // Start: serve anchor from PositionBook (serve tactic is "default")
    final start =
        positionResolver.resolveAnchor(
          phase: 'serve',
          side: fromSide,
          rotationIndex1to6: rotationIndexForSide(fromSide),
          courtRect: court,
          anchorName: 'server_start',
          tactic: 'default',
        ) ??
        _fallbackServerStart(court, fromSide);

    // Target: use receiving side's *selected* tactic
    final rotRecv = rotationIndexForSide(recvSide);
    final recvSpecRaw = ref
        .read(tacticsProvider.notifier)
        .getSpec(recvSide, rotRecv);
    final recvSpec = ServeReceiveTacticSpec(
      numPassers: recvSpecRaw.numPassers,
      passingRoles: recvSpecRaw.passingRoles,
    );

    final pick = ServeTargetPlanner(positionResolver, rng: _rng).pickTarget(
      toSide: recvSide,
      rotationIndex1to6: rotRecv,
      courtRect: court,
      spec: recvSpec,
    );

    _ball?.serve(
      from: start,
      to: pick.target,
      durationSec: durationSec,
      onComplete: onDone,
    );
  }

  // ----------------- Helpers -----------------
  TeamSide _other(TeamSide s) =>
      s == TeamSide.home ? TeamSide.away : TeamSide.home;

  Offset _fallbackServerStart(Rect court, TeamSide side) {
    final half = _halfRect(court, side);
    final y = half.top + half.height * 0.75;
    final x = side == TeamSide.home
        ? half.left - court.width * 0.06
        : half.right + court.width * 0.06;
    return Offset(x, y);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    _court
      ?..position = Vector2(courtPadding, courtPadding)
      ..size = canvasSize - Vector2.all(courtPadding * 2);
    _layoutFromCanvas(canvasSize);

    // Don't reset camera position on resize - it's managed by the camera controls
  }
}

extension _VmOffsetX on Offset {
  Vector2 toV2() => Vector2(dx, dy);
}

extension _VmVector2X on Vector2 {
  Offset toOff() => Offset(x, y);
}

Vector2 _asVector2FromDelta(dynamic delta) {
  // Try accessing global property (EventDelta)
  try {
    final d = delta as dynamic;
    if (d.global != null) {
      if (d.global is Offset) {
        final Offset g = d.global as Offset;
        return Vector2(g.dx, g.dy);
      } else if (d.global is Vector2) {
        return d.global as Vector2;
      }
    }
  } catch (_) {}

  // Already a Vector2
  try {
    return delta as Vector2;
  } catch (_) {}

  // Direct Offset
  try {
    final Offset o = delta as Offset;
    return Vector2(o.dx, o.dy);
  } catch (_) {}

  return Vector2.zero();
}

double _asScaleFromInfo(dynamic scale) {
  // Try accessing global property (EventDelta with Vector2)
  try {
    final s = scale as dynamic;
    if (s.global != null) {
      // Handle Vector2 scale - use the x component
      if (s.global is Vector2) {
        final Vector2 v = s.global as Vector2;
        return v.x.toDouble();
      } else if (s.global is num) {
        return (s.global as num).toDouble();
      }
    }
  } catch (_) {}

  // Already num/double
  try {
    return (scale as num).toDouble();
  } catch (_) {}

  return 1.0;
}
