// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamStatsImpl _$$TeamStatsImplFromJson(Map<String, dynamic> json) =>
    _$TeamStatsImpl(
      points: (json['points'] as num?)?.toInt() ?? 0,
      serveAces: (json['serveAces'] as num?)?.toInt() ?? 0,
      serveFaults: (json['serveFaults'] as num?)?.toInt() ?? 0,
      kills: (json['kills'] as num?)?.toInt() ?? 0,
      attackErrors: (json['attackErrors'] as num?)?.toInt() ?? 0,
      attacksBlocked: (json['attacksBlocked'] as num?)?.toInt() ?? 0,
      blocksWon: (json['blocksWon'] as num?)?.toInt() ?? 0,
      digs: (json['digs'] as num?)?.toInt() ?? 0,
      perfectPasses: (json['perfectPasses'] as num?)?.toInt() ?? 0,
      totalPasses: (json['totalPasses'] as num?)?.toInt() ?? 0,
      sideouts: (json['sideouts'] as num?)?.toInt() ?? 0,
      sideoutAttempts: (json['sideoutAttempts'] as num?)?.toInt() ?? 0,
      totalRallies: (json['totalRallies'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TeamStatsImplToJson(_$TeamStatsImpl instance) =>
    <String, dynamic>{
      'points': instance.points,
      'serveAces': instance.serveAces,
      'serveFaults': instance.serveFaults,
      'kills': instance.kills,
      'attackErrors': instance.attackErrors,
      'attacksBlocked': instance.attacksBlocked,
      'blocksWon': instance.blocksWon,
      'digs': instance.digs,
      'perfectPasses': instance.perfectPasses,
      'totalPasses': instance.totalPasses,
      'sideouts': instance.sideouts,
      'sideoutAttempts': instance.sideoutAttempts,
      'totalRallies': instance.totalRallies,
    };

_$MatchStatsImpl _$$MatchStatsImplFromJson(Map<String, dynamic> json) =>
    _$MatchStatsImpl(
      home: json['home'] == null
          ? const TeamStats()
          : TeamStats.fromJson(json['home'] as Map<String, dynamic>),
      away: json['away'] == null
          ? const TeamStats()
          : TeamStats.fromJson(json['away'] as Map<String, dynamic>),
      playLog: (json['playLog'] as List<dynamic>?)
              ?.map((e) => PlayAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MatchStatsImplToJson(_$MatchStatsImpl instance) =>
    <String, dynamic>{
      'home': instance.home,
      'away': instance.away,
      'playLog': instance.playLog,
    };
