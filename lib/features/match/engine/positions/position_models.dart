import 'package:freezed_annotation/freezed_annotation.dart';

part 'position_models.freezed.dart';
part 'position_models.g.dart';

enum PositionPhase { serve, receive, transition_offense, defense }

@freezed
class RolePoint with _$RolePoint {
  const factory RolePoint({required double x, required double y}) = _RolePoint;

  factory RolePoint.fromJson(Map<String, dynamic> json) =>
      _$RolePointFromJson(json);
}

@freezed
class PositionLayout with _$PositionLayout {
  const factory PositionLayout({
    /// role -> {x,y}
    required Map<String, RolePoint> roles,
  }) = _PositionLayout;

  factory PositionLayout.fromJson(Map<String, dynamic> json) =>
      _$PositionLayoutFromJson(json);
}

/// Flat book: "<phase>/<team>/<rotation>/<tactic>" -> PositionLayout
@freezed
class PositionBook with _$PositionBook {
  @JsonSerializable(explicitToJson: true)
  const factory PositionBook({required Map<String, PositionLayout> layouts}) =
      _PositionBook;

  factory PositionBook.fromJson(Map<String, dynamic> json) =>
      _$PositionBookFromJson(json);
}

String positionKey(
  String phase,
  String team,
  String rotation, {
  String tactic = 'default',
}) => '$phase/$team/$rotation/$tactic';

extension PositionBookLookup on PositionBook {
  PositionLayout? getLayout(
    String phase,
    String team,
    String rotation, {
    String tactic = 'default',
  }) {
    return layouts[positionKey(phase, team, rotation, tactic: tactic)] ??
        layouts[positionKey(phase, team, rotation, tactic: 'default')];
  }
}
