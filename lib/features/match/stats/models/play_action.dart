import 'package:freezed_annotation/freezed_annotation.dart';
import '../../engine/state/match_state.dart';

part 'play_action.freezed.dart';
part 'play_action.g.dart';

enum PlayType { serve, pass, set, attack }

@freezed
class PlayAction with _$PlayAction {
  const factory PlayAction({
    required int rallyId,
    required int rotationTick,
    required TeamSide side,
    required PlayType type,
    required String outcome,
    required DateTime timestamp,
  }) = _PlayAction;

  factory PlayAction.fromJson(Map<String, dynamic> json) =>
      _$PlayActionFromJson(json);
}
