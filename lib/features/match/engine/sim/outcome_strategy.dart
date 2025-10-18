import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/match_state.dart';
import '../outcomes/outcomes.dart';
import '../../state/tactics_state.dart';

import 'package:volleyball_manager/shared/log/live_log.dart';

abstract class OutcomeStrategy {
  Future<ServeOutcome?> getServeOutcome(MatchState s);
  Future<PassOutcome?> getPassOutcome(MatchState s);
  Future<SetOutcome?> getSetOutcome(MatchState s);
  Future<AttackOutcome?> getAttackOutcome(MatchState s);
}

class EngineOutcomeStrategy implements OutcomeStrategy {
  EngineOutcomeStrategy(this.ref, {int? seed}) : _rng = Random(seed);

  final Ref ref;
  final Random _rng;

  // ----------------- Serve -----------------
  @override
  Future<ServeOutcome?> getServeOutcome(MatchState s) async {
    log.i(
      ref,
      '[STRAT] serve  rally=${s.rallyId} phase=${s.phase} server=${s.serverSide}',
    );
    final out = ServeOutcome.inPlay; // deterministic for now
    log.i(ref, '[STRAT] serve → $out');
    return out;
  }

  // ----------------- Pass / Reception -----------------
  @override
  Future<PassOutcome?> getPassOutcome(MatchState s) async {
    final receiving = _other(s.serverSide);
    final rot = _rotationIndex1to6(receiving, s.rotationTick);

    // Pull spec (with a safe fallback in case provider map is sparse)
    final spec = ref.read(tacticsProvider.notifier).getSpec(receiving, rot);
    final passers = spec.numPassers;

    // Bucket probabilities by #passers
    final (pPerf, pAvg, pSingle, pWorst) = switch (passers) {
      2 => (0.20, 0.40, 0.30, 0.10),
      3 => (0.35, 0.40, 0.20, 0.05),
      4 => (0.42, 0.38, 0.17, 0.03),
      _ => (0.33, 0.40, 0.22, 0.05),
    };

    final r = _rng.nextDouble();

    log.i(
      ref,
      '[STRAT] pass   rally=${s.rallyId} phase=${s.phase} recv=$receiving rot=$rot '
      'tick=${s.rotationTick} passers=$passers '
      'dist=[P=${pPerf.toStringAsFixed(2)}, A=${pAvg.toStringAsFixed(2)}, '
      'S=${pSingle.toStringAsFixed(2)}, W=${pWorst.toStringAsFixed(2)}] '
      'r=${r.toStringAsFixed(3)}',
    );

    final out = (r < pPerf)
        ? PassOutcome.perfect
        : (r < pPerf + pAvg)
        ? PassOutcome.average
        : (r < pPerf + pAvg + pSingle)
        ? PassOutcome.singleOption
        : _worstPassFallback();

    log.i(ref, '[STRAT] pass → $out (recv=$receiving rot=$rot)');
    return out;
  }

  // ----------------- Set -----------------
  @override
  Future<SetOutcome?> getSetOutcome(MatchState s) async {
    // TODO: tie to pass outcome & hitter availability
    final out = SetOutcome.middle;
    log.i(ref, '[STRAT] set    rally=${s.rallyId} phase=${s.phase} → $out');
    return out;
  }

  // ----------------- Attack -----------------
  @override
  Future<AttackOutcome?> getAttackOutcome(MatchState s) async {
    // Quick shape: 55% kill, 25% blocked, 20% continue (dug)
    final r = _rng.nextDouble();
    final out = (r < 0.55)
        ? AttackOutcome.kill
        : (r < 0.80)
        ? AttackOutcome.blocked
        : AttackOutcome.dug;

    log.i(
      ref,
      '[STRAT] attack rally=${s.rallyId} phase=${s.phase} '
      'r=${r.toStringAsFixed(3)} → $out',
    );
    return out;
  }

  // ----------------- helpers -----------------
  PassOutcome _worstPassFallback() {
    // Robust at runtime: use enum name discovery
    final hasOverpass = PassOutcome.values.any((e) => e.name == 'overpass');
    if (hasOverpass) {
      final val = PassOutcome.values.firstWhere((e) => e.name == 'overpass');
      return val;
    }
    // If your enum lacks 'overpass', keep it in the “bad but playable” bucket
    return PassOutcome.singleOption;
  }

  int _rotationIndex1to6(TeamSide side, int rotationTick) {
    // Map rotationTick to a 1..6 index for the specified side
    final recvIsHome = side == TeamSide.home;
    final sideouts = recvIsHome ? rotationTick ~/ 2 : (rotationTick + 1) ~/ 2;
    return (sideouts % 6) + 1;
  }

  TeamSide _other(TeamSide s) =>
      s == TeamSide.home ? TeamSide.away : TeamSide.home;
}
