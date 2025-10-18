// ServeReceiveSystem: emits frames for serve flight -> reception -> setter ready,
// and returns updated context (receiveQuality + setterTarget).
// Replace helpers with your detailed engine/positions later.

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import '../../../core/contracts.dart';

enum ServeType { float, jumpFloat, jumpTopspin }

class ServePlan {
  ServePlan({
    required this.type,
    required this.targetZone,
    required this.speedMps,
  });
  final ServeType type;
  final int targetZone; // 1..6 (receiver zones)
  final double speedMps; // affects flight time
}

class RotationTactics {
  RotationTactics({required this.numPassers, required this.passingRoles});
  final int numPassers; // 2/3/4
  final Set<Role> passingRoles; // e.g., {Role.L, Role.OH1, Role.OH2}
}

/// Rotation ordering: [RB, RF, CF, LF, LB, CB]
class TeamRotation {
  TeamRotation({required this.index1to6, required this.rolesByPosition})
    : assert(rolesByPosition.length == 6, 'rolesByPosition must have 6 roles');

  final int index1to6; // 1..6
  final List<Role> rolesByPosition; // fixed length 6
}

class ServeReceiveSystem extends PhaseSystem {
  ServeReceiveSystem({
    required super.ctx,
    required this.sideReceiving,
    required this.rotation,
    required this.tactics,
    required this.plan,
    int? seed,
    this.fps = 60,
  }) : _rng = Random(seed);

  final TeamSide sideReceiving;
  final TeamRotation rotation;
  final RotationTactics tactics;
  final ServePlan plan;
  final int fps;
  final Random _rng;

  @override
  Future<PhaseResult> run() async {
    final frames = StreamController<SimFrame>();

    double t = 0.0;
    final double dt = 1.0 / fps;

    // Helper to emit a frame
    void emit(Phase p, Map<Role, Offset> players, {Offset? ball}) {
      frames.add(SimFrame(t: t, phase: p, players: players, ball: ball));
    }

    // 1) Pre-serve positions (stub)
    var players = _receiveShell(rotation, tactics);
    emit(Phase.preServe, players);

    // 2) Serve flight
    final origin = _serverOrigin(plan.targetZone);
    final target = _zoneCenter(plan.targetZone);
    final flightSec = _flightTime(origin, target, plan.speedMps);
    final steps = max(1, (flightSec / dt).round());
    for (var i = 1; i <= steps; i++) {
      t += dt;
      final a = i / steps;
      final ball = Offset(
        _lerp(origin.dx, target.dx, a),
        _lerp(origin.dy, target.dy, a),
      );
      players = _anticipate(players, ball, tactics);
      emit(Phase.serveFlight, players, ball: ball);
    }

    // 3) Reception snapshot
    final receiver = _chooseReceiver(players, target, tactics);
    final quality = _sampleQuality(plan.type, receiver);
    emit(Phase.reception, players, ball: target);

    // 4) Setter transition
    final setterTarget = _setterSpot(quality);
    final transSec = 1.0; // tune by quality later
    final steps2 = max(1, (transSec / dt).round());
    for (var i = 1; i <= steps2; i++) {
      t += dt;
      final a = i / steps2;
      final ball = Offset(
        _lerp(target.dx, setterTarget.dx, a),
        _lerp(target.dy, setterTarget.dy, a),
      );
      emit(Phase.transition, players, ball: ball);
    }

    // 5) Setter ready
    emit(Phase.setReady, players, ball: setterTarget);

    // Close stream (async-safe)
    // ignore: unawaited_futures
    Future<void>.delayed(Duration.zero, frames.close);

    final updated = ctx.copyWith(
      phase: MatchPhase.attack,
      receiveQuality: quality,
      setterTarget: setterTarget,
    );

    return PhaseResult(
      frames: frames.stream,
      updatedContext: updated,
      rallyEnded: false,
    );
  }

  // ---------- helpers (stub) ----------

  Map<Role, Offset> _receiveShell(TeamRotation rot, RotationTactics t) {
    const rb = Offset(0.85, 0.80),
        cb = Offset(0.50, 0.85),
        lb = Offset(0.15, 0.80);
    const rf = Offset(0.85, 0.30),
        cf = Offset(0.50, 0.25),
        lf = Offset(0.15, 0.30);
    final m = <Role, Offset>{
      rot.rolesByPosition[0]: rb, // RB
      rot.rolesByPosition[5]: cb, // CB
      rot.rolesByPosition[3]: lb, // LB
      rot.rolesByPosition[1]: rf, // RF
      rot.rolesByPosition[2]: cf, // CF
      rot.rolesByPosition[4]: lf, // LF
    };
    for (final r in t.passingRoles) {
      final p = m[r];
      if (p != null) {
        m[r] = Offset(p.dx, (p.dy * 0.95 + 0.05).clamp(0.05, 0.95));
      }
    }
    return m;
  }

  Map<Role, Offset> _anticipate(
    Map<Role, Offset> pos,
    Offset ball,
    RotationTactics t,
  ) {
    final out = <Role, Offset>{};
    pos.forEach((role, p) {
      final isPasser = t.passingRoles.contains(role) || role == Role.L;
      final k = isPasser ? 0.04 : 0.02;
      out[role] = Offset(
        (p.dx + (ball.dx - p.dx) * k).clamp(0, 1),
        (p.dy + (ball.dy - p.dy) * k).clamp(0, 1),
      );
    });
    return out;
  }

  Role _chooseReceiver(
    Map<Role, Offset> pos,
    Offset target,
    RotationTactics t,
  ) {
    Role? bestRole;
    double best = double.infinity;
    pos.forEach((role, p) {
      if (t.passingRoles.contains(role) || role == Role.L) {
        final d2 = (p - target).distanceSquared;
        if (d2 < best) {
          best = d2;
          bestRole = role;
        }
      }
    });
    return bestRole ?? Role.L;
  }

  PassQuality _sampleQuality(ServeType type, Role receiver) {
    double base3 = switch (type) {
      ServeType.float => 0.40,
      ServeType.jumpFloat => 0.34,
      ServeType.jumpTopspin => 0.28,
    };
    if (receiver == Role.L) base3 += 0.05;
    final r = _rng.nextDouble();
    if (r < base3) return PassQuality.three;
    if (r < base3 + 0.36) return PassQuality.two;
    if (r < base3 + 0.36 + 0.22) return PassQuality.one;
    return _rng.nextBool() ? PassQuality.overpass : PassQuality.error;
  }

  Offset _setterSpot(PassQuality q) {
    switch (q) {
      case PassQuality.three:
        return const Offset(0.78, 0.12);
      case PassQuality.two:
        return const Offset(0.70, 0.16);
      case PassQuality.one:
        return const Offset(0.62, 0.20);
      case PassQuality.overpass:
        return const Offset(0.80, 0.08);
      case PassQuality.error:
        return const Offset(0.50, 0.50);
    }
  }

  double _flightTime(Offset a, Offset b, double speedMps) {
    const halfCourtMeters = 9.0;
    final dist = (b - a).distance * halfCourtMeters;
    return (dist / speedMps).clamp(0.35, 1.5);
  }

  Offset _serverOrigin(int zone) => _zoneCenter(zone).translate(0, 0.25);
  Offset _zoneCenter(int z) => switch (z) {
    1 => const Offset(0.85, 0.80),
    6 => const Offset(0.50, 0.85),
    5 => const Offset(0.15, 0.80),
    2 => const Offset(0.85, 0.30),
    3 => const Offset(0.50, 0.25),
    4 => const Offset(0.15, 0.30),
    _ => const Offset(0.50, 0.55),
  };

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}
