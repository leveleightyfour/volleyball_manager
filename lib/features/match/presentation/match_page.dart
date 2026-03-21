// lib/features/match/presentation/match_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';
import 'package:volleyball_manager/features/match/engine/positions/position_providers.dart';
import 'package:volleyball_manager/features/match/engine/sim/match_sim_runner.dart';
import 'package:volleyball_manager/features/match/engine/sim/sim_provider.dart';
import 'package:volleyball_manager/features/match/data/services/audit_log_service.dart';

import '../game/match_game.dart';
import 'camera_controls.dart';
import 'sim_result_page.dart';

class MatchPage extends ConsumerStatefulWidget {
  const MatchPage({super.key});

  @override
  ConsumerState<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends ConsumerState<MatchPage> {
  MatchGame? _game;
  CameraView _currentView = CameraView.large; // Default to large
  bool _simulating = false;

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

  Future<void> _simulateMatch() async {
    setState(() => _simulating = true);
    try {
      final result = await MatchSimRunner.run();
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SimResultPage(result: result)),
      );
    } finally {
      if (mounted) setState(() => _simulating = false);
    }
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

    if (_game == null) {
      _game = MatchGame(sim: sim, ref: ref, positionResolver: resolver);
      // Start match record in audit log (fire-and-forget; matchId stored in service)
      ref.read(auditLogServiceProvider).startMatch();
    }

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game!),
          CameraControls(
            currentView: _currentView,
            onToggle: _toggleCameraView,
          ),
          Positioned(
            top: 12,
            left: 12,
            child: _simulating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.cyanAccent))
                : GestureDetector(
                    onTap: _simulateMatch,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.cyanAccent),
                      ),
                      child: const Text('SIMULATE MATCH',
                          style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
