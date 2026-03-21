// lib/features/match/game/services/simulation_coordinator.dart
import 'package:flutter/material.dart';
import 'package:volleyball_manager/features/match/engine/sim/sim_controller.dart';
import 'package:volleyball_manager/features/match/engine/events/events.dart';

/// Coordinates simulation stepping and manages step scheduling.
///
/// Responsibilities:
/// - Manage simulation step lifecycle
/// - Handle step requests and queuing
/// - Prevent concurrent stepping
/// - Provide callbacks for event handling and rotation sync
class SimulationCoordinator {
  SimulationCoordinator({
    required this.sim,
    required this.onEvents,
    required this.onRotationSync,
  });

  final SimController sim;
  final void Function(List<EngineEvent>) onEvents;
  final VoidCallback onRotationSync;

  // Step scheduler state
  bool _isStepping = false;
  bool _pendingStep = false;

  /// Get current rotation tick from the simulation
  int get rotationTick => sim.state.rotationTick;

  /// Request a simulation step
  ///
  /// If a step is already in progress, this will queue the request
  /// to be executed after the current step completes.
  void requestStep() {
    if (_isStepping) {
      _pendingStep = true;
    } else {
      _stepSim();
    }
  }

  /// Execute a simulation step
  Future<void> _stepSim() async {
    if (_isStepping) return;
    _isStepping = true;
    try {
      final res = await sim.advance();
      onRotationSync(); // sync rotation BEFORE events so layout uses correct rotation
      onEvents(res.events);
    } finally {
      _isStepping = false;
      if (_pendingStep) {
        _pendingStep = false;
        Future.microtask(_stepSim);
      }
    }
  }
}
