import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

import '../components/player_component.dart';
import '../model/move_command.dart';

/// Starts movement animations for one or more players.
/// Keeps effect details out of MatchGame.
class MoveScheduler {
  const MoveScheduler(this._players);
  final Map<int, PlayerComponent> _players;

  /// Starts all moves *on the same frame* so they run simultaneously.
  void startSimultaneous(Iterable<MoveCommand> moves) {
    for (final m in moves) {
      final node = _players[m.playerId];
      if (node == null) continue;

      // Prevent stacking conflicting movement effects.
      node.children.whereType<MoveEffect>().toList().forEach(node.remove);

      node.add(
        MoveEffect.to(
          Vector2(m.to.dx, m.to.dy),
          EffectController(
            duration: m.durationSec > 0 ? m.durationSec : 0.001,
            curve: Curves.easeInOut,
          ),
        ),
      );
    }
  }
}
