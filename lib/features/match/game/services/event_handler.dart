// lib/features/match/game/services/event_handler.dart
import 'package:flutter/material.dart';

import 'package:volleyball_manager/features/match/engine/events/events.dart';
import 'package:volleyball_manager/features/match/state/match_state.dart'
    show TeamSide, MatchPhase;
import 'package:volleyball_manager/features/match/game/model/move_command.dart';
import 'package:volleyball_manager/features/match/game/services/move_scheduler.dart';
import 'package:volleyball_manager/features/match/game/components/ball_component.dart';

/// Handles engine events and coordinates visual animations.
///
/// Responsibilities:
/// - Process events from the simulation engine
/// - Coordinate player movement animations
/// - Manage ball animations (serve, etc.)
/// - Trigger simulation steps at appropriate times
/// - Manage serve-in-flight state
class EventHandler {
  EventHandler({
    required this.moveScheduler,
    required this.ball,
    required this.onLayoutUpdate,
    required this.requestStep,
  });

  final MoveScheduler moveScheduler;
  final BallComponent? ball;
  final VoidCallback onLayoutUpdate;
  final VoidCallback requestStep;

  // State tracking
  bool _serveInFlight = false;

  /// Get current serve-in-flight state
  bool get serveInFlight => _serveInFlight;

  /// Reset serve-in-flight state
  void resetServeState() {
    _serveInFlight = false;
  }

  /// Process a list of engine events
  void handleEvents(List<EngineEvent> events) {
    final queued = <MoveCommand>[];

    for (final e in events) {
      e.when(
        serveBallFlight: (fromSide, durationSec) {
          _handleServeBallFlight(fromSide, durationSec);
        },
        playerMove: (playerId, toX, toY, durationSec) {
          queued.add(
            MoveCommand(
              playerId: playerId,
              to: Offset(toX, toY),
              durationSec: durationSec,
            ),
          );
        },
        scoreChanged: (home, away) {
          // Score updates are handled elsewhere (UI overlays)
        },
        rotationAdvanced: (rotationTick, serverSide) {
          // Trigger layout update for new rotation
          onLayoutUpdate();
        },
        phaseChanged: (phase, rallyId) {
          _handlePhaseChanged(phase);
        },
        rallyEnded: (pointTo, rallyId) {
          _handleRallyEnded();
        },
        setEnded: (winner, setsHome, setsAway, setNumber, finalScoreHome, finalScoreAway) {
          // Set ended — visual handling (score board, pause) to be added.
        },
        matchEnded: (winner, setsHome, setsAway, finalScoreHome, finalScoreAway) {
          // Match ended — stop stepping.
          _serveInFlight = false;
        },
      );
    }

    // Execute all queued player movements simultaneously
    if (queued.isNotEmpty) {
      moveScheduler.startSimultaneous(queued);
    }
  }

  /// Animate a serve with ball flight
  void animateServe({
    required Offset from,
    required Offset to,
    required double durationSec,
    required VoidCallback onDone,
  }) {
    ball?.serve(
      from: from,
      to: to,
      durationSec: durationSec,
      onComplete: onDone,
    );
  }

  // ------------- Private Event Handlers -------------

  void _handleServeBallFlight(TeamSide fromSide, double durationSec) {
    if (_serveInFlight) return;
    _serveInFlight = true;
    // Advance is handled exclusively by the serve animation's onDone callback
    // in MatchGame. This method only tracks in-flight state.
  }

  void _handlePhaseChanged(MatchPhase phase) {
    if (phase == MatchPhase.preServe) {
      _serveInFlight = false;
      Future.delayed(const Duration(milliseconds: 1500), requestStep);
      return;
    }
    // serve: wait for serve animation callback
    // setting: wait for pass-ball animation callback (handled in MatchGame)
    // attack: wait for set-ball animation callback (handled in MatchGame)
    if (phase == MatchPhase.serve ||
        phase == MatchPhase.setting ||
        phase == MatchPhase.attack) {
      return;
    }
    requestStep();
  }

  void _handleRallyEnded() {
    _serveInFlight = false;
    Future.delayed(const Duration(seconds: 3), () {
      requestStep();
    });
  }
}
