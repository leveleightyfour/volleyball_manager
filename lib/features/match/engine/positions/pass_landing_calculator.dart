// lib/features/match/engine/positions/pass_landing_calculator.dart
import 'dart:math';
import 'dart:ui';
import 'package:volleyball_manager/features/match/engine/outcomes/outcomes.dart';
import 'package:volleyball_manager/features/match/state/match_state.dart';

/// Maps a [PassOutcome] to a screen-space landing [Offset] using real
/// volleyball court measurements.
///
/// Court dimensions (real):
///   Each half  9 m long (endline → net) × 9 m wide
///
/// Normalised coords within a half-court rect:
///   x = 0.0 → own endline   x = 1.0 → net
///   y = 0.0 → top sideline  y = 1.0 → bottom sideline
///
/// Zone definitions (receiving team's perspective):
///
///   perfect      ≤ 2 m from net (x ≥ 7/9),  middle 6 m (y 1.5/9 – 7.5/9)
///   average      ≤ 6 m from net (x ≥ 3/9),  ≤ 1 m outside either sideline
///   singleOption own half, outside the average zone (deep or very wide)
///   overpass     crosses the net into the opponent's half, inside the court
///   shank        off-court — ball flies away and ends the rally
class PassLandingCalculator {
  // ---------------------------------------------------------------------------
  // Zone constants (normalised, receiving team's half)
  // ---------------------------------------------------------------------------

  // Perfect: within 2 m of net, middle 6 m of the 9 m width
  static const double _perfMinX = 7.0 / 9.0; // ≈ 0.778
  static const double _perfMaxX = 0.96;       // leave a margin before the net
  static const double _perfMinY = 1.5 / 9.0; // ≈ 0.167
  static const double _perfMaxY = 7.5 / 9.0; // ≈ 0.833

  // Average: within 6 m of net, up to 1 m outside either sideline
  static const double _avgMinX = 3.0 / 9.0;  // ≈ 0.333
  static const double _avgMaxX = 0.96;
  static const double _avgMinY = -1.0 / 9.0; // ≈ -0.111
  static const double _avgMaxY = 10.0 / 9.0; // ≈  1.111

  // Single option: own half, deep (beyond 6 m from net) or very wide (> 1 m outside)
  // Split into two sub-zones and pick one at random.
  //   deep:  x 0.05 – 0.40,  y 0.05 – 0.95
  //   wide:  x 0.10 – 0.90,  y outside (-0.35 to -0.12) or (1.12 to 1.35)
  static const double _singleDeepMaxX = 0.40;
  static const double _singleWideOutset = 0.12; // min distance outside sideline

  // Overpass: lands in opponent's half, within the court, not too near their endline
  static const double _overMinX = 0.50; // normalised within opponent's half
  static const double _overMaxX = 0.90;
  static const double _overMinY = 0.10;
  static const double _overMaxY = 0.90;

  // Shank: off-court — random direction away from the court
  static const double _shankOut = 0.18; // min normalised distance outside court

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  static Offset compute({
    required PassOutcome outcome,
    required TeamSide receivingSide,
    required Rect receivingHalf,
    required Rect fullCourt,
    required Random rng,
  }) {
    switch (outcome) {
      case PassOutcome.perfect:
        return _zone(receivingHalf, receivingSide, rng,
            minX: _perfMinX, maxX: _perfMaxX, minY: _perfMinY, maxY: _perfMaxY);

      case PassOutcome.average:
        return _zone(receivingHalf, receivingSide, rng,
            minX: _avgMinX, maxX: _avgMaxX, minY: _avgMinY, maxY: _avgMaxY);

      case PassOutcome.singleOption:
        return _singleOption(receivingHalf, receivingSide, rng);

      case PassOutcome.overpass:
        return _overpass(fullCourt, receivingSide, rng);

      case PassOutcome.shank:
        return _shank(receivingHalf, receivingSide, rng);
    }
  }

  // ---------------------------------------------------------------------------
  // Zone helpers
  // ---------------------------------------------------------------------------

  static Offset _toScreen(Rect half, TeamSide side, double nx, double ny) {
    final x = side == TeamSide.home
        ? half.left + half.width * nx
        : half.right - half.width * nx;
    final y = half.top + half.height * ny;
    return Offset(x, y);
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

  static Offset _singleOption(Rect half, TeamSide side, Random rng) {
    if (rng.nextBool()) {
      // Deep in own half
      return _zone(half, side, rng,
          minX: 0.05, maxX: _singleDeepMaxX, minY: 0.05, maxY: 0.95);
    } else {
      // Very wide — pick top or bottom
      final goTop = rng.nextBool();
      final ny = goTop
          ? -(_singleWideOutset + rng.nextDouble() * 0.20)
          : 1.0 + _singleWideOutset + rng.nextDouble() * 0.20;
      final nx = 0.10 + rng.nextDouble() * 0.80;
      return _toScreen(half, side, nx, ny);
    }
  }

  static Offset _overpass(Rect fullCourt, TeamSide receivingSide, Random rng) {
    // Opponent's half is the opposite of the receiving side.
    final midX = fullCourt.left + fullCourt.width / 2;
    final opponentSide =
        receivingSide == TeamSide.home ? TeamSide.away : TeamSide.home;
    final opponentHalf = opponentSide == TeamSide.home
        ? Rect.fromLTRB(fullCourt.left, fullCourt.top, midX, fullCourt.bottom)
        : Rect.fromLTRB(midX, fullCourt.top, fullCourt.right, fullCourt.bottom);
    return _zone(opponentHalf, opponentSide, rng,
        minX: _overMinX, maxX: _overMaxX, minY: _overMinY, maxY: _overMaxY);
  }

  static Offset _shank(Rect half, TeamSide side, Random rng) {
    // Random off-court direction: back (negative x), or wide (y outside ±shankOut)
    final direction = rng.nextInt(3); // 0=back, 1=wide-top, 2=wide-bottom
    final double nx;
    final double ny;
    switch (direction) {
      case 0: // off the back endline
        nx = -(_shankOut + rng.nextDouble() * 0.25);
        ny = 0.10 + rng.nextDouble() * 0.80;
      case 1: // off the top sideline
        nx = 0.10 + rng.nextDouble() * 0.70;
        ny = -(_shankOut + rng.nextDouble() * 0.25);
      default: // off the bottom sideline
        nx = 0.10 + rng.nextDouble() * 0.70;
        ny = 1.0 + _shankOut + rng.nextDouble() * 0.25;
    }
    return _toScreen(half, side, nx, ny);
  }
}
