// lib/features/match/data/services/audit_log_service.dart
import 'dart:convert';
import 'package:drift/drift.dart' show Variable;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volleyball_manager/core/db/database.dart';
import 'package:volleyball_manager/features/match/state/match_state.dart';
import 'package:volleyball_manager/features/match/state/match_stats_state.dart';
import 'package:volleyball_manager/features/player/data/dto/player_dto.dart';
import 'package:volleyball_manager/shared/log/live_log.dart';

/// Records every outcome event during a match with full diagnostic context,
/// pushes a formatted human-readable line to the live log display, and
/// updates the in-memory [MatchStatsNotifier] for the stats overlay.
class AuditLogService {
  AuditLogService(this._db, this._ref, {bool headless = false})
      : _headless = headless;

  final AppDatabase _db;
  final Ref _ref;
  final bool _headless;
  int _matchId = 0;

  // ── Match lifecycle ──────────────────────────────────────────────────────

  Future<int> startMatch({int homeTeamId = 1, int awayTeamId = 2}) async {
    _matchId = await _db.customInsert(
      'INSERT INTO matches (home_team_id, away_team_id) VALUES (?, ?)',
      variables: [
        Variable.withInt(homeTeamId),
        Variable.withInt(awayTeamId),
      ],
    );
    return _matchId;
  }

  Future<void> completeMatch(int homeScore, int awayScore) async {
    await _db.customUpdate(
      'UPDATE matches SET home_score = ?, away_score = ?, is_complete = 1, '
      'completed_at = ? WHERE id = ?',
      variables: [
        Variable.withInt(homeScore),
        Variable.withInt(awayScore),
        Variable.withString(DateTime.now().toIso8601String()),
        Variable.withInt(_matchId),
      ],
    );
  }

  int get currentMatchId => _matchId;

  // ── Core log entry ───────────────────────────────────────────────────────

  Future<void> _log({
    required int rallyId,
    required String phase,
    required String eventType,
    required Map<String, dynamic> payload,
  }) async {
    await _db.customInsert(
      'INSERT INTO match_audit_log '
      '(match_id, rally_id, phase, event_type, payload) '
      'VALUES (?, ?, ?, ?, ?)',
      variables: [
        Variable.withInt(_matchId),
        Variable.withInt(rallyId),
        Variable.withString(phase),
        Variable.withString(eventType),
        Variable.withString(jsonEncode(payload)),
      ],
    );

    // Push a formatted line to the live audit display (skip in headless mode).
    if (!_headless) {
      final line = _formatLine(rallyId, eventType, payload);
      LiveLog.I.add(line);
    }
  }

  // ── Display formatting ───────────────────────────────────────────────────

  LogLine _formatLine(
      int rallyId, String eventType, Map<String, dynamic> payload) {
    final r = 'R$rallyId';

    switch (eventType) {
      case 'serveOutcome':
        final name = _playerName(payload, 'server');
        final skill = _playerSkill(payload, 'server');
        final result = payload['result'] as String? ?? '';
        final diff = (payload['differential'] as num?)?.toDouble() ?? 0.0;
        final zone = payload['serveZone'] as String? ?? '';
        final diffStr = '${diff >= 0 ? "+" : ""}${diff.toStringAsFixed(1)}';
        final text =
            '$r  SRV  $name (${skill.toStringAsFixed(1)}) → ${result.toUpperCase()}  diff=$diffStr  $zone';
        final color = switch (result) {
          'ace' => Colors.greenAccent,
          'error' => Colors.redAccent,
          _ => Colors.white,
        };
        return LogLine(text, color: color);

      case 'passOutcome':
        final name = _playerName(payload, 'passer');
        final skill = _playerSkill(payload, 'passer');
        final result = payload['result'] as String? ?? '';
        final n = payload['numPassers'] as int? ?? 0;
        final isAce = result == 'shank';
        final label = isAce ? 'SHANK (ACE)' : result.toUpperCase();
        final text =
            '$r  PSS  $name (${skill.toStringAsFixed(1)}) → $label  n=$n';
        final color = switch (result) {
          'perfect' => const Color(0xFF80FF80),
          'shank'   => Colors.greenAccent,
          'overpass' => Colors.redAccent,
          _ => Colors.white70,
        };
        return LogLine(text, color: color);

      case 'setOutcome':
        final name = _playerName(payload, 'setter');
        final skill = _playerSkill(payload, 'setter');
        final result = payload['result'] as String? ?? '';
        final passQ = payload['passQuality'] as String? ?? '';
        final text =
            '$r  SET  $name (${skill.toStringAsFixed(1)}) → $result  pass=$passQ';
        return LogLine(text, color: Colors.cyanAccent.shade100);

      case 'attackOutcome':
        final name = _playerName(payload, 'attacker');
        final skill = _playerSkill(payload, 'attacker');
        final result = payload['result'] as String? ?? '';
        final set = payload['setOutcome'] as String? ?? '';
        final dir = payload['attackDirection'] as String? ?? '';
        final diff =
            (payload['atkVsBlockDifferential'] as num?)?.toDouble() ?? 0.0;
        final diffStr = '${diff >= 0 ? "+" : ""}${diff.toStringAsFixed(1)}';
        final text =
            '$r  ATK  $name (${skill.toStringAsFixed(1)}) → ${result.toUpperCase()}  [$set / $dir]  blkDiff=$diffStr';
        final color = switch (result) {
          'kill' => Colors.greenAccent,
          'blocked' || 'error' => Colors.redAccent,
          _ => Colors.amber,
        };
        return LogLine(text, color: color);

      case 'rallyEnd':
        final pointTo = payload['pointTo'] as String? ?? '';
        final scoreH =
            (payload['score'] as Map<String, dynamic>?)?['home'] ?? 0;
        final scoreA =
            (payload['score'] as Map<String, dynamic>?)?['away'] ?? 0;
        final text = '$r  ───  ★ ${pointTo.toUpperCase()}  $scoreH–$scoreA';
        return LogLine(text, color: Colors.yellowAccent);

      default:
        return LogLine('$r  $eventType', color: Colors.white38);
    }
  }

