import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volleyball_manager/features/match/engine/positions/position_providers.dart';
import 'package:volleyball_manager/features/match/engine/sim/sim_provider.dart';
import 'package:volleyball_manager/features/match/game/match_game.dart';

class MatchPage extends ConsumerWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sim = ref.read(simControllerProvider);

    final resolver = ref.watch(positionResolverProvider);
    return resolver.when(
      data: (posResolver) {
        if (posResolver == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: GameWidget(
              game: MatchGame(
                sim: sim,
                positionResolver: posResolver,
                debugOverlayEnabled: false,
                playerRadius: 22,
                courtPadding: 12,
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) =>
          Scaffold(body: Center(child: Text('Failed to load positions: $e'))),
    );
  }
}
