// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EngineEvent _$EngineEventFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'serveBallFlight':
      return ServeBallFlight.fromJson(json);
    case 'playerMove':
      return PlayerMove.fromJson(json);
    case 'scoreChanged':
      return ScoreChanged.fromJson(json);
    case 'rotationAdvanced':
      return RotationAdvanced.fromJson(json);
    case 'phaseChanged':
      return PhaseChanged.fromJson(json);
    case 'rallyEnded':
      return RallyEnded.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'EngineEvent',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$EngineEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(TeamSide fromSide, double durationSec)
    serveBallFlight,
    required TResult Function(
      int playerId,
      double toX,
      double toY,
      double durationSec,
    )
    playerMove,
    required TResult Function(int home, int away) scoreChanged,
    required TResult Function(int rotationTick, TeamSide serverSide)
    rotationAdvanced,
    required TResult Function(MatchPhase phase, int rallyId) phaseChanged,
    required TResult Function(TeamSide pointTo, int rallyId) rallyEnded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult? Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult? Function(int home, int away)? scoreChanged,
    TResult? Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult? Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult? Function(TeamSide pointTo, int rallyId)? rallyEnded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult Function(int home, int away)? scoreChanged,
    TResult Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult Function(TeamSide pointTo, int rallyId)? rallyEnded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServeBallFlight value) serveBallFlight,
    required TResult Function(PlayerMove value) playerMove,
    required TResult Function(ScoreChanged value) scoreChanged,
    required TResult Function(RotationAdvanced value) rotationAdvanced,
    required TResult Function(PhaseChanged value) phaseChanged,
    required TResult Function(RallyEnded value) rallyEnded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServeBallFlight value)? serveBallFlight,
    TResult? Function(PlayerMove value)? playerMove,
    TResult? Function(ScoreChanged value)? scoreChanged,
    TResult? Function(RotationAdvanced value)? rotationAdvanced,
    TResult? Function(PhaseChanged value)? phaseChanged,
    TResult? Function(RallyEnded value)? rallyEnded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServeBallFlight value)? serveBallFlight,
    TResult Function(PlayerMove value)? playerMove,
    TResult Function(ScoreChanged value)? scoreChanged,
    TResult Function(RotationAdvanced value)? rotationAdvanced,
    TResult Function(PhaseChanged value)? phaseChanged,
    TResult Function(RallyEnded value)? rallyEnded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this EngineEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EngineEventCopyWith<$Res> {
  factory $EngineEventCopyWith(
    EngineEvent value,
    $Res Function(EngineEvent) then,
  ) = _$EngineEventCopyWithImpl<$Res, EngineEvent>;
}

/// @nodoc
class _$EngineEventCopyWithImpl<$Res, $Val extends EngineEvent>
    implements $EngineEventCopyWith<$Res> {
  _$EngineEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ServeBallFlightImplCopyWith<$Res> {
  factory _$$ServeBallFlightImplCopyWith(
    _$ServeBallFlightImpl value,
    $Res Function(_$ServeBallFlightImpl) then,
  ) = __$$ServeBallFlightImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TeamSide fromSide, double durationSec});
}

