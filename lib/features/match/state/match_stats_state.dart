// lib/features/match/state/match_stats_state.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'match_state.dart' show TeamSide;

/// Mutable per-skill statistics bucket.
class SkillStats {
  int attempts = 0;
  final Map<String, int> results = {};

  void record(String result) {
    attempts++;
    results[result] = (results[result] ?? 0) + 1;
  }

  int count(String result) => results[result] ?? 0;

  void reset() {
    attempts = 0;
    results.clear();
  }
}

/// All tracked skills for one team.
class TeamMatchStats {
  final serve = SkillStats();
  final pass = SkillStats();
  final set = SkillStats();
  final attack = SkillStats();

  void reset() {
    serve.reset();
    pass.reset();
    set.reset();
    attack.reset();
  }
}

/// Per-player stats across all skills they participate in.
class PlayerMatchStats {
  PlayerMatchStats({
    required this.playerId,
    required this.playerName,
    required this.side,
  });

  final int playerId;
  final String playerName;
  final TeamSide side;

  final serve = SkillStats();
  final pass = SkillStats();
  final set = SkillStats();
  final attack = SkillStats();

  void reset() {
    serve.reset();
    pass.reset();
    set.reset();
    attack.reset();
  }
}

/// In-memory live statistics accumulator.
///
/// Updated synchronously inside [AuditLogService] whenever an outcome is
/// logged. Tracks both per-team aggregates and per-player breakdowns.
class MatchStatsNotifier extends ChangeNotifier {
  MatchStatsNotifier._internal();
  static final MatchStatsNotifier I = MatchStatsNotifier._internal();

  /// Returns a new isolated instance for headless/simulation use.
  factory MatchStatsNotifier.fresh() => MatchStatsNotifier._internal();

  final home = TeamMatchStats();
  final away = TeamMatchStats();

  // ── Score ────────────────────────────────────────────────────────────────

  int homeScore = 0;
  int awayScore = 0;

  void updateScore(int home, int away) {
    homeScore = home;
    awayScore = away;
    notifyListeners();
  }

  /// All players seen this match, keyed by player ID.
  final Map<int, PlayerMatchStats> byPlayer = {};

  // ── Team + player recording ──────────────────────────────────────────────

  void recordServe(
    TeamSide side,
    String result, {
    int? playerId,
    String? playerName,
  }) {
    _teamStats(side).serve.record(result);
    if (playerId != null) {
      _playerStats(playerId, playerName ?? '?', side).serve.record(result);
    }
    notifyListeners();
  }

  void recordPass(
    TeamSide side,
    String result, {
    int? playerId,
    String? playerName,
  }) {
    _teamStats(side).pass.record(result);
    if (playerId != null) {
      _playerStats(playerId, playerName ?? '?', side).pass.record(result);
    }
    notifyListeners();
  }

  void recordSet(
    TeamSide side,
    String result, {
    int? playerId,
    String? playerName,
  }) {
    _teamStats(side).set.record(result);
    if (playerId != null) {
      _playerStats(playerId, playerName ?? '?', side).set.record(result);
    }
    notifyListeners();
  }

  void recordAttack(
    TeamSide side,
    String result, {
    int? playerId,
    String? playerName,
  }) {
    _teamStats(side).attack.record(result);
    if (playerId != null) {
      _playerStats(playerId, playerName ?? '?', side).attack.record(result);
    }
    notifyListeners();
  }

  void reset() {
    homeScore = 0;
    awayScore = 0;
    home.reset();
    away.reset();
    byPlayer.clear();
    notifyListeners();
  }

  // ── Accessors ────────────────────────────────────────────────────────────

  /// Players on a given side, sorted alphabetically.
  List<PlayerMatchStats> playersFor(TeamSide side) => byPlayer.values
      .where((p) => p.side == side)
      .toList()
    ..sort((a, b) => a.playerName.compareTo(b.playerName));

  // ── Private helpers ──────────────────────────────────────────────────────

  TeamMatchStats _teamStats(TeamSide side) =>
      side == TeamSide.home ? home : away;

  PlayerMatchStats _playerStats(int id, String name, TeamSide side) =>
      byPlayer.putIfAbsent(
          id, () => PlayerMatchStats(playerId: id, playerName: name, side: side));
}

final matchStatsProvider =
    ChangeNotifierProvider<MatchStatsNotifier>((_) => MatchStatsNotifier.I);