  String _playerName(Map<String, dynamic> payload, String key) {
    final p = payload[key] as Map<String, dynamic>?;
    return p?['playerName'] as String? ?? '?';
  }

  double _playerSkill(Map<String, dynamic> payload, String key) {
    final p = payload[key] as Map<String, dynamic>?;
    return (p?['skill'] as num?)?.toDouble() ?? 0.0;
  }

  // ── Outcome helpers ──────────────────────────────────────────────────────

  Map<String, dynamic> _stateContext(MatchState s) => {
        'score': {'home': s.score.home, 'away': s.score.away},
        'rotationHome': ((s.rotationTick ~/ 2) % 6) + 1,
        'rotationAway': (((s.rotationTick + 1) ~/ 2) % 6) + 1,
        'serverSide': s.serverSide.name,
        'rallyId': s.rallyId,
      };

  Map<String, dynamic> _playerComparison({
    required String label,
    required PlayerDto? player,
    required double skill,
    required String skillKey,
  }) =>
      {
        'label': label,
        'playerId': player?.id,
        'playerName': player?.name ?? 'unknown',
        'skill': double.parse(skill.toStringAsFixed(2)),
        'skillKey': skillKey,
      };

  // ── Serve ────────────────────────────────────────────────────────────────

  Future<void> logServeOutcome({
    required MatchState state,
    required String result,
    required PlayerDto? server,
    required double serverSkill,
    required String serverSkillKey,
    required PlayerDto? receiver,
    required double receiverSkill,
    required String receiverSkillKey,
    required double differential,
    required Map<String, double> probabilities,
    required String serveZone,
  }) async {
    _ref.read(matchStatsProvider).recordServe(
      state.serverSide, result,
      playerId: server?.id, playerName: server?.name,
    );

    await _log(
      rallyId: state.rallyId,
      phase: state.phase.name,
      eventType: 'serveOutcome',
      payload: {
        ..._stateContext(state),
        'result': result,
        'serveZone': serveZone,
        'server': _playerComparison(
            label: 'server',
            player: server,
            skill: serverSkill,
            skillKey: serverSkillKey),
        'receiver': _playerComparison(
            label: 'receiver',
            player: receiver,
            skill: receiverSkill,
            skillKey: receiverSkillKey),
        'differential': double.parse(differential.toStringAsFixed(2)),
        'probabilities': probabilities
            .map((k, v) => MapEntry(k, double.parse(v.toStringAsFixed(3)))),
      },
    );
  }

  // ── Pass / Reception ─────────────────────────────────────────────────────

