import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volleyball_manager/features/match/engine/positions/position_resolver.dart';

import '../../../shared/models/team_style.dart';
import '../../../shared/models/player_lite.dart';

import '../engine/sim/sim_controller.dart';
import '../engine/state/match_state.dart' show TeamSide, MatchPhase, MatchState;
import '../engine/outcomes/outcomes.dart';
import '../engine/events/events.dart';
import '../stats/stats_provider.dart';

import 'components/court_component.dart';
import 'components/player_component.dart';
import 'components/zone_overlay_component.dart';
import 'components/ball_component.dart';
import 'model/move_command.dart';
import 'services/move_scheduler.dart';

class MatchGame extends FlameGame with KeyboardEvents {
  MatchGame({
    required this.sim,
    required this.positionResolver,
    this.statsNotifier,
    this.playerRadius = 22,
    this.courtPadding = 16.0,
    this.debugOverlayEnabled = false,
  });

  // ----------------- Engine -----------------
  final SimController sim;

  final PositionResolver positionResolver;

  final StatsNotifier? statsNotifier;

  // ----------------- Visual params -----------------
  final double playerRadius;
  final double courtPadding;
  final bool debugOverlayEnabled;

  // ----------------- Styles -----------------
  final TeamStyle homeStyle = TeamStyle.homeDefault();
  final TeamStyle awayStyle = TeamStyle.awayDefault();

  // ----------------- Rosters (STARTING 7) -----------------
  final List<PlayerLite> homePlayers = const [
    PlayerLite(id: 1, number: 1, role: Role.oh),
    PlayerLite(id: 2, number: 2, role: Role.oh),
    PlayerLite(id: 3, number: 3, role: Role.mb),
    PlayerLite(id: 4, number: 4, role: Role.mb),
    PlayerLite(id: 5, number: 5, role: Role.s),
    PlayerLite(id: 6, number: 6, role: Role.opp),
    PlayerLite(id: 7, number: 7, role: Role.l, isLibero: true),
  ];
  final List<PlayerLite> awayPlayers = const [
    PlayerLite(id: 8, number: 8, role: Role.oh),
    PlayerLite(id: 9, number: 9, role: Role.oh),
    PlayerLite(id: 10, number: 10, role: Role.mb),
    PlayerLite(id: 11, number: 11, role: Role.mb),
    PlayerLite(id: 12, number: 12, role: Role.s),
    PlayerLite(id: 13, number: 13, role: Role.opp),
    PlayerLite(id: 14, number: 14, role: Role.l, isLibero: true),
  ];

  PlayerLite get _homeLib => homePlayers.firstWhere((p) => p.isLibero);
  PlayerLite get _awayLib => awayPlayers.firstWhere((p) => p.isLibero);

  /// Starting orders (6 players, EXCLUDES libero) — [Z1,Z6,Z5,Z4,Z3,Z2]
  /// Convention: S, OH1, MB1, O, OH2, MB2
  List<int> _homeStart() => [5, 1, 3, 6, 2, 4];
  List<int> _awayStart() => [12, 8, 10, 13, 9, 11];

  // ----------------- Game state (render-only) -----------------
  int _rotationTick = 0;

  // ----------------- Components -----------------
  CourtComponent? _court;
  final overlay = ZoneOverlayComponent(isEnabled: false);
  final Map<int, PlayerComponent> _playerNodes = {};
  late final MoveScheduler _moveScheduler;
  BallComponent? _ball;

  // ----------------- names -----------------
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

