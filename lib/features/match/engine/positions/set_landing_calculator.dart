// lib/features/match/engine/positions/set_landing_calculator.dart
import 'dart:math';
import 'dart:ui';
import 'package:volleyball_manager/features/match/engine/outcomes/outcomes.dart';
import 'package:volleyball_manager/features/match/state/match_state.dart';

/// Maps a [SetOutcome] to a screen-space attack contact [Offset] plus ball
/// flight parameters, using real volleyball court measurements.
///
/// Coordinate convention (matches PassLandingCalculator):
///   x = 0.0 → own endline    x = 1.0 → net
///   y = 0.0 → top sideline   y = 1.0 → bottom sideline
///
/// y values are authored for the home team (position 4 at top, y ≈ 0.06–0.18).
/// For the away team, y is mirrored in _toScreen so their position 4 (OH) maps
/// to the bottom of screen (y ≈ 0.82–0.94) as their court is flipped.
///
/// Attack zones (normalised within the attacking team's half):
///
///   leftSideHigh / leftSideTempo  — pos 4, OH near top sideline
///   rightSideHigh / rightSideTempo — pos 2, OPP near bottom sideline
///   middle                        — pos 3, MB front-centre
///   backrow                       — pos 1, OPP back-right
///   pipe                          — pos 6, back-centre
///   tip                           — setter tip, just over the net
class SetLandingCalculator {
  // ── Zone constants (normalised, attacking team's half) ──────────────────

  // Left pin (position 4): near the net, top sideline
  static const double _leftMinX = 0.88;
  static const double _leftMaxX = 0.96;
  static const double _leftMinY = 0.06;
  static const double _leftMaxY = 0.18;

  // Right side (position 2): near the net, bottom sideline
  static const double _rightMinX = 0.88;
  static const double _rightMaxX = 0.96;
  static const double _rightMinY = 0.82;
  static const double _rightMaxY = 0.94;

  // Middle (position 3): at the net, centre
  static const double _midMinX = 0.88;
  static const double _midMaxX = 0.96;
  static const double _midMinY = 0.40;
  static const double _midMaxY = 0.60;

  // Back row right (position 1): 2 m from net, near right sideline (pos 1)
  static const double _backrowMinX = 0.76;
  static const double _backrowMaxX = 0.82;
  static const double _backrowMinY = 0.74;
  static const double _backrowMaxY = 0.88;

  // Pipe (position 6): 2 m from net, centre of court
  static const double _pipeMinX = 0.76;
  static const double _pipeMaxX = 0.82;
  static const double _pipeMinY = 0.40;
  static const double _pipeMaxY = 0.60;

  // Tip: just in front of setter, near net
  static const double _tipMinX = 0.86;
  static const double _tipMaxX = 0.96;
  static const double _tipMinY = 0.28;
  static const double _tipMaxY = 0.72;

  // ── Public API ──────────────────────────────────────────────────────────

  static ({
    Offset position,
    double peakHeightM,
    double toHeightM,
    double durationSec,
  }) compute({
    required SetOutcome outcome,
    required TeamSide attackingSide,
    required Rect attackingHalf,
    required Random rng,
  }) {
    final pos = _position(outcome, attackingSide, attackingHalf, rng);
    final flight = _flight(outcome);
    return (
      position: pos,
      peakHeightM: flight.$1,
      toHeightM: flight.$2,
      durationSec: flight.$3,
    );
  }

  // ── Position helpers ────────────────────────────────────────────────────

  static Offset _position(
    SetOutcome outcome,
    TeamSide side,
    Rect half,
    Random rng,
  ) =>
      switch (outcome) {
        SetOutcome.leftSideTempo || SetOutcome.leftSideHigh => _zone(
            half, side, rng,
            minX: _leftMinX, maxX: _leftMaxX,
            minY: _leftMinY, maxY: _leftMaxY),
        SetOutcome.rightSideTempo || SetOutcome.rightSideHigh => _zone(
            half, side, rng,
            minX: _rightMinX, maxX: _rightMaxX,
            minY: _rightMinY, maxY: _rightMaxY),
        SetOutcome.middle => _zone(
            half, side, rng,
            minX: _midMinX, maxX: _midMaxX,
            minY: _midMinY, maxY: _midMaxY),
        SetOutcome.backrow => _zone(
            half, side, rng,
            minX: _backrowMinX, maxX: _backrowMaxX,
            minY: _backrowMinY, maxY: _backrowMaxY),
        SetOutcome.pipe => _zone(
            half, side, rng,
            minX: _pipeMinX, maxX: _pipeMaxX,
            minY: _pipeMinY, maxY: _pipeMaxY),
        SetOutcome.tip => _zone(
            half, side, rng,
            minX: _tipMinX, maxX: _tipMaxX,
            minY: _tipMinY, maxY: _tipMaxY),
      };

  // (peakHeightM, toHeightM, durationSec)
  static (double, double, double) _flight(SetOutcome outcome) => switch (outcome) {
        SetOutcome.leftSideTempo || SetOutcome.rightSideTempo => (3.5, 3.2, 0.70),
        SetOutcome.leftSideHigh  || SetOutcome.rightSideHigh  => (5.5, 3.5, 1.30),
        SetOutcome.middle                                      => (3.7, 3.5, 0.45),
        SetOutcome.backrow || SetOutcome.pipe                  => (5.0, 2.5, 1.20),
        SetOutcome.tip                                         => (3.5, 2.0, 0.60),
      };

  // ── Screen-space helpers ────────────────────────────────────────────────

  static Offset _toScreen(Rect half, TeamSide side, double nx, double ny) {
    final x = side == TeamSide.home
        ? half.left + half.width * nx
        : half.right - half.width * nx;
    // y values are authored for home team (OH at top, OPP at bottom).
    // Away team's court is mirrored, so flip y for away.
    final ey = side == TeamSide.away ? 1.0 - ny : ny;
    return Offset(x, half.top + half.height * ey);
  }

  static Offset _zone(
    Rect half,
    TeamSide side,
    Random rng, {
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
  }) {
    final nx = minX + rng.nextDouble() * (maxX - minX);
    final ny = minY + rng.nextDouble() * (maxY - minY);
    return _toScreen(half, side, nx, ny);
  }
}
