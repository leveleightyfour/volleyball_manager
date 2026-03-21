// lib/features/match/engine/sim/match_sim_runner.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volleyball_manager/core/db/database.dart';

import '../../data/services/audit_log_service.dart';
import '../../state/match_state.dart';
import '../../state/match_stats_state.dart';
import 'outcome_strategy.dart';
import 'sim_controller.dart';
import 'sim_provider.dart';

/// Point score for one set, captured at the moment the set ended.
typedef SetScore = ({int home, int away});

/// Result returned after a completed headless match simulation.
class MatchSimResult {
  const MatchSimResult({
    required this.setsHome,
    required this.setsAway,
    required this.winner,
    required this.setScores,
    required this.stats,
    required this.rallyCount,
  });

  final int setsHome;
  final int setsAway;
  final TeamSide winner;

  /// Final point score for each set played, in order.
  final List<SetScore> setScores;

  /// Per-team and per-player accumulated stats (isolated from the UI).
  final MatchStatsNotifier stats;

  final int rallyCount;
}

/// Runs a full volleyball match to completion without any visual output.
///
/// Creates an isolated [ProviderContainer] that does not interfere with any
/// running animated game or the shared [MatchStatsNotifier.I] singleton.
class MatchSimRunner {
  static Future<MatchSimResult> run({
    TeamSide firstServer = TeamSide.home,
    int? seed,
    int homeTeamId = 1,
    int awayTeamId = 2,
  }) async {
    final freshStats = MatchStatsNotifier.fresh();

    final container = ProviderContainer(overrides: [
      matchStatsProvider.overrideWith((_) => freshStats),
      auditLogServiceProvider.overrideWith(
        (ref) => AuditLogService(
          ref.read(databaseProvider),
          ref,
          headless: true,
        ),
      ),
      simControllerProvider.overrideWith((ref) {
        final strategy = EngineOutcomeStrategy(ref, seed: seed);
        return SimController(
          ref,
          initial: MatchState.initial(firstServer: firstServer),
          strategy: strategy,
        );
      }),
    ]);

    try {
      final audit = container.read(auditLogServiceProvider);
      await audit.startMatch(homeTeamId: homeTeamId, awayTeamId: awayTeamId);

      final sim = container.read(simControllerProvider);
      final setScores = <SetScore>[];

      while (!sim.state.isMatchOver) {
        final result = await sim.advance();
        for (final event in result.events) {
          event.maybeWhen(
            setEnded: (_, _, _, _, home, away) =>
                setScores.add((home: home, away: away)),
            matchEnded: (_, _, _, home, away) =>
                setScores.add((home: home, away: away)),
            orElse: () {},
          );
        }
      }

      final finalState = sim.state;
      final winner =
          finalState.setsHome >= 3 ? TeamSide.home : TeamSide.away;

      await audit.completeMatch(freshStats.homeScore, freshStats.awayScore);

      return MatchSimResult(
        setsHome: finalState.setsHome,
        setsAway: finalState.setsAway,
        winner: winner,
        setScores: setScores,
        stats: freshStats,
        rallyCount: finalState.rallyId,
      );
    } finally {
      container.dispose();
    }
  }
}
