import 'package:freezed_annotation/freezed_annotation.dart';
import '../state/match_state.dart';

part 'events.freezed.dart';
part 'events.g.dart';

@freezed
class EngineEvent with _$EngineEvent {
  // Visual cues
  const factory EngineEvent.serveBallFlight({
    required TeamSide fromSide,
    required double durationSec,
  }) = ServeBallFlight;

  const factory EngineEvent.playerMove({
    required int playerId, // reserved for future granular moves
    required double toX,
    required double toY,
    @Default(0.5) double durationSec,
  }) = PlayerMove;

  // Score / rotation / lifecycle
  const factory EngineEvent.scoreChanged({
    required int home,
    required int away,
  }) = ScoreChanged;

  const factory EngineEvent.rotationAdvanced({
    required int rotationTick,
    required TeamSide serverSide,
  }) = RotationAdvanced;

  const factory EngineEvent.phaseChanged({
    required MatchPhase phase,
    required int rallyId,
  }) = PhaseChanged;

  const factory EngineEvent.rallyEnded({
    required TeamSide pointTo,
    required int rallyId,
  }) = RallyEnded;

  factory EngineEvent.fromJson(Map<String, Object?> json) =>
      _$EngineEventFromJson(json);
}
