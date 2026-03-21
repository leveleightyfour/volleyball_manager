import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volleyball_manager/core/db/database.dart';
import 'package:volleyball_manager/features/player/data/dto/player_dto.dart';
import 'match_roster.dart';

/// Loads the active match roster from the database.
///
/// Uses a raw SQL join on team_players + players so it works even before
/// build_runner regenerates the typed table accessors.
final matchRosterProvider = FutureProvider<MatchRoster>((ref) async {
  final db = ref.read(databaseProvider);
  return _buildRoster(db);
});

/// Synchronous cached roster — populated once and reused by the sim strategy.
final matchRosterCacheProvider =
    StateNotifierProvider<MatchRosterNotifier, MatchRoster>(
  (ref) => MatchRosterNotifier(ref),
);

class MatchRosterNotifier extends StateNotifier<MatchRoster> {
  MatchRosterNotifier(this._ref) : super(MatchRoster.empty) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    final db = _ref.read(databaseProvider);
    state = await _buildRoster(db);
  }
}

Future<MatchRoster> _buildRoster(AppDatabase db) async {
  // Raw SQL join so we don't depend on generated teamPlayers accessor.
  final rows = await db.customSelect(
    'SELECT p.id, p.name, '
    'p.wrist_snap, p.power, p.accuracy, p.aggression, '
    'p.strength, p.positioning, p.predictability, p.creativity, '
    'p.penetration, p.height, p.form, p.anticipation, '
    'p.footwork, p.platform, p.stability, p.touch, '
    'p.vision, p.timing, p.versatility, '
    'p.reaction, p.reading, p.intention, p.control, '
    'p.rating_oh, p.rating_opp, p.rating_mb, p.rating_s, p.rating_l, '
    'p.created_at, p.updated_at, '
    'tp.team_id, tp.role_tag '
    'FROM players p '
    'JOIN team_players tp ON p.id = tp.player_id '
    'ORDER BY tp.team_id, tp.rotation_order',
    variables: [],
    readsFrom: {},
  ).get();

  final homeMap = <String, PlayerDto>{};
  final awayMap = <String, PlayerDto>{};

  for (final row in rows) {
    final data = row.data;
    final teamId = data['team_id'] as int;
    final roleTag = data['role_tag'] as String;

    final dto = _rowToDto(data);
    if (teamId == 1) {
      homeMap[roleTag] = dto;
    } else {
      awayMap[roleTag] = dto;
    }
  }

  return MatchRoster(home: homeMap, away: awayMap);
}

PlayerDto _rowToDto(Map<String, Object?> d) {
  DateTime parseDate(Object? v) {
    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v * 1000);
    if (v is String) return DateTime.parse(v);
    return DateTime.now();
  }

  return PlayerDto(
    id: d['id'] as int,
    name: d['name'] as String,
    wristSnap: (d['wrist_snap'] as int?) ?? 10,
    power: (d['power'] as int?) ?? 10,
    accuracy: (d['accuracy'] as int?) ?? 10,
    aggression: (d['aggression'] as int?) ?? 10,
    strength: (d['strength'] as int?) ?? 10,
    positioning: (d['positioning'] as int?) ?? 10,
    predictability: (d['predictability'] as int?) ?? 10,
    creativity: (d['creativity'] as int?) ?? 10,
    penetration: (d['penetration'] as int?) ?? 10,
    height: (d['height'] as int?) ?? 10,
    form: (d['form'] as int?) ?? 10,
    anticipation: (d['anticipation'] as int?) ?? 10,
    footwork: (d['footwork'] as int?) ?? 10,
    platform: (d['platform'] as int?) ?? 10,
    stability: (d['stability'] as int?) ?? 10,
    touch: (d['touch'] as int?) ?? 10,
    vision: (d['vision'] as int?) ?? 10,
    timing: (d['timing'] as int?) ?? 10,
    versatility: (d['versatility'] as int?) ?? 10,
    reaction: (d['reaction'] as int?) ?? 10,
    reading: (d['reading'] as int?) ?? 10,
    intention: (d['intention'] as int?) ?? 10,
    control: (d['control'] as int?) ?? 10,
    ratingOh: (d['rating_oh'] as num?)?.toDouble() ?? 10.0,
    ratingOpp: (d['rating_opp'] as num?)?.toDouble() ?? 10.0,
    ratingMb: (d['rating_mb'] as num?)?.toDouble() ?? 10.0,
    ratingS: (d['rating_s'] as num?)?.toDouble() ?? 10.0,
    ratingL: (d['rating_l'] as num?)?.toDouble() ?? 10.0,
    createdAt: parseDate(d['created_at']),
    updatedAt: parseDate(d['updated_at']),
  );
}