/// @nodoc
class __$$ServeBallFlightImplCopyWithImpl<$Res>
    extends _$EngineEventCopyWithImpl<$Res, _$ServeBallFlightImpl>
    implements _$$ServeBallFlightImplCopyWith<$Res> {
  __$$ServeBallFlightImplCopyWithImpl(
    _$ServeBallFlightImpl _value,
    $Res Function(_$ServeBallFlightImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fromSide = null, Object? durationSec = null}) {
    return _then(
      _$ServeBallFlightImpl(
        fromSide: null == fromSide
            ? _value.fromSide
            : fromSide // ignore: cast_nullable_to_non_nullable
                  as TeamSide,
        durationSec: null == durationSec
            ? _value.durationSec
            : durationSec // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServeBallFlightImpl implements ServeBallFlight {
  const _$ServeBallFlightImpl({
    required this.fromSide,
    required this.durationSec,
    final String? $type,
  }) : $type = $type ?? 'serveBallFlight';

  factory _$ServeBallFlightImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServeBallFlightImplFromJson(json);

  @override
  final TeamSide fromSide;
  @override
  final double durationSec;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'EngineEvent.serveBallFlight(fromSide: $fromSide, durationSec: $durationSec)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServeBallFlightImpl &&
            (identical(other.fromSide, fromSide) ||
                other.fromSide == fromSide) &&
            (identical(other.durationSec, durationSec) ||
                other.durationSec == durationSec));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fromSide, durationSec);

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServeBallFlightImplCopyWith<_$ServeBallFlightImpl> get copyWith =>
      __$$ServeBallFlightImplCopyWithImpl<_$ServeBallFlightImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(TeamSide fromSide, double durationSec)
    serveBallFlight,
    required TResult Function(
      int playerId,
      double toX,
      double toY,
      double durationSec,
    )
    playerMove,
    required TResult Function(int home, int away) scoreChanged,
    required TResult Function(int rotationTick, TeamSide serverSide)
    rotationAdvanced,
    required TResult Function(MatchPhase phase, int rallyId) phaseChanged,
    required TResult Function(TeamSide pointTo, int rallyId) rallyEnded,
  }) {
    return serveBallFlight(fromSide, durationSec);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult? Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult? Function(int home, int away)? scoreChanged,
    TResult? Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult? Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult? Function(TeamSide pointTo, int rallyId)? rallyEnded,
  }) {
    return serveBallFlight?.call(fromSide, durationSec);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult Function(int home, int away)? scoreChanged,
    TResult Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult Function(TeamSide pointTo, int rallyId)? rallyEnded,
    required TResult orElse(),
  }) {
    if (serveBallFlight != null) {
      return serveBallFlight(fromSide, durationSec);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServeBallFlight value) serveBallFlight,
    required TResult Function(PlayerMove value) playerMove,
    required TResult Function(ScoreChanged value) scoreChanged,
    required TResult Function(RotationAdvanced value) rotationAdvanced,
    required TResult Function(PhaseChanged value) phaseChanged,
    required TResult Function(RallyEnded value) rallyEnded,
  }) {
    return serveBallFlight(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServeBallFlight value)? serveBallFlight,
    TResult? Function(PlayerMove value)? playerMove,
    TResult? Function(ScoreChanged value)? scoreChanged,
    TResult? Function(RotationAdvanced value)? rotationAdvanced,
    TResult? Function(PhaseChanged value)? phaseChanged,
    TResult? Function(RallyEnded value)? rallyEnded,
  }) {
    return serveBallFlight?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServeBallFlight value)? serveBallFlight,
    TResult Function(PlayerMove value)? playerMove,
    TResult Function(ScoreChanged value)? scoreChanged,
    TResult Function(RotationAdvanced value)? rotationAdvanced,
    TResult Function(PhaseChanged value)? phaseChanged,
    TResult Function(RallyEnded value)? rallyEnded,
    required TResult orElse(),
  }) {
    if (serveBallFlight != null) {
      return serveBallFlight(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ServeBallFlightImplToJson(this);
  }
}

abstract class ServeBallFlight implements EngineEvent {
  const factory ServeBallFlight({
    required final TeamSide fromSide,
    required final double durationSec,
  }) = _$ServeBallFlightImpl;

  factory ServeBallFlight.fromJson(Map<String, dynamic> json) =
      _$ServeBallFlightImpl.fromJson;

  TeamSide get fromSide;
  double get durationSec;

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServeBallFlightImplCopyWith<_$ServeBallFlightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlayerMoveImplCopyWith<$Res> {
  factory _$$PlayerMoveImplCopyWith(
    _$PlayerMoveImpl value,
    $Res Function(_$PlayerMoveImpl) then,
  ) = __$$PlayerMoveImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int playerId, double toX, double toY, double durationSec});
}

