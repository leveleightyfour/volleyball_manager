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
import '../engine/positions/position_resolver.dart';
import '../engine/positions/pass_landing_calculator.dart';
import '../engine/positions/set_landing_calculator.dart';
import '../engine/positions/attack_landing_calculator.dart';
import '../engine/positions/attack_formation_config.dart';
import '../engine/outcomes/outcomes.dart';

// Tactics (canonical)
import '../state/tactics_state.dart'
    show tacticsProvider, ServeReceiveTacticSpec;
import 'package:volleyball_manager/shared/log/match_debug_state.dart';

// UI components
import 'components/court_component.dart';
import 'components/player_component.dart';
import 'components/zone_overlay_component.dart';
import 'components/ball_component.dart';
import 'services/move_scheduler.dart';
import 'services/camera_controller.dart';
import 'services/layout_manager.dart';
import 'services/event_handler.dart';
import 'services/simulation_coordinator.dart';

// State
import '../state/match_stats_state.dart';
import '../state/match_roster_provider.dart';

// Overlays / debug UI
import 'package:volleyball_manager/features/match/presentation/debug/serve_recieve_debug_button.dart';
import 'package:volleyball_manager/features/match/presentation/debug/serve_recieve_debug_overlay.dart';
import 'package:volleyball_manager/features/match/presentation/debug/defense_floor_overlay.dart';
import 'package:volleyball_manager/features/match/presentation/overlays/stats_overlay.dart';

