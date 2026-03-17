// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'play_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayAction _$PlayActionFromJson(Map<String, dynamic> json) {
  return _PlayAction.fromJson(json);
}

/// @nodoc
mixin _$PlayAction {
  int get rallyId => throw _privateConstructorUsedError;
  int get rotationTick => throw _privateConstructorUsedError;
  TeamSide get side => throw _privateConstructorUsedError;
  PlayType get type => throw _privateConstructorUsedError;
  String get outcome => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this PlayAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayActionCopyWith<PlayAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayActionCopyWith<$Res> {
  factory $PlayActionCopyWith(
    PlayAction value,
    $Res Function(PlayAction) then,
  ) = _$PlayActionCopyWithImpl<$Res, PlayAction>;
  @useResult
  $Res call({
    int rallyId,
    int rotationTick,
    TeamSide side,
    PlayType type,
    String outcome,
    DateTime timestamp,
  });
}

/// @nodoc
class _$PlayActionCopyWithImpl<$Res, $Val extends PlayAction>
    implements $PlayActionCopyWith<$Res> {
  _$PlayActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rallyId = null,
    Object? rotationTick = null,
    Object? side = null,
    Object? type = null,
    Object? outcome = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            rallyId: null == rallyId
                ? _value.rallyId
                : rallyId as int,
            rotationTick: null == rotationTick
                ? _value.rotationTick
                : rotationTick as int,
            side: null == side
                ? _value.side
                : side as TeamSide,
            type: null == type
                ? _value.type
                : type as PlayType,
            outcome: null == outcome
                ? _value.outcome
                : outcome as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayActionImplCopyWith<$Res>
    implements $PlayActionCopyWith<$Res> {
  factory _$$PlayActionImplCopyWith(
    _$PlayActionImpl value,
    $Res Function(_$PlayActionImpl) then,
  ) = __$$PlayActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int rallyId,
    int rotationTick,
    TeamSide side,
    PlayType type,
    String outcome,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$PlayActionImplCopyWithImpl<$Res>
    extends _$PlayActionCopyWithImpl<$Res, _$PlayActionImpl>
    implements _$$PlayActionImplCopyWith<$Res> {
  __$$PlayActionImplCopyWithImpl(
    _$PlayActionImpl _value,
    $Res Function(_$PlayActionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rallyId = null,
    Object? rotationTick = null,
    Object? side = null,
    Object? type = null,
    Object? outcome = null,
    Object? timestamp = null,
  }) {
    return _then(_$PlayActionImpl(
      rallyId: null == rallyId
          ? _value.rallyId
          : rallyId as int,
      rotationTick: null == rotationTick
          ? _value.rotationTick
          : rotationTick as int,
      side: null == side
          ? _value.side
          : side as TeamSide,
      type: null == type
          ? _value.type
          : type as PlayType,
      outcome: null == outcome
          ? _value.outcome
          : outcome as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayActionImpl implements _PlayAction {
  const _$PlayActionImpl({
    required this.rallyId,
    required this.rotationTick,
    required this.side,
    required this.type,
    required this.outcome,
    required this.timestamp,
  });

  factory _$PlayActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayActionImplFromJson(json);

  @override
  final int rallyId;
  @override
  final int rotationTick;
  @override
  final TeamSide side;
  @override
  final PlayType type;
  @override
  final String outcome;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'PlayAction(rallyId: $rallyId, rotationTick: $rotationTick, side: $side, type: $type, outcome: $outcome, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayActionImpl &&
            (identical(other.rallyId, rallyId) || other.rallyId == rallyId) &&
            (identical(other.rotationTick, rotationTick) ||
                other.rotationTick == rotationTick) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.outcome, outcome) ||
                other.outcome == outcome) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, rallyId, rotationTick, side, type, outcome, timestamp);

  /// Create a copy of PlayAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayActionImplCopyWith<_$PlayActionImpl> get copyWith =>
      __$$PlayActionImplCopyWithImpl<_$PlayActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayActionImplToJson(this);
  }
}

abstract class _PlayAction implements PlayAction {
  const factory _PlayAction({
    required final int rallyId,
    required final int rotationTick,
    required final TeamSide side,
    required final PlayType type,
    required final String outcome,
    required final DateTime timestamp,
  }) = _$PlayActionImpl;

  factory _PlayAction.fromJson(Map<String, dynamic> json) =
      _$PlayActionImpl.fromJson;

  @override
  int get rallyId;
  @override
  int get rotationTick;
  @override
  TeamSide get side;
  @override
  PlayType get type;
  @override
  String get outcome;
  @override
  DateTime get timestamp;

  /// Create a copy of PlayAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayActionImplCopyWith<_$PlayActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