/// @nodoc
class __$$PlayerMoveImplCopyWithImpl<$Res>
    extends _$EngineEventCopyWithImpl<$Res, _$PlayerMoveImpl>
    implements _$$PlayerMoveImplCopyWith<$Res> {
  __$$PlayerMoveImplCopyWithImpl(
    _$PlayerMoveImpl _value,
    $Res Function(_$PlayerMoveImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? toX = null,
    Object? toY = null,
    Object? durationSec = null,
  }) {
    return _then(
      _$PlayerMoveImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as int,
        toX: null == toX
            ? _value.toX
            : toX // ignore: cast_nullable_to_non_nullable
                  as double,
        toY: null == toY
            ? _value.toY
            : toY // ignore: cast_nullable_to_non_nullable
                  as double,
        durationSec: null == durationSec
            ? _value.durationSec
            : durationSec // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerMoveImpl implements PlayerMove {
  const _$PlayerMoveImpl({
    required this.playerId,
    required this.toX,
    required this.toY,
    this.durationSec = 0.5,
    final String? $type,
  }) : $type = $type ?? 'playerMove';

  factory _$PlayerMoveImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerMoveImplFromJson(json);

  @override
  final int playerId;
  @override
  final double toX;
  @override
  final double toY;
  @override
  @JsonKey()
  final double durationSec;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'EngineEvent.playerMove(playerId: $playerId, toX: $toX, toY: $toY, durationSec: $durationSec)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerMoveImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.toX, toX) || other.toX == toX) &&
            (identical(other.toY, toY) || other.toY == toY) &&
            (identical(other.durationSec, durationSec) ||
                other.durationSec == durationSec));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, playerId, toX, toY, durationSec);

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerMoveImplCopyWith<_$PlayerMoveImpl> get copyWith =>
      __$$PlayerMoveImplCopyWithImpl<_$PlayerMoveImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(TeamSide fromSide, double durationSec)
    serveBallFlight,
    required TResult Function(
      int playerId,
      double toX,
      double toY,
      double durationSec,
    )
    playerMove,
    required TResult Function(int home, int away) scoreChanged,
    required TResult Function(int rotationTick, TeamSide serverSide)
    rotationAdvanced,
    required TResult Function(MatchPhase phase, int rallyId) phaseChanged,
    required TResult Function(TeamSide pointTo, int rallyId) rallyEnded,
  }) {
    return playerMove(playerId, toX, toY, durationSec);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult? Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult? Function(int home, int away)? scoreChanged,
    TResult? Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult? Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult? Function(TeamSide pointTo, int rallyId)? rallyEnded,
  }) {
    return playerMove?.call(playerId, toX, toY, durationSec);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult Function(int home, int away)? scoreChanged,
    TResult Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult Function(TeamSide pointTo, int rallyId)? rallyEnded,
    required TResult orElse(),
  }) {
    if (playerMove != null) {
      return playerMove(playerId, toX, toY, durationSec);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServeBallFlight value) serveBallFlight,
    required TResult Function(PlayerMove value) playerMove,
    required TResult Function(ScoreChanged value) scoreChanged,
    required TResult Function(RotationAdvanced value) rotationAdvanced,
    required TResult Function(PhaseChanged value) phaseChanged,
    required TResult Function(RallyEnded value) rallyEnded,
  }) {
    return playerMove(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServeBallFlight value)? serveBallFlight,
    TResult? Function(PlayerMove value)? playerMove,
    TResult? Function(ScoreChanged value)? scoreChanged,
    TResult? Function(RotationAdvanced value)? rotationAdvanced,
    TResult? Function(PhaseChanged value)? phaseChanged,
    TResult? Function(RallyEnded value)? rallyEnded,
  }) {
    return playerMove?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServeBallFlight value)? serveBallFlight,
    TResult Function(PlayerMove value)? playerMove,
    TResult Function(ScoreChanged value)? scoreChanged,
    TResult Function(RotationAdvanced value)? rotationAdvanced,
    TResult Function(PhaseChanged value)? phaseChanged,
    TResult Function(RallyEnded value)? rallyEnded,
    required TResult orElse(),
  }) {
    if (playerMove != null) {
      return playerMove(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerMoveImplToJson(this);
  }
}

abstract class PlayerMove implements EngineEvent {
  const factory PlayerMove({
    required final int playerId,
    required final double toX,
    required final double toY,
    final double durationSec,
  }) = _$PlayerMoveImpl;

  factory PlayerMove.fromJson(Map<String, dynamic> json) =
      _$PlayerMoveImpl.fromJson;

  int get playerId;
  double get toX;
  double get toY;
  double get durationSec;

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerMoveImplCopyWith<_$PlayerMoveImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ScoreChangedImplCopyWith<$Res> {
  factory _$$ScoreChangedImplCopyWith(
    _$ScoreChangedImpl value,
    $Res Function(_$ScoreChangedImpl) then,
  ) = __$$ScoreChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int home, int away});
}

