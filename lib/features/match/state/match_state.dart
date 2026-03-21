import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_state.freezed.dart';
part 'match_state.g.dart';

enum TeamSide { home, away }

enum MatchPhase {
  preServe,  // choose server/receiver
  serve,     // ball in flight on serve
  reception, // pass result processed
  setting,   // setting/choice
  attack,    // attack resolution
  dig,       // transition touch — defending team plays a dug/deflected ball
  rallyEnd,  // rally concluded (score/rotation handled)
}

@freezed
class Score with _$Score {
  const factory Score({@Default(0) int home, @Default(0) int away}) = _Score;

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);
}

@freezed
class MatchState with _$MatchState {
  const factory MatchState({
    required int rallyId,
    required int rotationTick, // even = HOME serves, odd = AWAY serves
    required TeamSide serverSide, // current server’s team
    required Score score,
    required MatchPhase phase,
    @Default(0) int setsHome,
    @Default(0) int setsAway,
    @Default(1) int setNumber, // 1–5
    @Default(false) bool isMatchOver,
  }) = _MatchState;

  factory MatchState.initial({TeamSide firstServer = TeamSide.home}) =>
      MatchState(
        rallyId: 1,
        rotationTick: firstServer == TeamSide.home ? 0 : 1,
        serverSide: firstServer,
        score: const Score(),
        phase: MatchPhase.preServe,
      );

  factory MatchState.fromJson(Map<String, dynamic> json) =>
      _$MatchStateFromJson(json);
}
