import 'package:volleyball_manager/features/player/data/dto/player_dto.dart';
import 'package:volleyball_manager/features/player/data/repositories/player_repository.dart';
import 'package:volleyball_manager/features/player/domain/position_rating_calculator.dart';

/// Batch service for efficient position rating updates across many players
///
/// Use this for large-scale operations like:
/// - Initial database seeding
/// - Formula rebalancing (recalculate all players)
/// - League/season updates
class PositionRatingBatchService {
  final PlayerRepository playerRepository;
  final PositionRatingCalculator calculator;

  PositionRatingBatchService({
    required this.playerRepository,
    required this.calculator,
  });

  /// Update ratings for multiple players in a single batch transaction
  ///
  /// This is ~10-100x faster than calling updatePlayerRatings individually
  /// because it uses a single database transaction.
  ///
  /// Performance example:
  /// - Individual updates: 1000 players × 5ms = 5 seconds
  /// - Batch update: 1000 players = ~50ms (100x faster!)
  Future<void> updatePlayersBatch(List<PlayerDto> players) async {
    if (players.isEmpty) return;

    // Calculate all ratings first
    final updates = <int, Map<String, double>>{};
    for (final player in players) {
      updates[player.id] = calculator.calculateAllPositionRatings(player);
    }

    // Use optimized batch update (single transaction)
    await playerRepository.batchUpdatePositionRatings(updates);
  }

  /// Recalculate ratings for all players in the database
  ///
  /// Use this when:
  /// - Skill formulas change
  /// - Position weights are updated
  /// - Game balancing pass
  ///
  /// Progress callback provides (current, total) for UI progress bar
  Future<void> recalculateAllPlayers({
    void Function(int current, int total)? onProgress,
    int batchSize = 100,
  }) async {
    final allPlayers = await playerRepository.getAll();
    final total = allPlayers.length;

    // Process in batches to avoid memory issues with huge datasets
    for (var i = 0; i < allPlayers.length; i += batchSize) {
      final end = (i + batchSize < allPlayers.length)
          ? i + batchSize
          : allPlayers.length;
      final batch = allPlayers.sublist(i, end);

      await updatePlayersBatch(batch);

      onProgress?.call(end, total);
    }
  }

  /// Recalculate ratings for players in a specific team
  Future<void> recalculateTeamPlayers(int teamId) async {
    final teamPlayers = await playerRepository.getByTeamId(teamId);
    await updatePlayersBatch(teamPlayers);
  }

  /// Find players whose ratings are stale (attributes changed but ratings not updated)
  ///
  /// This can detect data integrity issues
  Future<List<PlayerDto>> findStaleRatings() async {
    final allPlayers = await playerRepository.getAll();
    final stale = <PlayerDto>[];

    for (final player in allPlayers) {
      final currentRatings = calculator.calculateAllPositionRatings(player);

      // Check if stored ratings differ from calculated (with small tolerance)
      const tolerance = 0.01;
      if ((player.ratingOh - currentRatings['oh']!).abs() > tolerance ||
          (player.ratingOpp - currentRatings['opp']!).abs() > tolerance ||
          (player.ratingMb - currentRatings['mb']!).abs() > tolerance ||
          (player.ratingS - currentRatings['s']!).abs() > tolerance ||
          (player.ratingL - currentRatings['l']!).abs() > tolerance) {
        stale.add(player);
      }
    }

    return stale;
  }

  /// Get statistics about position rating distribution
  ///
  /// Useful for game balancing to see rating curves
  Future<PositionRatingStats> getPositionStats() async {
    final allPlayers = await playerRepository.getAll();

    final stats = <String, _PositionStatDetail>{};
    for (final pos in ['oh', 'opp', 'mb', 's', 'l']) {
      stats[pos] = _PositionStatDetail();
    }

    for (final player in allPlayers) {
      stats['oh']!.addValue(player.ratingOh);
      stats['opp']!.addValue(player.ratingOpp);
      stats['mb']!.addValue(player.ratingMb);
      stats['s']!.addValue(player.ratingS);
      stats['l']!.addValue(player.ratingL);
    }

    return PositionRatingStats(
      totalPlayers: allPlayers.length,
      oh: stats['oh']!.toStats(),
      opp: stats['opp']!.toStats(),
      mb: stats['mb']!.toStats(),
      s: stats['s']!.toStats(),
      l: stats['l']!.toStats(),
    );
  }
}

/// Statistics for position ratings across all players
class PositionRatingStats {
  final int totalPlayers;
  final PositionStatDetail oh;
  final PositionStatDetail opp;
  final PositionStatDetail mb;
  final PositionStatDetail s;
  final PositionStatDetail l;

  PositionRatingStats({
    required this.totalPlayers,
    required this.oh,
    required this.opp,
    required this.mb,
    required this.s,
    required this.l,
  });

  @override
  String toString() {
    return '''
Position Rating Statistics ($totalPlayers players):
  OH:  ${oh.toString()}
  OPP: ${opp.toString()}
  MB:  ${mb.toString()}
  S:   ${s.toString()}
  L:   ${l.toString()}
''';
  }
}

class PositionStatDetail {
  final double min;
  final double max;
  final double avg;
  final double median;

  PositionStatDetail({
    required this.min,
    required this.max,
    required this.avg,
    required this.median,
  });

  @override
  String toString() {
    return 'min: ${min.toStringAsFixed(1)}, '
           'max: ${max.toStringAsFixed(1)}, '
           'avg: ${avg.toStringAsFixed(1)}, '
           'median: ${median.toStringAsFixed(1)}';
  }
}

class _PositionStatDetail {
  final List<double> _values = [];

  void addValue(double value) => _values.add(value);

  PositionStatDetail toStats() {
    if (_values.isEmpty) {
      return PositionStatDetail(min: 0, max: 0, avg: 0, median: 0);
    }

    _values.sort();

    final min = _values.first;
    final max = _values.last;
    final avg = _values.reduce((a, b) => a + b) / _values.length;
    final median = _values[_values.length ~/ 2];

    return PositionStatDetail(min: min, max: max, avg: avg, median: median);
  }
}
