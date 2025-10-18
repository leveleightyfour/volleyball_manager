// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_lite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerLiteImpl _$$PlayerLiteImplFromJson(Map<String, dynamic> json) =>
    _$PlayerLiteImpl(
      id: (json['id'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      role: $enumDecode(_$RoleEnumMap, json['role']),
    );

Map<String, dynamic> _$$PlayerLiteImplToJson(_$PlayerLiteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'role': _$RoleEnumMap[instance.role]!,
    };

const _$RoleEnumMap = {
  Role.oh: 'oh',
  Role.opp: 'opp',
  Role.mb: 'mb',
  Role.s: 's',
  Role.l: 'l',
};