  // ----------------- Lifecycle -----------------
  @override
  Future<void> onLoad() async {
    await _addCourt();

    overlay.isEnabled = debugOverlayEnabled;
    add(overlay);

    _ball = BallComponent(radius: 10);
    add(_ball!);

    // Create player nodes once, with names + role labels
    for (final p in [...homePlayers, ...awayPlayers]) {
      final isHome = homePlayers.any((hp) => hp.id == p.id);
      final style = isHome ? homeStyle : awayStyle;

      final node = PlayerComponent.fromTeamStyle(
        number: p.number,
        teamStyle: style,
        isLibero: p.isLibero,
        radius: playerRadius,
        position: Vector2.zero(),
        anchor: Anchor.center,
        priority: 2,
        displayName: _nextSurname(),
        roleLabel: _roleAbbr(p.role),
      );
      _playerNodes[p.id] = node;
      add(node);
    }
    _moveScheduler = MoveScheduler(_playerNodes);

    _syncRotationFromEngine();
    _layoutFromCanvas(size);

    // Kick engine to emit serveBallFlight
    _stepSim(const ManualInputs());
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent &&
        event.logicalKey.keyLabel.toLowerCase() == 'o') {
      overlay.isEnabled = !overlay.isEnabled;
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ----------------- Engine integration -----------------
  void _stepSim(ManualInputs inputs) {
    final before = sim.state;
    final res = sim.advance(manual: inputs);
    statsNotifier?.record(
      stateBefore: before,
      inputs: inputs,
      stateAfter: res.state,
      events: res.events,
    );
    _handleEvents(res.events);
    _syncRotationFromEngine();
  }

  void _handleEvents(List<EngineEvent> events) {
    final queued = <MoveCommand>[];

    for (final e in events) {
      e.when(
        serveBallFlight: (fromSide, durationSec) {
          _animateServe(
            fromSide: fromSide,
            durationSec: durationSec,
            onDone: () {
              _stepSim(const ManualInputs(serveOutcome: ServeOutcome.inPlay));
            },
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
        scoreChanged: (home, away) {
          /* hook HUD later */
        },
        rotationAdvanced: (rotationTick, serverSide) {
          _rotationTick = rotationTick;
          _layoutFromCanvas(size);
        },
        phaseChanged: (phase, rallyId) {
          if (phase == MatchPhase.reception) {
            _stepSim(const ManualInputs(passOutcome: PassOutcome.perfect));
          } else if (phase == MatchPhase.setting) {
            _stepSim(const ManualInputs(setOutcome: SetOutcome.middle));
          } else if (phase == MatchPhase.attack) {
            _stepSim(const ManualInputs(attackOutcome: AttackOutcome.kill));
          } else if (phase == MatchPhase.preServe) {
            _stepSim(const ManualInputs());
          }
        },
        rallyEnded: (pointTo, rallyId) {
          _stepSim(const ManualInputs());
        },
      );
    }

    if (queued.isNotEmpty) {
      _moveScheduler.startSimultaneous(queued); // start all moves together
    }
  }

  void _syncRotationFromEngine() {
    _rotationTick = sim.state.rotationTick;
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
    add(_court!);
  }

  TeamSide get _serverSide => sim.state.serverSide;

  int _homeOffset(int t) => t ~/ 2;
  int _awayOffset(int t) => (t + 1) ~/ 2;

  List<int> _rotated(List<int> start, int offset) {
    final n = start.length, o = offset % n;
    if (o == 0) return List<int>.from(start);
    return [...start.sublist(n - o), ...start.sublist(0, n - o)];
  }

  Map<int, int> _zonesFor(TeamSide side) {
    final start = side == TeamSide.home ? _homeStart() : _awayStart();
    final off = side == TeamSide.home
        ? _homeOffset(_rotationTick)
        : _awayOffset(_rotationTick);
    final order = _rotated(start, off);
    return {
      1: order[0],
      6: order[1],
      5: order[2],
      4: order[3],
      3: order[4],
      2: order[5],
    };
  }

  Map<int, Role> _roleIndex(TeamSide side) {
    final list = side == TeamSide.home ? homePlayers : awayPlayers;
    return {for (final p in list) p.id: p.role};
  }

  /// Libero replaces any MB in back row (5/6/1), but NOT zone 1 when serving.
  Map<int, int> _applyLibero(TeamSide side, Map<int, int> zones) {
    final roles = _roleIndex(side);
    final libId = side == TeamSide.home ? _homeLib.id : _awayLib.id;
    final serving = _serverSide == side;

    final out = Map<int, int>.from(zones);
    for (final z in const [5, 6, 1]) {
      final pid = zones[z]!;
      final isMB = roles[pid] == Role.mb;
      final zone1AndServing = (z == 1) && serving;
      if (isMB && !zone1AndServing) {
        out[z] = libId;
      }
    }
    return out;
  }

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

  Map<int, Offset> _zoneCentersForHalf(Rect half, {required TeamSide side}) {
    final yTop = half.top + half.height * 0.25;
    final yMid = half.top + half.height * 0.50;
    final yBot = half.top + half.height * 0.75;

    final backX = side == TeamSide.home
        ? half.left + half.width * 0.25
        : half.right - half.width * 0.25;
    final frontX = side == TeamSide.home
        ? half.left + half.width * 0.75
        : half.right - half.width * 0.75;

    if (side == TeamSide.home) {
      return {
        5: Offset(backX, yTop),
        4: Offset(frontX, yTop),
        6: Offset(backX, yMid),
        3: Offset(frontX, yMid),
        1: Offset(backX, yBot),
        2: Offset(frontX, yBot),
      };
    } else {
      return {
        5: Offset(backX, yBot),
        4: Offset(frontX, yBot),
        6: Offset(backX, yMid),
        3: Offset(frontX, yMid),
        1: Offset(backX, yTop),
        2: Offset(frontX, yTop),
      };
    }
  }

  void _layoutFromCanvas(Vector2 canvasSize) {
    final court = _courtRectFromCanvas(canvasSize);
    final cx = court.left + court.width / 2;
    final leftHalf = Rect.fromLTRB(court.left, court.top, cx, court.bottom);
    final rightHalf = Rect.fromLTRB(cx, court.top, court.right, court.bottom);

    final rawHome = _zonesFor(TeamSide.home);
    final rawAway = _zonesFor(TeamSide.away);
    final homeZones = _applyLibero(TeamSide.home, rawHome);
    final awayZones = _applyLibero(TeamSide.away, rawAway);

    final homeCenters = _zoneCentersForHalf(leftHalf, side: TeamSide.home);
    final awayCenters = _zoneCentersForHalf(rightHalf, side: TeamSide.away);

    // server stands just outside end line
    final serveDx = court.width * 0.06;
    final homeServePos = Offset(
      homeCenters[1]!.dx - serveDx,
      homeCenters[1]!.dy,
    );
    final awayServePos = Offset(
      awayCenters[1]!.dx + serveDx,
      awayCenters[1]!.dy,
    );

    void placeSide({
      required TeamSide side,
      required Map<int, int> zones,
      required Map<int, Offset> centers,
      required List<PlayerLite> roster,
    }) {
      final onCourt = zones.values.toSet();

      for (final pid in onCourt) {
        final pInfo = roster.firstWhere(
          (p) => p.id == pid,
          orElse: () => PlayerLite(id: pid, number: pid, role: Role.oh),
        );
        final node = _playerNodes[pid];
        if (node == null) continue;

        final z = zones.entries.firstWhere((e) => e.value == pid).key;
        Offset c = centers[z]!;

        final isServer = (_serverSide == side) && (z == 1);
        if (isServer) {
          c = (side == TeamSide.home) ? homeServePos : awayServePos;
        }

        node
          ..position = Vector2(c.dx, c.dy)
          ..setHidden(false)
          ..setRoleLabel(pInfo.isLibero ? 'L' : _roleAbbr(pInfo.role));
      }

      for (final p in roster) {
        if (!onCourt.contains(p.id)) {
          final node = _playerNodes[p.id];
          if (node != null) node.setHidden(true);
        }
      }
    }

    placeSide(
      side: TeamSide.home,
      zones: homeZones,
      centers: homeCenters,
      roster: homePlayers,
    );
    placeSide(
      side: TeamSide.away,
      zones: awayZones,
      centers: awayCenters,
      roster: awayPlayers,
    );

    overlay
      ..courtRect = court
      ..homeCenters = homeCenters
      ..awayCenters = awayCenters
      ..rotationTick = _rotationTick
      ..servingLabel = _serverSide == TeamSide.home ? 'HOME' : 'AWAY';
  }

  // ----------------- Serve animation (ball LERP) -----------------
  void _animateServe({
    required TeamSide fromSide,
    required double durationSec,
    required VoidCallback onDone,
  }) {
    final court = _courtRectFromCanvas(size);
    final cx = court.left + court.width / 2;
    final leftHalf = Rect.fromLTRB(court.left, court.top, cx, court.bottom);
    final rightHalf = Rect.fromLTRB(cx, court.top, court.right, court.bottom);

    final homeCenters = _zoneCentersForHalf(leftHalf, side: TeamSide.home);
    final awayCenters = _zoneCentersForHalf(rightHalf, side: TeamSide.away);

    final serveDx = court.width * 0.06;
    final start = (fromSide == TeamSide.home)
        ? Offset(homeCenters[1]!.dx - serveDx, homeCenters[1]!.dy)
        : Offset(awayCenters[1]!.dx + serveDx, awayCenters[1]!.dy);

    final target = (fromSide == TeamSide.home)
        ? Offset(rightHalf.center.dx, rightHalf.center.dy)
        : Offset(leftHalf.center.dx, leftHalf.center.dy);

    _ball?.serve(
      from: start,
      to: target,
      durationSec: durationSec,
      onComplete: onDone,
    );
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    _court
      ?..position = Vector2(courtPadding, courtPadding)
      ..size = canvasSize - Vector2.all(courtPadding * 2);
    _layoutFromCanvas(canvasSize);
  }
}
