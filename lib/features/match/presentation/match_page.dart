import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volleyball_manager/features/match/engine/sim/sim_provider.dart';
import 'package:volleyball_manager/features/match/game/match_game.dart';

class MatchPage extends ConsumerWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sim = ref.read(simControllerProvider);
    return Scaffold(
      body: GameWidget(game: MatchGame(sim: sim)),
    );
  }
}
