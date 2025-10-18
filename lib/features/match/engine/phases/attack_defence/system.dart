// AttackDefenceSystem: defence tries to dig; otherwise rally ends.

import 'dart:math';
import '../../../core/contracts.dart';

class AttackDefenceSystem extends PhaseSystem {
  AttackDefenceSystem({
    required super.ctx,
    required this.defendingHome,
    required this.coverageQuality, // 0..1
    int? seed,
  }) : _rng = Random(seed);

  final bool defendingHome;
  final double coverageQuality;
  final Random _rng;

  @override
  Future<PhaseResult> run() async {
    final pDig = (0.25 + 0.6 * coverageQuality).clamp(0.0, 1.0);
    final r = _rng.nextDouble();

    if (r > pDig) {
      // Ball to floor → point to offense (opposite of defending side)
      return PhaseResult(
        frames: const Stream<SimFrame>.empty(),
        rallyEnded: true,
        pointToHome: !defendingHome,
      );
    }

    // Dug: treat as transition receive (quality ~ two). Loop back to attack.
    final updated = ctx.copyWith(
      phase: MatchPhase.attack,
      receiveQuality: PassQuality.two,
      setterTarget: null,
    );
    return PhaseResult(
      frames: const Stream<SimFrame>.empty(),
      updatedContext: updated,
    );
  }
}
