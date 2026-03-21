import 'dart:math';
import 'dart:ui';

import 'package:volleyball_manager/features/match/engine/outcomes/outcomes.dart';
import 'package:volleyball_manager/features/match/state/match_state.dart';

/// Maps an [AttackDirection] to a floor landing zone in the DEFENDING half.
///
/// Coordinate convention (matches SetLandingCalculator):
///   nx = 0.0 → defending endline   nx = 1.0 → net
///   ny = 0.0 → top sideline        ny = 1.0 → bottom sideline  (absolute)
///
/// y zones are authored for away defending (home attacking).
/// Home OH originates near ny≈0.06–0.18 (top); home OPP near ny≈0.82–0.94 (bottom).
/// When home is defending (away attacking from mirrored positions), y is flipped in _toScreen.
///
/// Zone references in the DEFENDING half:
///   zone 1 (right-back of defending team) ≈ ny 0.08–0.22 (top area)
///   zone 5 (left-back)                    ≈ ny 0.72–0.86 (bottom area)
///   zone 6 (middle-back)                  ≈ ny 0.42–0.58
///   zone 4 (left-front, near net)         ≈ ny 0.74–0.86, nx 0.80–0.90
///   zone 2 (right-front, near net)        ≈ ny 0.12–0.24, nx 0.80–0.90
class AttackLandingCalculator {
  // (minNx, maxNx, minNy, maxNy) — normalized coords in the defending half.
  static const Map<AttackDirection, (double, double, double, double)> _zones = {
    // ── OH (left-side, attacker near ny≈0.06–0.18) ──────────────────────────
    AttackDirection.ohLine:         (0.18, 0.28, 0.08, 0.22), // zone 1 top-back
    AttackDirection.ohCrossShallow: (0.18, 0.28, 0.62, 0.78), // zone 5 bottom-back
    AttackDirection.ohCrossSharp:   (0.80, 0.90, 0.74, 0.86), // zone 4 bottom near-net

    // ── OPP (right-side, attacker near ny≈0.82–0.94) ────────────────────────
    AttackDirection.oppLine:         (0.18, 0.28, 0.78, 0.92), // zone 5 bottom-back
    AttackDirection.oppCrossShallow: (0.18, 0.28, 0.22, 0.38), // zone 1 top-back
    AttackDirection.oppCrossSharp:   (0.80, 0.90, 0.12, 0.24), // zone 2 top near-net

    // ── Middle / pipe / backrow ───────────────────────────────────────────────
    AttackDirection.middleZone1: (0.18, 0.28, 0.10, 0.26), // zone 1 top-back
    AttackDirection.middleZone5: (0.18, 0.28, 0.72, 0.86), // zone 5 bottom-back
    AttackDirection.middleZone6: (0.18, 0.28, 0.42, 0.58), // zone 6 center-back
    // atBlock: ball deflects back — handled separately via blocked()
  };

  /// Landing position for a kill attack landing in [defendingHalf].
  /// Returns null for [AttackDirection.atBlock] (not a floor shot).
  static Offset? kill({
    required AttackDirection direction,
    required TeamSide defendingSide,
    required Rect defendingHalf,
    required Random rng,
  }) {
    if (direction == AttackDirection.atBlock) return null;
    final z = _zones[direction];
    if (z == null) return null;
    return _toScreen(
      defendingHalf,
      defendingSide,
      z.$1 + rng.nextDouble() * (z.$2 - z.$1),
      z.$3 + rng.nextDouble() * (z.$4 - z.$3),
    );
  }

  /// Landing position for a blocked ball deflecting back into [attackingHalf].
  static Offset blocked({
    required TeamSide attackingSide,
    required Rect attackingHalf,
    required Random rng,
  }) {
    // Near the net on the attacking side, random central-ish y.
    final ny = 0.28 + rng.nextDouble() * 0.44;
    return _toScreen(attackingHalf, attackingSide, 0.88, ny);
  }

  static Offset _toScreen(Rect half, TeamSide side, double nx, double ny) {
    final x = side == TeamSide.home
        ? half.left + half.width * nx
        : half.right - half.width * nx;
    // Zones are authored for away defending (home attacking: OH at top, OPP at bottom).
    // When home is defending (away attacking from mirrored positions), flip y.
    final ey = side == TeamSide.home ? 1.0 - ny : ny;
    return Offset(x, half.top + half.height * ey);
  }
}
