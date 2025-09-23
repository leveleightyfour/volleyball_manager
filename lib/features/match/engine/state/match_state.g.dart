// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScoreImpl _$$ScoreImplFromJson(Map<String, dynamic> json) => _$ScoreImpl(
  home: (json['home'] as num?)?.toInt() ?? 0,
  away: (json['away'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$ScoreImplToJson(_$ScoreImpl instance) =>
    <String, dynamic>{'home': instance.home, 'away': instance.away};

_$MatchStateImpl _$$MatchStateImplFromJson(Map<String, dynamic> json) =>
    _$MatchStateImpl(
      rallyId: (json['rallyId'] as num).toInt(),
      rotationTick: (json['rotationTick'] as num).toInt(),
      serverSide: $enumDecode(_$TeamSideEnumMap, json['serverSide']),
      score: Score.fromJson(json['score'] as Map<String, dynamic>),
      phase: $enumDecode(_$MatchPhaseEnumMap, json['phase']),
      serverPlayerId: json['serverPlayerId'] as String? ?? null,
      receiverPlayerId: json['receiverPlayerId'] as String? ?? null,
    );

Map<String, dynamic> _$$MatchStateImplToJson(_$MatchStateImpl instance) =>
    <String, dynamic>{
      'rallyId': instance.rallyId,
      'rotationTick': instance.rotationTick,
      'serverSide': _$TeamSideEnumMap[instance.serverSide]!,
      'score': instance.score,
      'phase': _$MatchPhaseEnumMap[instance.phase]!,
      'serverPlayerId': instance.serverPlayerId,
      'receiverPlayerId': instance.receiverPlayerId,
    };

const _$TeamSideEnumMap = {TeamSide.home: 'home', TeamSide.away: 'away'};

const _$MatchPhaseEnumMap = {
  MatchPhase.preServe: 'preServe',
  MatchPhase.serve: 'serve',
  MatchPhase.reception: 'reception',
  MatchPhase.setting: 'setting',
  MatchPhase.attack: 'attack',
  MatchPhase.rallyEnd: 'rallyEnd',
};
