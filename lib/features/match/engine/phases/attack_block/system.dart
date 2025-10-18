// AttackBlockSystem: compares attacker vs blockers to decide kill/stuff/live.

import 'dart:math';
import '../../../core/contracts.dart';

abstract class SkillProvider {
  double attackerTerminate(Role attacker); // 0..1
  double blockerStuff(Role blocker); // 0..1 (per blocker)
  double readability(bool offenseHome); // 0..1 (0 unreadable, 1 predictable)
}

class AttackBlockSystem extends PhaseSystem {
  AttackBlockSystem({
    required super.ctx,
    required this.offenseHome,
    required this.attacker,
    required this.blockers, // 1..3
    required this.skills,
    int? seed,
  }) : _rng = Random(seed);

  final bool offenseHome;
  final Role attacker;
  final int blockers;
  final SkillProvider skills;
  final Random _rng;

  @override
  Future<PhaseResult> run() async {
    final read = skills.readability(offenseHome); // 0 unreadable helps offense
    final atk = skills.attackerTerminate(attacker) * (1.0 + (1.0 - read) * 0.2);
    final blk = _blockAggregate(blockers) * (1.0 + blockers * 0.15);

    final pStuff = _logistic(blk - atk, k: 1.2);
    final pKill = _logistic(atk - blk, k: 1.0);
    final r = _rng.nextDouble();

    if (r < pStuff) {
      return PhaseResult(
        frames: const Stream<SimFrame>.empty(),
        rallyEnded: true,
        pointToHome: !offenseHome,
      );
    }
    if (r < pStuff + pKill) {
      return PhaseResult(
        frames: const Stream<SimFrame>.empty(),
        rallyEnded: true,
        pointToHome: offenseHome,
      );
    }

    // Live ball → defence will decide.
    return PhaseResult(
      frames: const Stream<SimFrame>.empty(),
      updatedContext: ctx.copyWith(phase: MatchPhase.attack),
    );
  }

  double _blockAggregate(int n) {
    // Placeholder: average of involved blockers (use real roles later).
    double sum = 0;
    final count = n.clamp(1, 3);
    for (var i = 0; i < count; i++) {
      sum += skills.blockerStuff(Role.MB1); // TODO: use actual blocking roles
    }
    return sum / count;
  }

  double _logistic(double x, {double k = 1.0}) => 1.0 / (1.0 + exp(-k * x));
}
