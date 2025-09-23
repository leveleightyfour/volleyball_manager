import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_lite.freezed.dart';
part 'player_lite.g.dart';

enum Role { oh, opp, mb, s, l }

@freezed
class PlayerLite with _$PlayerLite {
  const factory PlayerLite({
    required int id,
    required int number,
    required Role role,
    @Default(false) bool isLibero,
  }) = _PlayerLite;

  factory PlayerLite.fromJson(Map<String, dynamic> json) =>
      _$PlayerLiteFromJson(json);
}