/// @nodoc
class __$$ScoreChangedImplCopyWithImpl<$Res>
    extends _$EngineEventCopyWithImpl<$Res, _$ScoreChangedImpl>
    implements _$$ScoreChangedImplCopyWith<$Res> {
  __$$ScoreChangedImplCopyWithImpl(
    _$ScoreChangedImpl _value,
    $Res Function(_$ScoreChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? home = null, Object? away = null}) {
    return _then(
      _$ScoreChangedImpl(
        home: null == home
            ? _value.home
            : home // ignore: cast_nullable_to_non_nullable
                  as int,
        away: null == away
            ? _value.away
            : away // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScoreChangedImpl implements ScoreChanged {
  const _$ScoreChangedImpl({
    required this.home,
    required this.away,
    final String? $type,
  }) : $type = $type ?? 'scoreChanged';

  factory _$ScoreChangedImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoreChangedImplFromJson(json);

  @override
  final int home;
  @override
  final int away;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'EngineEvent.scoreChanged(home: $home, away: $away)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreChangedImpl &&
            (identical(other.home, home) || other.home == home) &&
            (identical(other.away, away) || other.away == away));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, home, away);

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreChangedImplCopyWith<_$ScoreChangedImpl> get copyWith =>
      __$$ScoreChangedImplCopyWithImpl<_$ScoreChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(TeamSide fromSide, double durationSec)
    serveBallFlight,
    required TResult Function(
      int playerId,
      double toX,
      double toY,
      double durationSec,
    )
    playerMove,
    required TResult Function(int home, int away) scoreChanged,
    required TResult Function(int rotationTick, TeamSide serverSide)
    rotationAdvanced,
    required TResult Function(MatchPhase phase, int rallyId) phaseChanged,
    required TResult Function(TeamSide pointTo, int rallyId) rallyEnded,
  }) {
    return scoreChanged(home, away);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult? Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult? Function(int home, int away)? scoreChanged,
    TResult? Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult? Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult? Function(TeamSide pointTo, int rallyId)? rallyEnded,
  }) {
    return scoreChanged?.call(home, away);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult Function(int home, int away)? scoreChanged,
    TResult Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult Function(TeamSide pointTo, int rallyId)? rallyEnded,
    required TResult orElse(),
  }) {
    if (scoreChanged != null) {
      return scoreChanged(home, away);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServeBallFlight value) serveBallFlight,
    required TResult Function(PlayerMove value) playerMove,
    required TResult Function(ScoreChanged value) scoreChanged,
    required TResult Function(RotationAdvanced value) rotationAdvanced,
    required TResult Function(PhaseChanged value) phaseChanged,
    required TResult Function(RallyEnded value) rallyEnded,
  }) {
    return scoreChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServeBallFlight value)? serveBallFlight,
    TResult? Function(PlayerMove value)? playerMove,
    TResult? Function(ScoreChanged value)? scoreChanged,
    TResult? Function(RotationAdvanced value)? rotationAdvanced,
    TResult? Function(PhaseChanged value)? phaseChanged,
    TResult? Function(RallyEnded value)? rallyEnded,
  }) {
    return scoreChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServeBallFlight value)? serveBallFlight,
    TResult Function(PlayerMove value)? playerMove,
    TResult Function(ScoreChanged value)? scoreChanged,
    TResult Function(RotationAdvanced value)? rotationAdvanced,
    TResult Function(PhaseChanged value)? phaseChanged,
    TResult Function(RallyEnded value)? rallyEnded,
    required TResult orElse(),
  }) {
    if (scoreChanged != null) {
      return scoreChanged(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoreChangedImplToJson(this);
  }
}

abstract class ScoreChanged implements EngineEvent {
  const factory ScoreChanged({
    required final int home,
    required final int away,
  }) = _$ScoreChangedImpl;

  factory ScoreChanged.fromJson(Map<String, dynamic> json) =
      _$ScoreChangedImpl.fromJson;

  int get home;
  int get away;

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoreChangedImplCopyWith<_$ScoreChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RotationAdvancedImplCopyWith<$Res> {
  factory _$$RotationAdvancedImplCopyWith(
    _$RotationAdvancedImpl value,
    $Res Function(_$RotationAdvancedImpl) then,
  ) = __$$RotationAdvancedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int rotationTick, TeamSide serverSide});
}

