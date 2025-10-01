// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RolePointImpl _$$RolePointImplFromJson(Map<String, dynamic> json) =>
    _$RolePointImpl(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );

Map<String, dynamic> _$$RolePointImplToJson(_$RolePointImpl instance) =>
    <String, dynamic>{'x': instance.x, 'y': instance.y};

_$PositionLayoutImpl _$$PositionLayoutImplFromJson(Map<String, dynamic> json) =>
    _$PositionLayoutImpl(
      roles: (json['roles'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, RolePoint.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$PositionLayoutImplToJson(
  _$PositionLayoutImpl instance,
) => <String, dynamic>{'roles': instance.roles};

_$PositionBookImpl _$$PositionBookImplFromJson(Map<String, dynamic> json) =>
    _$PositionBookImpl(
      layouts: (json['layouts'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, PositionLayout.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$PositionBookImplToJson(_$PositionBookImpl instance) =>
    <String, dynamic>{
      'layouts': instance.layouts.map((k, e) => MapEntry(k, e.toJson())),
    };
