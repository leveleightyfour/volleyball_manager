// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'position_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RolePoint _$RolePointFromJson(Map<String, dynamic> json) {
  return _RolePoint.fromJson(json);
}

/// @nodoc
mixin _$RolePoint {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  /// Serializes this RolePoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RolePoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RolePointCopyWith<RolePoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RolePointCopyWith<$Res> {
  factory $RolePointCopyWith(RolePoint value, $Res Function(RolePoint) then) =
      _$RolePointCopyWithImpl<$Res, RolePoint>;
  @useResult
  $Res call({double x, double y});
}

/// @nodoc
class _$RolePointCopyWithImpl<$Res, $Val extends RolePoint>
    implements $RolePointCopyWith<$Res> {
  _$RolePointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RolePoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? x = null, Object? y = null}) {
    return _then(
      _value.copyWith(
            x: null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as double,
            y: null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RolePointImplCopyWith<$Res>
    implements $RolePointCopyWith<$Res> {
  factory _$$RolePointImplCopyWith(
    _$RolePointImpl value,
    $Res Function(_$RolePointImpl) then,
  ) = __$$RolePointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double x, double y});
}

/// @nodoc
class __$$RolePointImplCopyWithImpl<$Res>
    extends _$RolePointCopyWithImpl<$Res, _$RolePointImpl>
    implements _$$RolePointImplCopyWith<$Res> {
  __$$RolePointImplCopyWithImpl(
    _$RolePointImpl _value,
    $Res Function(_$RolePointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RolePoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? x = null, Object? y = null}) {
    return _then(
      _$RolePointImpl(
        x: null == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as double,
        y: null == y
            ? _value.y
            : y // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RolePointImpl implements _RolePoint {
  const _$RolePointImpl({required this.x, required this.y});

  factory _$RolePointImpl.fromJson(Map<String, dynamic> json) =>
      _$$RolePointImplFromJson(json);

  @override
  final double x;
  @override
  final double y;

  @override
  String toString() {
    return 'RolePoint(x: $x, y: $y)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RolePointImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y);

  /// Create a copy of RolePoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RolePointImplCopyWith<_$RolePointImpl> get copyWith =>
      __$$RolePointImplCopyWithImpl<_$RolePointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RolePointImplToJson(this);
  }
}

abstract class _RolePoint implements RolePoint {
  const factory _RolePoint({required final double x, required final double y}) =
      _$RolePointImpl;

  factory _RolePoint.fromJson(Map<String, dynamic> json) =
      _$RolePointImpl.fromJson;

  @override
  double get x;
  @override
  double get y;

  /// Create a copy of RolePoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RolePointImplCopyWith<_$RolePointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PositionLayout _$PositionLayoutFromJson(Map<String, dynamic> json) {
  return _PositionLayout.fromJson(json);
}

/// @nodoc
mixin _$PositionLayout {
  /// role -> {x,y}
  Map<String, RolePoint> get roles => throw _privateConstructorUsedError;

  /// Serializes this PositionLayout to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PositionLayout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PositionLayoutCopyWith<PositionLayout> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PositionLayoutCopyWith<$Res> {
  factory $PositionLayoutCopyWith(
    PositionLayout value,
    $Res Function(PositionLayout) then,
  ) = _$PositionLayoutCopyWithImpl<$Res, PositionLayout>;
  @useResult
  $Res call({Map<String, RolePoint> roles});
}

/// @nodoc
class _$PositionLayoutCopyWithImpl<$Res, $Val extends PositionLayout>
    implements $PositionLayoutCopyWith<$Res> {
  _$PositionLayoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PositionLayout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roles = null}) {
    return _then(
      _value.copyWith(
            roles: null == roles
                ? _value.roles
                : roles // ignore: cast_nullable_to_non_nullable
                      as Map<String, RolePoint>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PositionLayoutImplCopyWith<$Res>
    implements $PositionLayoutCopyWith<$Res> {
  factory _$$PositionLayoutImplCopyWith(
    _$PositionLayoutImpl value,
    $Res Function(_$PositionLayoutImpl) then,
  ) = __$$PositionLayoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, RolePoint> roles});
}

/// @nodoc
class __$$PositionLayoutImplCopyWithImpl<$Res>
    extends _$PositionLayoutCopyWithImpl<$Res, _$PositionLayoutImpl>
    implements _$$PositionLayoutImplCopyWith<$Res> {
  __$$PositionLayoutImplCopyWithImpl(
    _$PositionLayoutImpl _value,
    $Res Function(_$PositionLayoutImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PositionLayout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? roles = null}) {
    return _then(
      _$PositionLayoutImpl(
        roles: null == roles
            ? _value._roles
            : roles // ignore: cast_nullable_to_non_nullable
                  as Map<String, RolePoint>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PositionLayoutImpl implements _PositionLayout {
  const _$PositionLayoutImpl({required final Map<String, RolePoint> roles})
    : _roles = roles;

  factory _$PositionLayoutImpl.fromJson(Map<String, dynamic> json) =>
      _$$PositionLayoutImplFromJson(json);

  /// role -> {x,y}
  final Map<String, RolePoint> _roles;

  /// role -> {x,y}
  @override
  Map<String, RolePoint> get roles {
    if (_roles is EqualUnmodifiableMapView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_roles);
  }

  @override
  String toString() {
    return 'PositionLayout(roles: $roles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositionLayoutImpl &&
            const DeepCollectionEquality().equals(other._roles, _roles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_roles));

  /// Create a copy of PositionLayout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PositionLayoutImplCopyWith<_$PositionLayoutImpl> get copyWith =>
      __$$PositionLayoutImplCopyWithImpl<_$PositionLayoutImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PositionLayoutImplToJson(this);
  }
}

abstract class _PositionLayout implements PositionLayout {
  const factory _PositionLayout({required final Map<String, RolePoint> roles}) =
      _$PositionLayoutImpl;

  factory _PositionLayout.fromJson(Map<String, dynamic> json) =
      _$PositionLayoutImpl.fromJson;

  /// role -> {x,y}
  @override
  Map<String, RolePoint> get roles;

  /// Create a copy of PositionLayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PositionLayoutImplCopyWith<_$PositionLayoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PositionBook _$PositionBookFromJson(Map<String, dynamic> json) {
  return _PositionBook.fromJson(json);
}

/// @nodoc
mixin _$PositionBook {
  Map<String, PositionLayout> get layouts => throw _privateConstructorUsedError;

  /// Serializes this PositionBook to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PositionBook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PositionBookCopyWith<PositionBook> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PositionBookCopyWith<$Res> {
  factory $PositionBookCopyWith(
    PositionBook value,
    $Res Function(PositionBook) then,
  ) = _$PositionBookCopyWithImpl<$Res, PositionBook>;
  @useResult
  $Res call({Map<String, PositionLayout> layouts});
}

/// @nodoc
class _$PositionBookCopyWithImpl<$Res, $Val extends PositionBook>
    implements $PositionBookCopyWith<$Res> {
  _$PositionBookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PositionBook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? layouts = null}) {
    return _then(
      _value.copyWith(
            layouts: null == layouts
                ? _value.layouts
                : layouts // ignore: cast_nullable_to_non_nullable
                      as Map<String, PositionLayout>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PositionBookImplCopyWith<$Res>
    implements $PositionBookCopyWith<$Res> {
  factory _$$PositionBookImplCopyWith(
    _$PositionBookImpl value,
    $Res Function(_$PositionBookImpl) then,
  ) = __$$PositionBookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, PositionLayout> layouts});
}

/// @nodoc
class __$$PositionBookImplCopyWithImpl<$Res>
    extends _$PositionBookCopyWithImpl<$Res, _$PositionBookImpl>
    implements _$$PositionBookImplCopyWith<$Res> {
  __$$PositionBookImplCopyWithImpl(
    _$PositionBookImpl _value,
    $Res Function(_$PositionBookImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PositionBook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? layouts = null}) {
    return _then(
      _$PositionBookImpl(
        layouts: null == layouts
            ? _value._layouts
            : layouts // ignore: cast_nullable_to_non_nullable
                  as Map<String, PositionLayout>,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$PositionBookImpl implements _PositionBook {
  const _$PositionBookImpl({required final Map<String, PositionLayout> layouts})
    : _layouts = layouts;

  factory _$PositionBookImpl.fromJson(Map<String, dynamic> json) =>
      _$$PositionBookImplFromJson(json);

  final Map<String, PositionLayout> _layouts;
  @override
  Map<String, PositionLayout> get layouts {
    if (_layouts is EqualUnmodifiableMapView) return _layouts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_layouts);
  }

  @override
  String toString() {
    return 'PositionBook(layouts: $layouts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositionBookImpl &&
            const DeepCollectionEquality().equals(other._layouts, _layouts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_layouts));

  /// Create a copy of PositionBook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PositionBookImplCopyWith<_$PositionBookImpl> get copyWith =>
      __$$PositionBookImplCopyWithImpl<_$PositionBookImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PositionBookImplToJson(this);
  }
}

abstract class _PositionBook implements PositionBook {
  const factory _PositionBook({
    required final Map<String, PositionLayout> layouts,
  }) = _$PositionBookImpl;

  factory _PositionBook.fromJson(Map<String, dynamic> json) =
      _$PositionBookImpl.fromJson;

  @override
  Map<String, PositionLayout> get layouts;

  /// Create a copy of PositionBook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PositionBookImplCopyWith<_$PositionBookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