/// @nodoc
class __$$RotationAdvancedImplCopyWithImpl<$Res>
    extends _$EngineEventCopyWithImpl<$Res, _$RotationAdvancedImpl>
    implements _$$RotationAdvancedImplCopyWith<$Res> {
  __$$RotationAdvancedImplCopyWithImpl(
    _$RotationAdvancedImpl _value,
    $Res Function(_$RotationAdvancedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? rotationTick = null, Object? serverSide = null}) {
    return _then(
      _$RotationAdvancedImpl(
        rotationTick: null == rotationTick
            ? _value.rotationTick
            : rotationTick // ignore: cast_nullable_to_non_nullable
                  as int,
        serverSide: null == serverSide
            ? _value.serverSide
            : serverSide // ignore: cast_nullable_to_non_nullable
                  as TeamSide,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RotationAdvancedImpl implements RotationAdvanced {
  const _$RotationAdvancedImpl({
    required this.rotationTick,
    required this.serverSide,
    final String? $type,
  }) : $type = $type ?? 'rotationAdvanced';

  factory _$RotationAdvancedImpl.fromJson(Map<String, dynamic> json) =>
      _$$RotationAdvancedImplFromJson(json);

  @override
  final int rotationTick;
  @override
  final TeamSide serverSide;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'EngineEvent.rotationAdvanced(rotationTick: $rotationTick, serverSide: $serverSide)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RotationAdvancedImpl &&
            (identical(other.rotationTick, rotationTick) ||
                other.rotationTick == rotationTick) &&
            (identical(other.serverSide, serverSide) ||
                other.serverSide == serverSide));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rotationTick, serverSide);

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RotationAdvancedImplCopyWith<_$RotationAdvancedImpl> get copyWith =>
      __$$RotationAdvancedImplCopyWithImpl<_$RotationAdvancedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(TeamSide fromSide, double durationSec)
    serveBallFlight,
    required TResult Function(
      int playerId,
      double toX,
      double toY,
      double durationSec,
    )
    playerMove,
    required TResult Function(int home, int away) scoreChanged,
    required TResult Function(int rotationTick, TeamSide serverSide)
    rotationAdvanced,
    required TResult Function(MatchPhase phase, int rallyId) phaseChanged,
    required TResult Function(TeamSide pointTo, int rallyId) rallyEnded,
  }) {
    return rotationAdvanced(rotationTick, serverSide);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult? Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult? Function(int home, int away)? scoreChanged,
    TResult? Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult? Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult? Function(TeamSide pointTo, int rallyId)? rallyEnded,
  }) {
    return rotationAdvanced?.call(rotationTick, serverSide);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult Function(int home, int away)? scoreChanged,
    TResult Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult Function(TeamSide pointTo, int rallyId)? rallyEnded,
    required TResult orElse(),
  }) {
    if (rotationAdvanced != null) {
      return rotationAdvanced(rotationTick, serverSide);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServeBallFlight value) serveBallFlight,
    required TResult Function(PlayerMove value) playerMove,
    required TResult Function(ScoreChanged value) scoreChanged,
    required TResult Function(RotationAdvanced value) rotationAdvanced,
    required TResult Function(PhaseChanged value) phaseChanged,
    required TResult Function(RallyEnded value) rallyEnded,
  }) {
    return rotationAdvanced(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServeBallFlight value)? serveBallFlight,
    TResult? Function(PlayerMove value)? playerMove,
    TResult? Function(ScoreChanged value)? scoreChanged,
    TResult? Function(RotationAdvanced value)? rotationAdvanced,
    TResult? Function(PhaseChanged value)? phaseChanged,
    TResult? Function(RallyEnded value)? rallyEnded,
  }) {
    return rotationAdvanced?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServeBallFlight value)? serveBallFlight,
    TResult Function(PlayerMove value)? playerMove,
    TResult Function(ScoreChanged value)? scoreChanged,
    TResult Function(RotationAdvanced value)? rotationAdvanced,
    TResult Function(PhaseChanged value)? phaseChanged,
    TResult Function(RallyEnded value)? rallyEnded,
    required TResult orElse(),
  }) {
    if (rotationAdvanced != null) {
      return rotationAdvanced(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RotationAdvancedImplToJson(this);
  }
}

abstract class RotationAdvanced implements EngineEvent {
  const factory RotationAdvanced({
    required final int rotationTick,
    required final TeamSide serverSide,
  }) = _$RotationAdvancedImpl;

  factory RotationAdvanced.fromJson(Map<String, dynamic> json) =
      _$RotationAdvancedImpl.fromJson;

  int get rotationTick;
  TeamSide get serverSide;

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RotationAdvancedImplCopyWith<_$RotationAdvancedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PhaseChangedImplCopyWith<$Res> {
  factory _$$PhaseChangedImplCopyWith(
    _$PhaseChangedImpl value,
    $Res Function(_$PhaseChangedImpl) then,
  ) = __$$PhaseChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({MatchPhase phase, int rallyId});
}

/// @nodoc
class __$$PhaseChangedImplCopyWithImpl<$Res>
    extends _$EngineEventCopyWithImpl<$Res, _$PhaseChangedImpl>
    implements _$$PhaseChangedImplCopyWith<$Res> {
  __$$PhaseChangedImplCopyWithImpl(
    _$PhaseChangedImpl _value,
    $Res Function(_$PhaseChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? phase = null, Object? rallyId = null}) {
    return _then(
      _$PhaseChangedImpl(
        phase: null == phase
            ? _value.phase
            : phase // ignore: cast_nullable_to_non_nullable
                  as MatchPhase,
        rallyId: null == rallyId
            ? _value.rallyId
            : rallyId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PhaseChangedImpl implements PhaseChanged {
  const _$PhaseChangedImpl({
    required this.phase,
    required this.rallyId,
    final String? $type,
  }) : $type = $type ?? 'phaseChanged';

  factory _$PhaseChangedImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhaseChangedImplFromJson(json);

  @override
  final MatchPhase phase;
  @override
  final int rallyId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'EngineEvent.phaseChanged(phase: $phase, rallyId: $rallyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhaseChangedImpl &&
            (identical(other.phase, phase) || other.phase == phase) &&
            (identical(other.rallyId, rallyId) || other.rallyId == rallyId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phase, rallyId);

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhaseChangedImplCopyWith<_$PhaseChangedImpl> get copyWith =>
      __$$PhaseChangedImplCopyWithImpl<_$PhaseChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(TeamSide fromSide, double durationSec)
    serveBallFlight,
    required TResult Function(
      int playerId,
      double toX,
      double toY,
      double durationSec,
    )
    playerMove,
    required TResult Function(int home, int away) scoreChanged,
    required TResult Function(int rotationTick, TeamSide serverSide)
    rotationAdvanced,
    required TResult Function(MatchPhase phase, int rallyId) phaseChanged,
    required TResult Function(TeamSide pointTo, int rallyId) rallyEnded,
  }) {
    return phaseChanged(phase, rallyId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult? Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult? Function(int home, int away)? scoreChanged,
    TResult? Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult? Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult? Function(TeamSide pointTo, int rallyId)? rallyEnded,
  }) {
    return phaseChanged?.call(phase, rallyId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult Function(int home, int away)? scoreChanged,
    TResult Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult Function(TeamSide pointTo, int rallyId)? rallyEnded,
    required TResult orElse(),
  }) {
    if (phaseChanged != null) {
      return phaseChanged(phase, rallyId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServeBallFlight value) serveBallFlight,
    required TResult Function(PlayerMove value) playerMove,
    required TResult Function(ScoreChanged value) scoreChanged,
    required TResult Function(RotationAdvanced value) rotationAdvanced,
    required TResult Function(PhaseChanged value) phaseChanged,
    required TResult Function(RallyEnded value) rallyEnded,
  }) {
    return phaseChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServeBallFlight value)? serveBallFlight,
    TResult? Function(PlayerMove value)? playerMove,
    TResult? Function(ScoreChanged value)? scoreChanged,
    TResult? Function(RotationAdvanced value)? rotationAdvanced,
    TResult? Function(PhaseChanged value)? phaseChanged,
    TResult? Function(RallyEnded value)? rallyEnded,
  }) {
    return phaseChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServeBallFlight value)? serveBallFlight,
    TResult Function(PlayerMove value)? playerMove,
    TResult Function(ScoreChanged value)? scoreChanged,
    TResult Function(RotationAdvanced value)? rotationAdvanced,
    TResult Function(PhaseChanged value)? phaseChanged,
    TResult Function(RallyEnded value)? rallyEnded,
    required TResult orElse(),
  }) {
    if (phaseChanged != null) {
      return phaseChanged(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PhaseChangedImplToJson(this);
  }
}

abstract class PhaseChanged implements EngineEvent {
  const factory PhaseChanged({
    required final MatchPhase phase,
    required final int rallyId,
  }) = _$PhaseChangedImpl;

  factory PhaseChanged.fromJson(Map<String, dynamic> json) =
      _$PhaseChangedImpl.fromJson;

  MatchPhase get phase;
  int get rallyId;

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhaseChangedImplCopyWith<_$PhaseChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RallyEndedImplCopyWith<$Res> {
  factory _$$RallyEndedImplCopyWith(
    _$RallyEndedImpl value,
    $Res Function(_$RallyEndedImpl) then,
  ) = __$$RallyEndedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TeamSide pointTo, int rallyId});
}

/// @nodoc
class __$$RallyEndedImplCopyWithImpl<$Res>
    extends _$EngineEventCopyWithImpl<$Res, _$RallyEndedImpl>
    implements _$$RallyEndedImplCopyWith<$Res> {
  __$$RallyEndedImplCopyWithImpl(
    _$RallyEndedImpl _value,
    $Res Function(_$RallyEndedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pointTo = null, Object? rallyId = null}) {
    return _then(
      _$RallyEndedImpl(
        pointTo: null == pointTo
            ? _value.pointTo
            : pointTo // ignore: cast_nullable_to_non_nullable
                  as TeamSide,
        rallyId: null == rallyId
            ? _value.rallyId
            : rallyId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RallyEndedImpl implements RallyEnded {
  const _$RallyEndedImpl({
    required this.pointTo,
    required this.rallyId,
    final String? $type,
  }) : $type = $type ?? 'rallyEnded';

  factory _$RallyEndedImpl.fromJson(Map<String, dynamic> json) =>
      _$$RallyEndedImplFromJson(json);

  @override
  final TeamSide pointTo;
  @override
  final int rallyId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'EngineEvent.rallyEnded(pointTo: $pointTo, rallyId: $rallyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RallyEndedImpl &&
            (identical(other.pointTo, pointTo) || other.pointTo == pointTo) &&
            (identical(other.rallyId, rallyId) || other.rallyId == rallyId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pointTo, rallyId);

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RallyEndedImplCopyWith<_$RallyEndedImpl> get copyWith =>
      __$$RallyEndedImplCopyWithImpl<_$RallyEndedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(TeamSide fromSide, double durationSec)
    serveBallFlight,
    required TResult Function(
      int playerId,
      double toX,
      double toY,
      double durationSec,
    )
    playerMove,
    required TResult Function(int home, int away) scoreChanged,
    required TResult Function(int rotationTick, TeamSide serverSide)
    rotationAdvanced,
    required TResult Function(MatchPhase phase, int rallyId) phaseChanged,
    required TResult Function(TeamSide pointTo, int rallyId) rallyEnded,
  }) {
    return rallyEnded(pointTo, rallyId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult? Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult? Function(int home, int away)? scoreChanged,
    TResult? Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult? Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult? Function(TeamSide pointTo, int rallyId)? rallyEnded,
  }) {
    return rallyEnded?.call(pointTo, rallyId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(TeamSide fromSide, double durationSec)? serveBallFlight,
    TResult Function(int playerId, double toX, double toY, double durationSec)?
    playerMove,
    TResult Function(int home, int away)? scoreChanged,
    TResult Function(int rotationTick, TeamSide serverSide)? rotationAdvanced,
    TResult Function(MatchPhase phase, int rallyId)? phaseChanged,
    TResult Function(TeamSide pointTo, int rallyId)? rallyEnded,
    required TResult orElse(),
  }) {
    if (rallyEnded != null) {
      return rallyEnded(pointTo, rallyId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServeBallFlight value) serveBallFlight,
    required TResult Function(PlayerMove value) playerMove,
    required TResult Function(ScoreChanged value) scoreChanged,
    required TResult Function(RotationAdvanced value) rotationAdvanced,
    required TResult Function(PhaseChanged value) phaseChanged,
    required TResult Function(RallyEnded value) rallyEnded,
  }) {
    return rallyEnded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServeBallFlight value)? serveBallFlight,
    TResult? Function(PlayerMove value)? playerMove,
    TResult? Function(ScoreChanged value)? scoreChanged,
    TResult? Function(RotationAdvanced value)? rotationAdvanced,
    TResult? Function(PhaseChanged value)? phaseChanged,
    TResult? Function(RallyEnded value)? rallyEnded,
  }) {
    return rallyEnded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServeBallFlight value)? serveBallFlight,
    TResult Function(PlayerMove value)? playerMove,
    TResult Function(ScoreChanged value)? scoreChanged,
    TResult Function(RotationAdvanced value)? rotationAdvanced,
    TResult Function(PhaseChanged value)? phaseChanged,
    TResult Function(RallyEnded value)? rallyEnded,
    required TResult orElse(),
  }) {
    if (rallyEnded != null) {
      return rallyEnded(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RallyEndedImplToJson(this);
  }
}

abstract class RallyEnded implements EngineEvent {
  const factory RallyEnded({
    required final TeamSide pointTo,
    required final int rallyId,
  }) = _$RallyEndedImpl;

  factory RallyEnded.fromJson(Map<String, dynamic> json) =
      _$RallyEndedImpl.fromJson;

  TeamSide get pointTo;
  int get rallyId;

  /// Create a copy of EngineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RallyEndedImplCopyWith<_$RallyEndedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
