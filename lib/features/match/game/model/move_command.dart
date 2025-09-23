import 'dart:ui';

class MoveCommand {
  const MoveCommand({
    required this.playerId,
    required this.to,
    required this.durationSec,
  });

  final int playerId;
  final Offset to;
  final double durationSec;
}
