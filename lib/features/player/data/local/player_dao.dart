import 'package:drift/drift.dart';
import 'package:volleyball_manager/core/db/database.dart';
import 'player_tables.dart';

part 'player_dao.g.dart';

@DriftAccessor(tables: [Players])
class PlayerDao extends DatabaseAccessor<AppDatabase> with _$PlayerDaoMixin {
  PlayerDao(super.db);

  Future<int> insertPlayer(String name) =>
      into(players).insert(PlayersCompanion.insert(name: name));

  Future<List<Player>> getAll() => select(players).get();
  Stream<List<Player>> watchAll() => select(players).watch();

  Future<Player?> getById(int id) =>
      (select(players)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<bool> rename(int id, String name) =>
      (update(players)..where((t) => t.id.equals(id)))
          .write(PlayersCompanion(name: Value(name)))
          .then((rows) => rows > 0);

  Future<int> deleteById(int id) =>
      (delete(players)..where((t) => t.id.equals(id))).go();

  /// Update position ratings for a player
  Future<bool> updatePositionRatings(
    int id, {
    required double oh,
    required double opp,
    required double mb,
    required double s,
    required double l,
  }) =>
      (update(players)..where((t) => t.id.equals(id)))
          .write(PlayersCompanion(
            ratingOh: Value(oh),
            ratingOpp: Value(opp),
            ratingMb: Value(mb),
            ratingS: Value(s),
            ratingL: Value(l),
          ))
          .then((rows) => rows > 0);

  /// Batch update position ratings for multiple players (MUCH faster for bulk updates)
  ///
  /// Use this when updating ratings for many players at once (e.g., formula rebalancing).
  /// This is ~10-100x faster than individual updates because it uses a single transaction.
  ///
  /// [updates] Map of playerId -> position ratings map
  /// Example: {1: {'oh': 15.0, 'opp': 14.0, ...}, 2: {...}, ...}
  Future<void> batchUpdatePositionRatings(
    Map<int, Map<String, double>> updates,
  ) async {
    await db.batch((batch) {
      for (final entry in updates.entries) {
        final playerId = entry.key;
        final ratings = entry.value;

        batch.update(
          players,
          PlayersCompanion(
            ratingOh: Value(ratings['oh']!),
            ratingOpp: Value(ratings['opp']!),
            ratingMb: Value(ratings['mb']!),
            ratingS: Value(ratings['s']!),
            ratingL: Value(ratings['l']!),
          ),
          where: (t) => t.id.equals(playerId),
        );
      }
    });
  }

  /// Get all players belonging to a specific team via team_players join.
  /// Uses raw SQL to avoid dependency on not-yet-generated Drift accessors.
  Future<List<Player>> getByTeamId(int teamId) async {
    final idRows = await db.customSelect(
      'SELECT player_id FROM team_players WHERE team_id = ?',
      variables: [Variable.withInt(teamId)],
      readsFrom: {},
    ).get();
    final ids = idRows.map((r) => r.read<int>('player_id')).toList();
    if (ids.isEmpty) return [];
    return (select(players)..where((p) => p.id.isIn(ids))).get();
  }

  /// Query players by minimum rating for a specific position
  ///
  /// Essential for Football Manager-style transfer market filtering
  /// Example: "Find all Outside Hitters with rating >= 15"
  Future<List<Player>> getPlayersByPositionRating(
    String position,
    double minRating, {
    int? limit,
  }) async {
    final query = select(players);

    // Add position-specific rating filter
    switch (position) {
      case 'oh':
        query.where((t) => t.ratingOh.isBiggerOrEqualValue(minRating));
      case 'opp':
        query.where((t) => t.ratingOpp.isBiggerOrEqualValue(minRating));
      case 'mb':
        query.where((t) => t.ratingMb.isBiggerOrEqualValue(minRating));
      case 's':
        query.where((t) => t.ratingS.isBiggerOrEqualValue(minRating));
      case 'l':
        query.where((t) => t.ratingL.isBiggerOrEqualValue(minRating));
      default:
        throw ArgumentError('Invalid position: $position');
    }

    // Add limit if specified
    if (limit != null) {
      query.limit(limit);
    }

    return query.get();
  }

  /// Get top N players for a specific position (sorted by rating descending)
  ///
  /// Perfect for "Best Setters in the League" queries
  Future<List<Player>> getTopPlayersByPosition(
    String position, {
    int limit = 10,
  }) async {
    final query = select(players);

    // Sort by position-specific rating
    switch (position) {
      case 'oh':
        query.orderBy([(t) => OrderingTerm.desc(t.ratingOh)]);
      case 'opp':
        query.orderBy([(t) => OrderingTerm.desc(t.ratingOpp)]);
      case 'mb':
        query.orderBy([(t) => OrderingTerm.desc(t.ratingMb)]);
      case 's':
        query.orderBy([(t) => OrderingTerm.desc(t.ratingS)]);
      case 'l':
        query.orderBy([(t) => OrderingTerm.desc(t.ratingL)]);
      default:
        throw ArgumentError('Invalid position: $position');
    }

    query.limit(limit);
    return query.get();
  }

  /// Get players within a rating range for a position
  ///
  /// Useful for scouting: "Show me setters rated 12-15"
  Future<List<Player>> getPlayersByPositionRatingRange(
    String position,
    double minRating,
    double maxRating, {
    int? limit,
  }) async {
    final query = select(players);

    switch (position) {
      case 'oh':
        query.where((t) =>
            t.ratingOh.isBiggerOrEqualValue(minRating) &
            t.ratingOh.isSmallerOrEqualValue(maxRating));
      case 'opp':
        query.where((t) =>
            t.ratingOpp.isBiggerOrEqualValue(minRating) &
            t.ratingOpp.isSmallerOrEqualValue(maxRating));
      case 'mb':
        query.where((t) =>
            t.ratingMb.isBiggerOrEqualValue(minRating) &
            t.ratingMb.isSmallerOrEqualValue(maxRating));
      case 's':
        query.where((t) =>
            t.ratingS.isBiggerOrEqualValue(minRating) &
            t.ratingS.isSmallerOrEqualValue(maxRating));
      case 'l':
        query.where((t) =>
            t.ratingL.isBiggerOrEqualValue(minRating) &
            t.ratingL.isSmallerOrEqualValue(maxRating));
      default:
        throw ArgumentError('Invalid position: $position');
    }

    if (limit != null) {
      query.limit(limit);
    }

    return query.get();
  }
}
