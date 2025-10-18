// lib/features/match/presentation/match_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';
import 'package:volleyball_manager/features/match/engine/positions/position_providers.dart';
import 'package:volleyball_manager/features/match/engine/sim/sim_provider.dart';

import '../game/match_game.dart';
import 'camera_controls.dart';

class MatchPage extends ConsumerStatefulWidget {
  const MatchPage({super.key});

  @override
  ConsumerState<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends ConsumerState<MatchPage> {
  MatchGame? _game;
  CameraView _currentView = CameraView.large; // Default to large

  void _toggleCameraView() {
    setState(() {
      if (_currentView == CameraView.large) {
        _currentView = CameraView.small;
        _game?.positionCourtTopLeftQuarter();
      } else {
        _currentView = CameraView.large;
        _game?.positionCourtTopTwoThirds();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(positionsStatusProvider);

    if (status == PositionsStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (status == PositionsStatus.readyEmpty) {
      return const Scaffold(
        body: Center(child: Text('⚠️ No position layouts loaded')),
      );
    }

    final resolver = ref.watch(positionResolverProviderSync);
    final sim = ref.read(simControllerProvider);

    _game ??= MatchGame(sim: sim, ref: ref, positionResolver: resolver);

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game!),
          CameraControls(
            currentView: _currentView,
            onToggle: _toggleCameraView,
          ),
        ],
      ),
    );
  }
}
