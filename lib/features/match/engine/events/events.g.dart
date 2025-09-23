// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServeBallFlightImpl _$$ServeBallFlightImplFromJson(
  Map<String, dynamic> json,
) => _$ServeBallFlightImpl(
  fromSide: $enumDecode(_$TeamSideEnumMap, json['fromSide']),
  durationSec: (json['durationSec'] as num).toDouble(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$ServeBallFlightImplToJson(
  _$ServeBallFlightImpl instance,
) => <String, dynamic>{
  'fromSide': _$TeamSideEnumMap[instance.fromSide]!,
  'durationSec': instance.durationSec,
  'runtimeType': instance.$type,
};

const _$TeamSideEnumMap = {TeamSide.home: 'home', TeamSide.away: 'away'};

_$PlayerMoveImpl _$$PlayerMoveImplFromJson(Map<String, dynamic> json) =>
    _$PlayerMoveImpl(
      playerId: (json['playerId'] as num).toInt(),
      toX: (json['toX'] as num).toDouble(),
      toY: (json['toY'] as num).toDouble(),
      durationSec: (json['durationSec'] as num?)?.toDouble() ?? 0.5,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PlayerMoveImplToJson(_$PlayerMoveImpl instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'toX': instance.toX,
      'toY': instance.toY,
      'durationSec': instance.durationSec,
      'runtimeType': instance.$type,
    };

_$ScoreChangedImpl _$$ScoreChangedImplFromJson(Map<String, dynamic> json) =>
    _$ScoreChangedImpl(
      home: (json['home'] as num).toInt(),
      away: (json['away'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ScoreChangedImplToJson(_$ScoreChangedImpl instance) =>
    <String, dynamic>{
      'home': instance.home,
      'away': instance.away,
      'runtimeType': instance.$type,
    };

_$RotationAdvancedImpl _$$RotationAdvancedImplFromJson(
  Map<String, dynamic> json,
) => _$RotationAdvancedImpl(
  rotationTick: (json['rotationTick'] as num).toInt(),
  serverSide: $enumDecode(_$TeamSideEnumMap, json['serverSide']),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$RotationAdvancedImplToJson(
  _$RotationAdvancedImpl instance,
) => <String, dynamic>{
  'rotationTick': instance.rotationTick,
  'serverSide': _$TeamSideEnumMap[instance.serverSide]!,
  'runtimeType': instance.$type,
};

_$PhaseChangedImpl _$$PhaseChangedImplFromJson(Map<String, dynamic> json) =>
    _$PhaseChangedImpl(
      phase: $enumDecode(_$MatchPhaseEnumMap, json['phase']),
      rallyId: (json['rallyId'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PhaseChangedImplToJson(_$PhaseChangedImpl instance) =>
    <String, dynamic>{
      'phase': _$MatchPhaseEnumMap[instance.phase]!,
      'rallyId': instance.rallyId,
      'runtimeType': instance.$type,
    };

const _$MatchPhaseEnumMap = {
  MatchPhase.preServe: 'preServe',
  MatchPhase.serve: 'serve',
  MatchPhase.reception: 'reception',
  MatchPhase.setting: 'setting',
  MatchPhase.attack: 'attack',
  MatchPhase.rallyEnd: 'rallyEnd',
};

_$RallyEndedImpl _$$RallyEndedImplFromJson(Map<String, dynamic> json) =>
    _$RallyEndedImpl(
      pointTo: $enumDecode(_$TeamSideEnumMap, json['pointTo']),
      rallyId: (json['rallyId'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$RallyEndedImplToJson(_$RallyEndedImpl instance) =>
    <String, dynamic>{
      'pointTo': _$TeamSideEnumMap[instance.pointTo]!,
      'rallyId': instance.rallyId,
      'runtimeType': instance.$type,
    };
