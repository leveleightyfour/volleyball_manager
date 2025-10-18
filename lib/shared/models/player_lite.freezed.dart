// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_lite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerLite _$PlayerLiteFromJson(Map<String, dynamic> json) {
  return _PlayerLite.fromJson(json);
}

/// @nodoc
mixin _$PlayerLite {
  int get id => throw _privateConstructorUsedError;
  int get number => throw _privateConstructorUsedError;
  Role get role => throw _privateConstructorUsedError;

  /// Serializes this PlayerLite to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerLite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerLiteCopyWith<PlayerLite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerLiteCopyWith<$Res> {
  factory $PlayerLiteCopyWith(
    PlayerLite value,
    $Res Function(PlayerLite) then,
  ) = _$PlayerLiteCopyWithImpl<$Res, PlayerLite>;
  @useResult
  $Res call({int id, int number, Role role});
}

/// @nodoc
class _$PlayerLiteCopyWithImpl<$Res, $Val extends PlayerLite>
    implements $PlayerLiteCopyWith<$Res> {
  _$PlayerLiteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerLite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? number = null, Object? role = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as int,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as Role,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerLiteImplCopyWith<$Res>
    implements $PlayerLiteCopyWith<$Res> {
  factory _$$PlayerLiteImplCopyWith(
    _$PlayerLiteImpl value,
    $Res Function(_$PlayerLiteImpl) then,
  ) = __$$PlayerLiteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int number, Role role});
}

/// @nodoc
class __$$PlayerLiteImplCopyWithImpl<$Res>
    extends _$PlayerLiteCopyWithImpl<$Res, _$PlayerLiteImpl>
    implements _$$PlayerLiteImplCopyWith<$Res> {
  __$$PlayerLiteImplCopyWithImpl(
    _$PlayerLiteImpl _value,
    $Res Function(_$PlayerLiteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerLite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? number = null, Object? role = null}) {
    return _then(
      _$PlayerLiteImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as int,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as Role,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerLiteImpl implements _PlayerLite {
  const _$PlayerLiteImpl({
    required this.id,
    required this.number,
    required this.role,
  });

  factory _$PlayerLiteImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerLiteImplFromJson(json);

  @override
  final int id;
  @override
  final int number;
  @override
  final Role role;

  @override
  String toString() {
    return 'PlayerLite(id: $id, number: $number, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerLiteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, number, role);

  /// Create a copy of PlayerLite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerLiteImplCopyWith<_$PlayerLiteImpl> get copyWith =>
      __$$PlayerLiteImplCopyWithImpl<_$PlayerLiteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerLiteImplToJson(this);
  }
}

abstract class _PlayerLite implements PlayerLite {
  const factory _PlayerLite({
    required final int id,
    required final int number,
    required final Role role,
  }) = _$PlayerLiteImpl;

  factory _PlayerLite.fromJson(Map<String, dynamic> json) =
      _$PlayerLiteImpl.fromJson;

  @override
  int get id;
  @override
  int get number;
  @override
  Role get role;

  /// Create a copy of PlayerLite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerLiteImplCopyWith<_$PlayerLiteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
