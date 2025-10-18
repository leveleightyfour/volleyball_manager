// Core contracts shared by all phases and the controller.

import 'dart:ui';

/// Fine-grained rendering phases inside a single high-level MatchPhase.
enum Phase {
  preServe,
  serveFlight,
  reception,
  transition,
  setReady,
  attack,
  block,
  defence,
  rallyEnd,
}

/// Per-frame snapshot for rendering.
/// Coordinates are normalized (0..1) on the RECEIVING half-court.
class SimFrame {
  SimFrame({
    required this.t,
    required this.phase,
    required this.players,
    this.ball,
  });

  /// Seconds since the start of this phase sequence.
  final double t;

  /// Rendering phase marker for the current frame.
  final Phase phase;

  /// Optional ball position (normalized).
  final Offset? ball;

  /// Current role positions. Use Role keys directly.
  final Map<Role, Offset> players;
}

/// Team side (reuse your own if you already have one).
enum TeamSide { home, away }

/// Role (reuse your own later; this keeps the skeleton compiling).
enum Role { S, OH1, OH2, MB1, MB2, OPP, L }

/// Pass quality from serve–receive phase.
enum PassQuality { overpass, three, two, one, error }

/// High-level rally lifecycle markers (coarse).
enum MatchPhase { preServe, serve, attack, rallyEnd }

/// Immutable context shared across phases in a rally.
class PhaseContext {
  PhaseContext({
    required this.rotationHome, // 1..6
    required this.rotationAway, // 1..6
    required this.servingHome, // who serves this rally
    required this.phase, // high-level phase marker
    this.receiveQuality,
    this.setterTarget,
  });

  final int rotationHome;
  final int rotationAway;
  final bool servingHome;
  final MatchPhase phase;

  final PassQuality? receiveQuality; // set by ServeReceive
  final Offset? setterTarget; // set by ServeReceive

  PhaseContext copyWith({
    int? rotationHome,
    int? rotationAway,
    bool? servingHome,
    MatchPhase? phase,
    PassQuality? receiveQuality,
    Offset? setterTarget,
  }) {
    return PhaseContext(
      rotationHome: rotationHome ?? this.rotationHome,
      rotationAway: rotationAway ?? this.rotationAway,
      servingHome: servingHome ?? this.servingHome,
      phase: phase ?? this.phase,
      receiveQuality: receiveQuality ?? this.receiveQuality,
      setterTarget: setterTarget ?? this.setterTarget,
    );
  }
}

/// Output of a phase: frame stream, optional updated context, optional terminal point.
class PhaseResult {
  PhaseResult({
    required this.frames,
    this.updatedContext,
    this.rallyEnded = false,
    this.pointToHome,
  });

  final Stream<SimFrame> frames;
  final PhaseContext? updatedContext;
  final bool rallyEnded;
  final bool? pointToHome; // non-null only when rallyEnded == true
}

/// Every phase system implements this.
abstract class PhaseSystem {
  PhaseSystem({required this.ctx});
  final PhaseContext ctx;

  Future<PhaseResult> run();
}