// Audit log service
import 'package:volleyball_manager/features/match/data/services/audit_log_service.dart';

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

  // Court bounds (computed on resize)
  Rect _courtBounds = Rect.zero;

  // Last serve/pass landing position used as start of next ball animation
  Offset? _lastBallLanding;

  // True once the first attack of a rally has fired.
  // Reset each preServe; set in _animateSetToAttacker before the animation runs.
  // Drives rotation-aware vs natural attack positions.
  bool _attackedThisRally = false;

  // ----------------- Specialized Services -----------------
  CameraController? _cameraController;
  LayoutManager? _layoutManager;
  EventHandler? _eventHandler;
  SimulationCoordinator? _simCoordinator;
  AttackFormationConfig? _attackFormations;

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
  /// Extracts the last word of a full name to use as a short display label.
  String _surname(String fullName) {
    final parts = fullName.trim().split(' ');
    return parts.last;
  }

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

  // Role tag mapping moved to LayoutManager

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

    // Build id → last-name lookup from the loaded roster.
    final roster = ref.read(matchRosterCacheProvider);
    final nameById = <int, String>{
      for (final dto in [...roster.home.values, ...roster.away.values])
        dto.id: _surname(dto.name),
    };

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
        displayName: nameById[p.id] ?? '',
        roleLabel: _roleAbbr(p.role),
      );
      _playerNodes[p.id] = node;
      worldLayer.add(node);
    }
    _moveScheduler = MoveScheduler(_playerNodes);

    // Initialize specialized services
    _cameraController = CameraController(
      getCamera: () => cameraComp,
      getCanvasSize: () => size,
      getCourtBounds: () => _courtBounds,
      courtPadding: courtPadding,
    );

    _attackFormations = await AttackFormationConfig.load();

    _layoutManager = LayoutManager(
      positionResolver: positionResolver,
      ref: ref,
      playerNodes: _playerNodes,
      overlay: overlay,
      homePlayers: homePlayers,
      awayPlayers: awayPlayers,
      courtPadding: courtPadding,
      rng: _rng,
    );

    _eventHandler = EventHandler(
      moveScheduler: _moveScheduler,
      ball: _ball,
      onLayoutUpdate: () => _layoutFromCanvas(size),
      requestStep: () => _simCoordinator?.requestStep(),
    );

    _simCoordinator = SimulationCoordinator(
      sim: sim,
      onEvents: _handleEvents,
      onRotationSync: _syncRotationFromEngine,
    );

    // Start match record + reset in-memory stats
    await ref.read(auditLogServiceProvider).startMatch();
    ref.read(matchStatsProvider).reset();

    _syncRotationFromEngine();
    _layoutFromCanvas(size);

    // Default to large court view
    _cameraController?.positionCourtTopTwoThirds();

    // Kick after first frame
    add(
      TimerComponent(period: 0.05, removeOnFinish: true, onTick: () => _simCoordinator?.requestStep()),
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

    // Defense floor tactics toggle & overlay (top-left, mirrors srDebug pattern)
    overlays.addEntry(
      'dfToggle',
      (context, game) => SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Material(
              color: Colors.black54,
              shape: const StadiumBorder(),
              child: IconButton(
                icon: const Icon(Icons.shield, size: 20, color: Colors.white),
                tooltip: 'Defense Floor Tactics',
                onPressed: () {
                  if (overlays.isActive('dfDebug')) {
                    overlays.remove('dfDebug');
                  } else {
                    overlays.add('dfDebug');
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );

    overlays.addEntry(
      'dfDebug',
      (context, game) => DefenseFloorOverlay(
        getCurrentRotationIndex: rotationIndexForSide,
        onClose: () => overlays.remove('dfDebug'),
      ),
    );

    overlays.add('dfToggle');

    // Audit log display (replaces raw debug log)
    overlays.addEntry('auditLog', (context, game) => const LiveLogOverlay());
    overlays.add('auditLog');

    // Stats overlay + toggle button
    overlays.addEntry(
      'statsToggle',
      (context, game) => Positioned(
        top: 8,
        right: 52,
        child: Material(
          color: Colors.black54,
          shape: const CircleBorder(),
          child: IconButton(
            tooltip: 'Match Stats',
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () {
              if (overlays.isActive('stats')) {
                overlays.remove('stats');
              } else {
                overlays.add('stats');
              }
            },
          ),
        ),
      ),
    );
    overlays.add('statsToggle');

    overlays.addEntry('stats', (context, game) => const StatsOverlay());
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

  // ----------------- Camera controls (public) - Delegated to CameraController -----------------
  void centerCourt({double? zoom}) => _cameraController?.centerCourt(zoom: zoom);
  void fitCourtToWidth() => _cameraController?.fitCourtToWidth();
  void pinCourtTopLeft({double? zoom}) => _cameraController?.pinCourtTopLeft(zoom: zoom);
  void setCourtZoom(double z) => _cameraController?.setCourtZoom(z);
  void positionCourtTopLeftQuarter({double padding = 50.0, bool restorePrevious = true}) =>
      _cameraController?.positionCourtTopLeftQuarter(padding: padding, restorePrevious: restorePrevious);
  void positionCourtTopTwoThirds({double padding = 96.0}) =>
      _cameraController?.positionCourtTopTwoThirds(padding: padding);

  // ----------------- Gestures - Delegated to CameraController -----------------
  @override
  void onScaleStart(ScaleStartInfo info) => _cameraController?.onScaleStart(info);

  @override
  void onScaleUpdate(ScaleUpdateInfo info) => _cameraController?.onScaleUpdate(info);

  @override
  void onScaleEnd(ScaleEndInfo info) => _cameraController?.onScaleEnd(info);

  double _computeZoomToFitWidth() {
    final vpSize = cameraComp?.viewport.size ?? size;
    if (vpSize.x == 0) return 1.0;
    return 1.0;
  }

  // ----------------- Engine event handling - Delegated to EventHandler with serve callback -----------------
  void _handleEvents(List<EngineEvent> events) {
    // First, delegate to EventHandler to process all events
    _eventHandler?.handleEvents(events);

    // Animate all players to serve/receive formation on phase/rotation changes.
    // Skip setting, attack, and reception — those have dedicated animations.
    for (final e in events) {
      if (e is RotationAdvanced) {
        _animateAllPlayersToFormation();
      } else if (e is PhaseChanged &&
          e.phase != MatchPhase.setting &&
          e.phase != MatchPhase.attack &&
          e.phase != MatchPhase.reception) {
        _animateAllPlayersToFormation();
      }
    }

    // Update live score in stats notifier
    for (final e in events) {
      if (e is ScoreChanged) {
        ref.read(matchStatsProvider).updateScore(e.home, e.away);
      }
    }

    // Handle ball animations and phase-specific player moves
    for (final e in events) {
      if (e is ServeBallFlight) {
        _animateServe(
          fromSide: e.fromSide,
          durationSec: e.durationSec,
          onDone: () {
            _eventHandler?.resetServeState();
            _simCoordinator?.requestStep();
          },
        );
      } else if (e is PhaseChanged && e.phase == MatchPhase.setting) {
        // Ball was received — animate it from landing zone to setter area
        _animatePassToSetter(onDone: () => _simCoordinator?.requestStep());
      } else if (e is PhaseChanged && e.phase == MatchPhase.dig) {
        // Attack was dug — animate ball from attack contact to dig position
        _animateDigTransition(onDone: () => _simCoordinator?.requestStep());
      } else if (e is PhaseChanged && e.phase == MatchPhase.attack) {
        // Ball was set — animate it from setter to attack contact point
        _animateSetToAttacker(onDone: () => _simCoordinator?.requestStep());
      } else if (e is RallyEnded) {
        _animateBallBounce();
      } else if (e is PhaseChanged && e.phase == MatchPhase.preServe) {
        _attackedThisRally = false;
        _moveBallToServePosition();
      }
    }
  }

  void _syncRotationFromEngine() {
    _rotationTick = sim.state.rotationTick;
    ref.read(matchDebugStateProvider).update(
      home: rotationIndexForSide(TeamSide.home),
      away: rotationIndexForSide(TeamSide.away),
    );
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

  // Court rect and half rect methods moved to LayoutManager

  // ----------------- Layout - Delegated to LayoutManager -----------------
  void _layoutFromCanvas(Vector2 canvasSize) {
    final layoutManager = _layoutManager;
    if (layoutManager == null) return; // Not initialized yet

    final court = layoutManager.computeCourtRect(canvasSize);
    _courtBounds = court; // Update bounds for camera constraints

    layoutManager.updateLayout(
      canvasSize: canvasSize,
      serverSide: _serverSide,
      rotationTick: _rotationTick,
      getRotationIndex: rotationIndexForSide,
    );
  }

  // ----------------- Player formation animation -----------------

  /// Animates all 12 players to their serve/receive formation positions.
  /// Called on every phase change so players continuously move into position.
  void _animateAllPlayersToFormation() {
    final lm = _layoutManager;
    if (lm == null) return;
    final moves = lm.buildFormationMoves(
      canvasSize: size,
      serverSide: _serverSide,
      getRotationIndex: rotationIndexForSide,
      durationSec: 0.45,
    );
    if (moves.isNotEmpty) {
      _moveScheduler.startSimultaneous(moves);
    }
  }

  // ----------------- Serve animation - Uses LayoutManager -----------------
  void _animateServe({
    required TeamSide fromSide,
    required double durationSec,
    required VoidCallback onDone,
  }) {
    final layoutManager = _layoutManager;
    final eventHandler = _eventHandler;
    if (layoutManager == null || eventHandler == null) return;

    final court = layoutManager.computeCourtRect(size);
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
        layoutManager.getFallbackServerStart(court, fromSide);

    // Target: use receiving side's *selected* tactic
    final rotRecv = rotationIndexForSide(recvSide);
    final recvSpecRaw = ref
        .read(tacticsProvider.notifier)
        .getSpec(recvSide, rotRecv);
    final recvSpec = ServeReceiveTacticSpec(
      numPassers: recvSpecRaw.numPassers,
      passingRoles: recvSpecRaw.passingRoles,
    );

    final pick = layoutManager.pickServeTarget(
      toSide: recvSide,
      rotationIndex1to6: rotRecv,
      courtRect: court,
      spec: recvSpec,
    );

    // Track where the ball lands so the pass animation can start from there
    _lastBallLanding = pick.target;

    // Both teams move simultaneously during serve flight:
    // - Serving team → defense positions
    // - Receiving team → passer to ball, non-passers to pre-attack positions
    final defMoves = layoutManager.buildDefenseFormationMoves(
      canvasSize: size,
      servingSide: fromSide,
      rotationIndex: rotationIndexForSide(fromSide),
      durationSec: durationSec * 0.85,
    );
    if (defMoves.isNotEmpty) _moveScheduler.startSimultaneous(defMoves);

    final recvMoves = layoutManager.buildReceptionMoves(
      canvasSize: size,
      receivingSide: recvSide,
      rotationIndex: rotRecv,
      passingRoles: Set<String>.from(recvSpec.passingRoles),
      ballLandingZone: pick.target,
      durationSec: durationSec * 0.90,
    );
    if (recvMoves.isNotEmpty) _moveScheduler.startSimultaneous(recvMoves);

    eventHandler.animateServe(
      from: start,
      to: pick.target,
      durationSec: durationSec,
      onDone: onDone,
    );
  }

  // ----------- Pass ball flight (receive zone → setter) -----------

  /// Animates the ball from the serve landing zone to a pass-quality-dependent
  /// target. Simultaneously moves all players to their pre-attack positions.
  void _animatePassToSetter({required VoidCallback onDone}) {
    final lm = _layoutManager;
    final ball = _ball;
    if (lm == null || ball == null) { onDone(); return; }

    final court = lm.computeCourtRect(size);
    // Use sim.possession — correctly tracks who has the ball even after a dig.
    final attackingSide = sim.possession;
    final rot = rotationIndexForSide(attackingSide);

    final from = _lastBallLanding ?? _fallbackReceiveZone(court, attackingSide);

    final to = PassLandingCalculator.compute(
      outcome: sim.lastPassOutcome,
      receivingSide: attackingSide,
      receivingHalf: lm.getHalfRect(court, attackingSide),
      fullCourt: court,
      rng: _rng,
    );
    _lastBallLanding = to;

    final settingMoves = lm.buildSettingFormationMoves(
      canvasSize: size,
      attackingSide: attackingSide,
      rotationIndex: rot,
      durationSec: 0.50,
      setterDestination: to,
    );
    if (settingMoves.isNotEmpty) _moveScheduler.startSimultaneous(settingMoves);

    ball.fly(
      from: from,
      to: to,
      durationSec: 1.2,
      fromHeightM: 1.0,
      toHeightM: 3.0,
      peakHeightM: 3.0,
      peakT: 1.0,
      onComplete: onDone,
    );

    // 0.6 s into the pass flight, attackers begin their approach runs toward
    // their attack zones — MB timing is particularly important here.
    // Skip for rotation-aware first attack (receiving team's first rally attack):
    // OH and OPP are already in their R1 zone positions and must not be moved
    // to canonical approach spots before the ball is set.
    final formations = _attackFormations;
    final isRotationAwarePass = !_attackedThisRally && attackingSide != _serverSide;
    if (formations != null && !isRotationAwarePass) {
      Future.delayed(const Duration(milliseconds: 600), () {
        final approachMoves = lm.buildPreSetApproachMoves(
          canvasSize: size,
          attackingSide: attackingSide,
          rotationIndex: rot,
          formations: formations,
          durationSec: 0.60,
        );
        if (approachMoves.isNotEmpty) _moveScheduler.startSimultaneous(approachMoves);
      });
    }
  }


  // ----------- Set to attacker -----------

  /// Flies the ball from the setter's position to the attack contact point.
  /// Height and duration vary by set type (tempo = low/fast, high = tall arc).
  void _animateSetToAttacker({required VoidCallback onDone}) {
    final lm = _layoutManager;
    final ball = _ball;
    if (lm == null || ball == null) { onDone(); return; }

    // Capture before setting — first attack uses rotation positions, not natural.
    final isFirstAttack = !_attackedThisRally;
    _attackedThisRally = true;

    final court = lm.computeCourtRect(size);
    // Use sim.possession — correctly tracks who has the ball even after a dig.
    final attackingSide = sim.possession;
    final rot = rotationIndexForSide(attackingSide);

    final from = _lastBallLanding ?? Offset(ball.position.x, ball.position.y);

    final result = SetLandingCalculator.compute(
      outcome: sim.lastSetOutcome,
      attackingSide: attackingSide,
      attackingHalf: lm.getHalfRect(court, attackingSide),
      rng: _rng,
    );

    // Rotation-aware attack position: use the canonical approach y for the set
    // type on the first attack of a rally (receiving team only). This ensures
    // the contact point is at the correct pin even when rotation has placed the
    // attacker in a different zone (e.g. OPP at zone 4 in R1 still attacks
    // from zone 2, OH2 at zone 3 in R3 still attacks from zone 4).
    final isRotationAware = isFirstAttack && attackingSide != _serverSide;

    final attackContactPoint = isRotationAware
        ? (lm.getFirstAttackPosition(
              canvasSize: size,
              attackingSide: attackingSide,
              rotationIndex: rot,
              setOutcome: sim.lastSetOutcome,
            ) ?? result.position)
        : result.position;

    _lastBallLanding = attackContactPoint;

    // Move chosen attacker to the ball and all others to cover positions.
    final formations = _attackFormations;
    if (formations != null) {
      final coverMoves = lm.buildAttackCoverMoves(
        canvasSize: size,
        attackingSide: attackingSide,
        rotationIndex: rot,
        setOutcome: sim.lastSetOutcome,
        attackContactPoint: attackContactPoint,
        formations: formations,
        durationSec: result.durationSec,
      );
      if (coverMoves.isNotEmpty) _moveScheduler.startSimultaneous(coverMoves);
    }

    // Move defending team to block and floor-defence positions simultaneously.
    final defendingSide = _other(attackingSide);
    final defenseMoves = lm.buildDefenseAttackMoves(
      canvasSize: size,
      defendingSide: defendingSide,
      setOutcome: sim.lastSetOutcome,
      passOutcome: sim.lastPassOutcome,
      rotationIndex: rotationIndexForSide(defendingSide),
      durationSec: result.durationSec,
    );
    if (defenseMoves.isNotEmpty) _moveScheduler.startSimultaneous(defenseMoves);

    ball.fly(
      from: from,
      to: attackContactPoint,
      durationSec: result.durationSec,
      fromHeightM: 3.0,
      toHeightM: result.toHeightM,
      peakHeightM: result.peakHeightM,
      peakT: 0.5,
      onComplete: onDone,
    );
  }

  // ----------- Dig transition -----------

  /// Animates the ball from the attack contact point to a back-court dig
  /// position on the defending team's side. The dig landing zone is derived
  /// from [sim.lastAttackDirection] using the same zone table as kill shots,
  /// so the ball visually lands where the defender is standing.
  ///
  /// After the animation completes [onDone] fires, which triggers requestStep
  /// and advances the engine from [MatchPhase.dig] → [MatchPhase.setting].
  /// [_lastBallLanding] is updated so [_animatePassToSetter] starts correctly.
  void _animateDigTransition({required VoidCallback onDone}) {
    final lm = _layoutManager;
    final ball = _ball;
    if (lm == null || ball == null) { onDone(); return; }

    final court = lm.computeCourtRect(size);
    // After the dig, possession has flipped — sim.possession is the digging team.
    final diggingSide = sim.possession;
    final from = _lastBallLanding ?? Offset(ball.position.x, ball.position.y);

    // Reuse AttackLandingCalculator zone table to find where the ball lands.
    final digSpot = AttackLandingCalculator.kill(
      direction: sim.lastAttackDirection,
      defendingSide: diggingSide,
      defendingHalf: lm.getHalfRect(court, diggingSide),
      rng: _rng,
    );

    // Fall back to mid-court if direction was atBlock (no floor zone defined).
    final to = digSpot ?? Offset(
      lm.getHalfRect(court, diggingSide).center.dx,
      lm.getHalfRect(court, diggingSide).center.dy,
    );

    _lastBallLanding = to;

    ball.fly(
      from: from,
      to: to,
      durationSec: 0.55,
      fromHeightM: 3.0,
      toHeightM: 1.0,
      peakHeightM: 3.0,
      peakT: 0.15,
      onComplete: onDone,
    );
  }

  // ----------- Ball return to serve position -----------

  /// Glides the ball along the ground to the new server's start position.
  /// Triggered on preServe so the rotation has already been updated.
  void _moveBallToServePosition() {
    final ball = _ball;
    final lm = _layoutManager;
    if (ball == null || lm == null) return;

    final court = lm.computeCourtRect(size);
    final serverSide = _serverSide;
    final rot = rotationIndexForSide(serverSide);

    final dest =
        positionResolver.resolveAnchor(
          phase: 'serve',
          side: serverSide,
          rotationIndex1to6: rot,
          courtRect: court,
          anchorName: 'server_start',
          tactic: 'default',
        ) ??
        lm.getFallbackServerStart(court, serverSide);

    final from = Offset(ball.position.x, ball.position.y);

    ball.fly(
      from: from,
      to: dest,
      durationSec: 1.0,
      fromHeightM: 0.0,
      toHeightM: 0.0,
      peakHeightM: 0.0,
      peakT: 0.5,
    );
  }

  // ----------- End-of-rally bounce -----------

  /// Animates the ball at the end of a rally.
  ///
  /// - Overpass / shank: fly to bad-pass landing, leave there.
  /// - Attack kill:      fly from contact point to direction zone in defending half.
  /// - Attack blocked:   deflect back to attacking side near the net.
  /// - Attack error:     stay at contact point.
  /// - Other (fault):    bounce at last ball position.
  void _animateBallBounce() {
    final ball = _ball;
    final lm = _layoutManager;
    if (ball == null || lm == null) return;

    final passOutcome = sim.lastPassOutcome;

    // ── Overpass / shank ─────────────────────────────────────────────────
    if (passOutcome == PassOutcome.overpass || passOutcome == PassOutcome.shank) {
      final from = _lastBallLanding;
      if (from == null) return;
      final court = lm.computeCourtRect(size);
      final receivingSide = _other(_serverSide);
      final to = PassLandingCalculator.compute(
        outcome: passOutcome,
        receivingSide: receivingSide,
        receivingHalf: lm.getHalfRect(court, receivingSide),
        fullCourt: court,
        rng: _rng,
      );
      _lastBallLanding = to;
      ball.fly(
        from: from,
        to: to,
        durationSec: 0.8,
        fromHeightM: 1.0,
        toHeightM: passOutcome == PassOutcome.overpass ? 2.5 : 0.0,
        peakHeightM: passOutcome == PassOutcome.overpass ? 3.5 : 1.5,
        peakT: 0.5,
      );
      return;
    }

    // ── Attack phase outcome ──────────────────────────────────────────────
    if (_attackedThisRally) {
      final from = _lastBallLanding;
      if (from == null) return;
      final court = lm.computeCourtRect(size);
      final attackingSide = _other(_serverSide);
      final defendingSide = _serverSide;

      switch (sim.lastAttackOutcome) {
        case AttackOutcome.kill:
          final landing = AttackLandingCalculator.kill(
            direction: sim.lastAttackDirection,
            defendingSide: defendingSide,
            defendingHalf: lm.getHalfRect(court, defendingSide),
            rng: _rng,
          );
          if (landing != null) {
            _lastBallLanding = landing;
            ball.fly(
              from: from,
              to: landing,
              durationSec: 0.45,
              fromHeightM: 3.0,
              toHeightM: 0.0,
              peakHeightM: 1.2,
              peakT: 0.25,
              onComplete: () =>
                  ball.bounce(at: landing, fromHeightM: 0.3, durationSec: 1.5),
            );
          } else {
            // atBlock direction — treat as blocked back
            ball.bounce(at: from, fromHeightM: 0.5, durationSec: 2.0);
          }

        case AttackOutcome.blocked:
          final landing = AttackLandingCalculator.blocked(
            attackingSide: attackingSide,
            attackingHalf: lm.getHalfRect(court, attackingSide),
            rng: _rng,
          );
          _lastBallLanding = landing;
          ball.fly(
            from: from,
            to: landing,
            durationSec: 0.40,
            fromHeightM: 3.0,
            toHeightM: 0.5,
            peakHeightM: 1.5,
            peakT: 0.5,
            onComplete: () =>
                ball.bounce(at: landing, fromHeightM: 0.3, durationSec: 1.5),
          );

        case AttackOutcome.error:
          // Ball hits net or goes out — stays near attack contact.
          ball.bounce(at: from, fromHeightM: 0.5, durationSec: 2.0);

        case AttackOutcome.dug:
          // dug doesn't reach rallyEnded — no-op guard.
          break;
      }
      return;
    }

    // ── Default: serve fault or other non-attack ending ───────────────────
    final landing = _lastBallLanding;
    if (landing == null) return;
    ball.bounce(at: landing, fromHeightM: 0.5, durationSec: 2.0);
  }

  // ----------- Position helpers -----------

  Offset _fallbackReceiveZone(Rect court, TeamSide side) {
    final half = _layoutManager!.getHalfRect(court, side);
    return Offset(half.left + half.width * 0.2, half.top + half.height * 0.5);
  }


  // ----------------- Helpers -----------------
  TeamSide _other(TeamSide s) =>
      s == TeamSide.home ? TeamSide.away : TeamSide.home;

  // Fallback server start moved to LayoutManager

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

// Helper functions moved to CameraController