  Future<void> logPassOutcome({
    required MatchState state,
    required TeamSide passingSide,
    required String result,
    required PlayerDto? passer,
    required double passerSkill,
    required String skillKey,
    required int numPassers,
    required double modifiedProbPerfect,
    PlayerDto? server,
    TeamSide? serverSide,
  }) async {
    _ref.read(matchStatsProvider).recordPass(
      passingSide, result,
      playerId: passer?.id, playerName: passer?.name,
    );
    // A shank is attributed as an ace to the server.
    if (result == 'shank' && serverSide != null) {
      _ref.read(matchStatsProvider).recordServe(
        serverSide, 'ace',
        playerId: server?.id, playerName: server?.name,
      );
    }

    await _log(
      rallyId: state.rallyId,
      phase: state.phase.name,
      eventType: 'passOutcome',
      payload: {
        ..._stateContext(state),
        'result': result,
        'numPassers': numPassers,
        'passer': _playerComparison(
            label: 'passer',
            player: passer,
            skill: passerSkill,
            skillKey: skillKey),
        'probPerfect': double.parse(modifiedProbPerfect.toStringAsFixed(3)),
      },
    );
  }

  // ── Set ──────────────────────────────────────────────────────────────────

  Future<void> logSetOutcome({
    required MatchState state,
    required TeamSide attackingSide,
    required String result,
    required PlayerDto? setter,
    required double setterSkill,
    required String skillKey,
    required String passQuality,
    required Map<String, double> weights,
  }) async {
    _ref.read(matchStatsProvider).recordSet(
      attackingSide, result,
      playerId: setter?.id, playerName: setter?.name,
    );

    await _log(
      rallyId: state.rallyId,
      phase: state.phase.name,
      eventType: 'setOutcome',
      payload: {
        ..._stateContext(state),
        'result': result,
        'passQuality': passQuality,
        'setter': _playerComparison(
            label: 'setter',
            player: setter,
            skill: setterSkill,
            skillKey: skillKey),
        'setWeights': weights
            .map((k, v) => MapEntry(k, double.parse(v.toStringAsFixed(3)))),
      },
    );
  }

  // ── Attack ───────────────────────────────────────────────────────────────

  Future<void> logAttackOutcome({
    required MatchState state,
    required TeamSide attackingSide,
    required String result,
    required PlayerDto? attacker,
    required double attackerSkill,
    required String attackerSkillKey,
    required List<PlayerDto> blockers,
    required double blockAggregate,
    required double atkVsBlockDiff,
    required Map<String, double> atkVsBlockProbs,
    required List<PlayerDto> defenders,
    required double defAggregate,
    required double atkVsDefDiff,
    required Map<String, double> atkVsDefProbs,
    required String attackDirection,
    required String setOutcome,
  }) async {
    _ref.read(matchStatsProvider).recordAttack(
      attackingSide, result,
      playerId: attacker?.id, playerName: attacker?.name,
    );

    await _log(
      rallyId: state.rallyId,
      phase: state.phase.name,
      eventType: 'attackOutcome',
      payload: {
        ..._stateContext(state),
        'result': result,
        'setOutcome': setOutcome,
        'attackDirection': attackDirection,
        'attacker': _playerComparison(
            label: 'attacker',
            player: attacker,
            skill: attackerSkill,
            skillKey: attackerSkillKey),
        'blockers': blockers.map((b) => b.name).toList(),
        'blockAggregate': double.parse(blockAggregate.toStringAsFixed(2)),
        'atkVsBlockDifferential':
            double.parse(atkVsBlockDiff.toStringAsFixed(2)),
        'atkVsBlockProbabilities': atkVsBlockProbs
            .map((k, v) => MapEntry(k, double.parse(v.toStringAsFixed(3)))),
        'defenders': defenders.map((d) => d.name).toList(),
        'defAggregate': double.parse(defAggregate.toStringAsFixed(2)),
        'atkVsDefDifferential': double.parse(atkVsDefDiff.toStringAsFixed(2)),
        'atkVsDefProbabilities': atkVsDefProbs
            .map((k, v) => MapEntry(k, double.parse(v.toStringAsFixed(3)))),
      },
    );
  }

  // ── Rally lifecycle ──────────────────────────────────────────────────────

  Future<void> logRallyEnd({
    required MatchState state,
    required String pointTo,
  }) =>
      _log(
        rallyId: state.rallyId,
        phase: state.phase.name,
        eventType: 'rallyEnd',
        payload: {
          ..._stateContext(state),
          'pointTo': pointTo,
        },
      );
}

final auditLogServiceProvider = Provider<AuditLogService>((ref) {
  return AuditLogService(ref.read(databaseProvider), ref);
});

final auditLogServiceHeadlessProvider = Provider<AuditLogService>((ref) {
  return AuditLogService(ref.read(databaseProvider), ref, headless: true);
});
