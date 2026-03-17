// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayActionImpl _$$PlayActionImplFromJson(Map<String, dynamic> json) =>
    _$PlayActionImpl(
      rallyId: (json['rallyId'] as num).toInt(),
      rotationTick: (json['rotationTick'] as num).toInt(),
      side: $enumDecode(_$TeamSideEnumMap, json['side']),
      type: $enumDecode(_$PlayTypeEnumMap, json['type']),
      outcome: json['outcome'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$PlayActionImplToJson(_$PlayActionImpl instance) =>
    <String, dynamic>{
      'rallyId': instance.rallyId,
      'rotationTick': instance.rotationTick,
      'side': _$TeamSideEnumMap[instance.side]!,
      'type': _$PlayTypeEnumMap[instance.type]!,
      'outcome': instance.outcome,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$TeamSideEnumMap = {TeamSide.home: 'home', TeamSide.away: 'away'};

const _$PlayTypeEnumMap = {
  PlayType.serve: 'serve',
  PlayType.pass: 'pass',
  PlayType.set: 'set',
  PlayType.attack: 'attack',
};
