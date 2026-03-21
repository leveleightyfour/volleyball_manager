// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Score _$ScoreFromJson(Map<String, dynamic> json) {
  return _Score.fromJson(json);
}

/// @nodoc
mixin _$Score {
  int get home => throw _privateConstructorUsedError;
  int get away => throw _privateConstructorUsedError;

  /// Serializes this Score to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoreCopyWith<Score> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreCopyWith<$Res> {
  factory $ScoreCopyWith(Score value, $Res Function(Score) then) =
      _$ScoreCopyWithImpl<$Res, Score>;
  @useResult
  $Res call({int home, int away});
}

/// @nodoc
class _$ScoreCopyWithImpl<$Res, $Val extends Score>
    implements $ScoreCopyWith<$Res> {
  _$ScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? home = null, Object? away = null}) {
    return _then(
      _value.copyWith(
            home: null == home
                ? _value.home
                : home // ignore: cast_nullable_to_non_nullable
                      as int,
            away: null == away
                ? _value.away
                : away // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScoreImplCopyWith<$Res> implements $ScoreCopyWith<$Res> {
  factory _$$ScoreImplCopyWith(
    _$ScoreImpl value,
    $Res Function(_$ScoreImpl) then,
  ) = __$$ScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int home, int away});
}

/// @nodoc
class __$$ScoreImplCopyWithImpl<$Res>
    extends _$ScoreCopyWithImpl<$Res, _$ScoreImpl>
    implements _$$ScoreImplCopyWith<$Res> {
  __$$ScoreImplCopyWithImpl(
    _$ScoreImpl _value,
    $Res Function(_$ScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? home = null, Object? away = null}) {
    return _then(
      _$ScoreImpl(
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
class _$ScoreImpl implements _Score {
  const _$ScoreImpl({this.home = 0, this.away = 0});

  factory _$ScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoreImplFromJson(json);

  @override
  @JsonKey()
  final int home;
  @override
  @JsonKey()
  final int away;

  @override
  String toString() {
    return 'Score(home: $home, away: $away)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreImpl &&
            (identical(other.home, home) || other.home == home) &&
            (identical(other.away, away) || other.away == away));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, home, away);

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreImplCopyWith<_$ScoreImpl> get copyWith =>
      __$$ScoreImplCopyWithImpl<_$ScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoreImplToJson(this);
  }
}

abstract class _Score implements Score {
  const factory _Score({final int home, final int away}) = _$ScoreImpl;

  factory _Score.fromJson(Map<String, dynamic> json) = _$ScoreImpl.fromJson;

  @override
  int get home;
  @override
  int get away;

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoreImplCopyWith<_$ScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchState _$MatchStateFromJson(Map<String, dynamic> json) {
  return _MatchState.fromJson(json);
}

/// @nodoc
mixin _$MatchState {
  int get rallyId => throw _privateConstructorUsedError;
  int get rotationTick =>
      throw _privateConstructorUsedError; // even = HOME serves, odd = AWAY serves
  TeamSide get serverSide =>
      throw _privateConstructorUsedError; // current server’s team
  Score get score => throw _privateConstructorUsedError;
  MatchPhase get phase => throw _privateConstructorUsedError;
  int get setsHome => throw _privateConstructorUsedError;
  int get setsAway => throw _privateConstructorUsedError;
  int get setNumber => throw _privateConstructorUsedError; // 1–5
  bool get isMatchOver => throw _privateConstructorUsedError;

  /// Serializes this MatchState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchStateCopyWith<MatchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchStateCopyWith<$Res> {
  factory $MatchStateCopyWith(
    MatchState value,
    $Res Function(MatchState) then,
  ) = _$MatchStateCopyWithImpl<$Res, MatchState>;
  @useResult
  $Res call({
    int rallyId,
    int rotationTick,
    TeamSide serverSide,
    Score score,
    MatchPhase phase,
    int setsHome,
    int setsAway,
    int setNumber,
    bool isMatchOver,
  });

  $ScoreCopyWith<$Res> get score;
}

/// @nodoc
class _$MatchStateCopyWithImpl<$Res, $Val extends MatchState>
    implements $MatchStateCopyWith<$Res> {
  _$MatchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rallyId = null,
    Object? rotationTick = null,
    Object? serverSide = null,
    Object? score = null,
    Object? phase = null,
    Object? setsHome = null,
    Object? setsAway = null,
    Object? setNumber = null,
    Object? isMatchOver = null,
  }) {
    return _then(
      _value.copyWith(
            rallyId: null == rallyId
                ? _value.rallyId
                : rallyId // ignore: cast_nullable_to_non_nullable
                      as int,
            rotationTick: null == rotationTick
                ? _value.rotationTick
                : rotationTick // ignore: cast_nullable_to_non_nullable
                      as int,
            serverSide: null == serverSide
                ? _value.serverSide
                : serverSide // ignore: cast_nullable_to_non_nullable
                      as TeamSide,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as Score,
            phase: null == phase
                ? _value.phase
                : phase // ignore: cast_nullable_to_non_nullable
                      as MatchPhase,
            setsHome: null == setsHome
                ? _value.setsHome
                : setsHome // ignore: cast_nullable_to_non_nullable
                      as int,
            setsAway: null == setsAway
                ? _value.setsAway
                : setsAway // ignore: cast_nullable_to_non_nullable
                      as int,
            setNumber: null == setNumber
                ? _value.setNumber
                : setNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            isMatchOver: null == isMatchOver
                ? _value.isMatchOver
                : isMatchOver // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScoreCopyWith<$Res> get score {
    return $ScoreCopyWith<$Res>(_value.score, (value) {
      return _then(_value.copyWith(score: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MatchStateImplCopyWith<$Res>
    implements $MatchStateCopyWith<$Res> {
  factory _$$MatchStateImplCopyWith(
    _$MatchStateImpl value,
    $Res Function(_$MatchStateImpl) then,
  ) = __$$MatchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int rallyId,
    int rotationTick,
    TeamSide serverSide,
    Score score,
    MatchPhase phase,
    int setsHome,
    int setsAway,
    int setNumber,
    bool isMatchOver,
  });

  @override
  $ScoreCopyWith<$Res> get score;
}

/// @nodoc
class __$$MatchStateImplCopyWithImpl<$Res>
    extends _$MatchStateCopyWithImpl<$Res, _$MatchStateImpl>
    implements _$$MatchStateImplCopyWith<$Res> {
  __$$MatchStateImplCopyWithImpl(
    _$MatchStateImpl _value,
    $Res Function(_$MatchStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rallyId = null,
    Object? rotationTick = null,
    Object? serverSide = null,
    Object? score = null,
    Object? phase = null,
    Object? setsHome = null,
    Object? setsAway = null,
    Object? setNumber = null,
    Object? isMatchOver = null,
  }) {
    return _then(
      _$MatchStateImpl(
        rallyId: null == rallyId
            ? _value.rallyId
            : rallyId // ignore: cast_nullable_to_non_nullable
                  as int,
        rotationTick: null == rotationTick
            ? _value.rotationTick
            : rotationTick // ignore: cast_nullable_to_non_nullable
                  as int,
        serverSide: null == serverSide
            ? _value.serverSide
            : serverSide // ignore: cast_nullable_to_non_nullable
                  as TeamSide,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as Score,
        phase: null == phase
            ? _value.phase
            : phase // ignore: cast_nullable_to_non_nullable
                  as MatchPhase,
        setsHome: null == setsHome
            ? _value.setsHome
            : setsHome // ignore: cast_nullable_to_non_nullable
                  as int,
        setsAway: null == setsAway
            ? _value.setsAway
            : setsAway // ignore: cast_nullable_to_non_nullable
                  as int,
        setNumber: null == setNumber
            ? _value.setNumber
            : setNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        isMatchOver: null == isMatchOver
            ? _value.isMatchOver
            : isMatchOver // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchStateImpl implements _MatchState {
  const _$MatchStateImpl({
    required this.rallyId,
    required this.rotationTick,
    required this.serverSide,
    required this.score,
    required this.phase,
    this.setsHome = 0,
    this.setsAway = 0,
    this.setNumber = 1,
    this.isMatchOver = false,
  });

  factory _$MatchStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchStateImplFromJson(json);

  @override
  final int rallyId;
  @override
  final int rotationTick;
  // even = HOME serves, odd = AWAY serves
  @override
  final TeamSide serverSide;
  // current server’s team
  @override
  final Score score;
  @override
  final MatchPhase phase;
  @override
  @JsonKey()
  final int setsHome;
  @override
  @JsonKey()
  final int setsAway;
  @override
  @JsonKey()
  final int setNumber;
  // 1–5
  @override
  @JsonKey()
  final bool isMatchOver;

  @override
  String toString() {
    return 'MatchState(rallyId: $rallyId, rotationTick: $rotationTick, serverSide: $serverSide, score: $score, phase: $phase, setsHome: $setsHome, setsAway: $setsAway, setNumber: $setNumber, isMatchOver: $isMatchOver)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchStateImpl &&
            (identical(other.rallyId, rallyId) || other.rallyId == rallyId) &&
            (identical(other.rotationTick, rotationTick) ||
                other.rotationTick == rotationTick) &&
            (identical(other.serverSide, serverSide) ||
                other.serverSide == serverSide) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.phase, phase) || other.phase == phase) &&
            (identical(other.setsHome, setsHome) ||
                other.setsHome == setsHome) &&
            (identical(other.setsAway, setsAway) ||
                other.setsAway == setsAway) &&
            (identical(other.setNumber, setNumber) ||
                other.setNumber == setNumber) &&
            (identical(other.isMatchOver, isMatchOver) ||
                other.isMatchOver == isMatchOver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rallyId,
    rotationTick,
    serverSide,
    score,
    phase,
    setsHome,
    setsAway,
    setNumber,
    isMatchOver,
  );

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchStateImplCopyWith<_$MatchStateImpl> get copyWith =>
      __$$MatchStateImplCopyWithImpl<_$MatchStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchStateImplToJson(this);
  }
}

abstract class _MatchState implements MatchState {
  const factory _MatchState({
    required final int rallyId,
    required final int rotationTick,
    required final TeamSide serverSide,
    required final Score score,
    required final MatchPhase phase,
    final int setsHome,
    final int setsAway,
    final int setNumber,
    final bool isMatchOver,
  }) = _$MatchStateImpl;

  factory _MatchState.fromJson(Map<String, dynamic> json) =
      _$MatchStateImpl.fromJson;

  @override
  int get rallyId;
  @override
  int get rotationTick; // even = HOME serves, odd = AWAY serves
  @override
  TeamSide get serverSide; // current server’s team
  @override
  Score get score;
  @override
  MatchPhase get phase;
  @override
  int get setsHome;
  @override
  int get setsAway;
  @override
  int get setNumber; // 1–5
  @override
  bool get isMatchOver;

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchStateImplCopyWith<_$MatchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
