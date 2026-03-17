import 'package:freezed_annotation/freezed_annotation.dart';
import 'play_action.dart';

part 'match_stats.freezed.dart';
part 'match_stats.g.dart';

@freezed
class TeamStats with _$TeamStats {
  const factory TeamStats({
    @Default(0) int points,
    @Default(0) int serveAces,
    @Default(0) int serveFaults,
    @Default(0) int kills,
    @Default(0) int attackErrors,
    @Default(0) int attacksBlocked,
    @Default(0) int blocksWon,
    @Default(0) int digs,
    @Default(0) int perfectPasses,
    @Default(0) int totalPasses,
    @Default(0) int sideouts,
    @Default(0) int sideoutAttempts,
    @Default(0) int totalRallies,
  }) = _TeamStats;

  factory TeamStats.fromJson(Map<String, dynamic> json) =>
      _$TeamStatsFromJson(json);
}

@freezed
class MatchStats with _$MatchStats {
  const factory MatchStats({
    @Default(TeamStats()) TeamStats home,
    @Default(TeamStats()) TeamStats away,
    @Default([]) List<PlayAction> playLog,
  }) = _MatchStats;

  factory MatchStats.fromJson(Map<String, dynamic> json) =>
      _$MatchStatsFromJson(json);
}
