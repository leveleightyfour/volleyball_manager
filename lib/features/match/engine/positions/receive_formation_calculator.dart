import 'dart:ui';
import 'package:volleyball_manager/features/match/state/match_state.dart';

/// Computes receive formation positions directly from rotation zone rules.
///
/// This replaces static positions.json role entries for receive formations
/// with correctly computed positions that respect:
///
/// - **Libero substitution**: L always replaces the back-row MB.
///   In R5 (both MBs front row) L has no one to replace → omitted (on bench).
///
/// - **Non-passer positioning** (user rule):
///   - Back-row non-passer → as far back as possible: x ≈ 0.03
///   - Front-row non-passer → as far forward as possible: x ≈ 0.90
///
/// - **Passer positioning**: pulled back to receive (x ≈ 0.14), spread at
///   their rotation zone's natural y-coordinate.
///
/// Zones (volleyball, relative to each team's facing direction):
///   1 = right-back (RB)   2 = right-front (RF)   3 = middle-front (MF)
///   4 = left-front (LF)   5 = left-back (LB)      6 = middle-back (MB)
class ReceiveFormationCalculator {
  // ---------------------------------------------------------------------------
  // Zone assignments per rotation
  // ---------------------------------------------------------------------------

  /// Which zone each role occupies for home team in each rotation.
  ///
  /// Rotation sequence (5-1 system, serve order R1→R6):
  ///   R1 S serves   – L replaces MB2 in z6
  ///   R2 OH1 serves – L replaces MB2 in z5
  ///   R3 MB1 serves – L replaces MB1 in z1 (receive only; MB1 serves when team serves)
  ///   R4 OPP serves – L replaces MB1 in z6
  ///   R5 OH2 serves – L replaces MB1 in z5
  ///   R6 MB2 serves – L replaces MB2 in z1 (receive only; MB2 serves when team serves)
  ///
  /// Invariants: OH1/OH2 always in opposite rows; MB1/MB2 always in opposite rows.
  static const Map<int, Map<String, int>> _rotationZones = {
    1: {'S': 1, 'OH1': 2, 'MB1': 3, 'OPP': 4, 'OH2': 5, 'L': 6},   // L replaces MB2
    2: {'OH1': 1, 'MB1': 2, 'OPP': 3, 'OH2': 4, 'L':  5, 'S': 6},  // L replaces MB2
    3: {'L':  1, 'OPP': 2, 'OH2': 3, 'MB2': 4, 'S':  5, 'OH1': 6}, // L replaces MB1
    4: {'OPP': 1, 'OH2': 2, 'MB2': 3, 'S':  4, 'OH1': 5, 'L': 6},  // L replaces MB1
    5: {'OH2': 1, 'MB2': 2, 'S':  3, 'OH1': 4, 'L':  5, 'OPP': 6}, // L replaces MB1
    6: {'L':  1, 'S':  2, 'OH1': 3, 'MB1': 4, 'OPP': 5, 'OH2': 6}, // L replaces MB2
  };

  // ---------------------------------------------------------------------------
  // Normalised y for each zone (0 = top screen, 1 = bottom screen)
  // ---------------------------------------------------------------------------

  /// Home team: right side = bottom screen = high y.
  /// Each zone has a unique y to prevent player overlaps.
  /// Right col (1=RB, 2=RF): 0.85/0.71 — Left col (5=LB, 4=LF): 0.29/0.17
  /// Center col (6=MB, 3=MF): 0.56/0.44
  static const Map<int, double> _homeZoneY = {
    1: 0.85, 2: 0.71, 3: 0.44, 4: 0.17, 5: 0.29, 6: 0.56,
  };

  /// Away team: mirror of home (1.0 − homeY).
  static const Map<int, double> _awayZoneY = {
    1: 0.15, 2: 0.29, 3: 0.56, 4: 0.83, 5: 0.71, 6: 0.44,
  };

  // ---------------------------------------------------------------------------
  // Normalised x (distance from own endline towards net)
  // ---------------------------------------------------------------------------

  /// Back-row non-passer: near own endline (zones 1, 5, 6).
  static const double _backNonPasserX = 0.03;

  /// Front-row non-passer: near net (zones 2, 3, 4).
  static const double _frontNonPasserX = 0.90;

  static bool _isFrontRow(int zone) => zone == 2 || zone == 3 || zone == 4;

  /// x-depth for a passer at position [index] in an arc of [n] passers.
  ///
  /// - 2 passers: flat line, both at the same depth (0.14).
  /// - 3 passers: outside two slightly forward (0.18), middle slightly deeper (0.08).
  /// - 4 passers: outside two slightly forward (0.18), inner two slightly deeper (0.08).
  static double _passerArcX(int index, int n) {
    if (n <= 2) return 0.14;
    final isOutside = index == 0 || index == n - 1;
    return isOutside ? 0.18 : 0.08;
  }

  // ---------------------------------------------------------------------------
  // Bench (off-court) MB per rotation
  // ---------------------------------------------------------------------------

  /// Which MB is replaced by the Libero (and therefore on the bench) in each
  /// rotation. The bench player is placed off-court at y=1.15 so they remain
  /// visible but clearly outside the court boundary.
  static const Map<int, String> _benchRole = {
    1: 'MB2', // L replaces MB2 in z6
    2: 'MB2', // L replaces MB2 in z5
    3: 'MB1', // L replaces MB1 in z1
    4: 'MB1', // L replaces MB1 in z6
    5: 'MB1', // L replaces MB1 in z5
    6: 'MB2', // L replaces MB2 in z1
  };

  /// Returns which MB role is on the bench for a given rotation (1–6).
  static String? benchRoleFor(int rotationIndex1to6) =>
      _benchRole[rotationIndex1to6.clamp(1, 6)];

  /// Returns which role is on the bench when the team is **serving**.
  ///
  /// In R3 (MB1 serves) and R6 (MB2 serves) the Libero goes off and MB
  /// comes on court. All other rotations follow the receive bench rule.
  static String? servingBenchRoleFor(int rotationIndex1to6) =>
      switch (rotationIndex1to6.clamp(1, 6)) {
        3 || 6 => 'L',
        final r => _benchRole[r],
      };

  /// Returns a map of role → zone number for back-row zones (1, 5, 6).
  /// Used to assign floor-defence positions based on who is actually in each
  /// back-row zone for this rotation.
  static Map<String, int> backRowZoneMapFor(int rotationIndex1to6) {
    final zones = _rotationZones[rotationIndex1to6.clamp(1, 6)] ?? const {};
    return {
      for (final e in zones.entries)
        if (!_isFrontRow(e.value)) e.key: e.value,
    };
  }

  /// Returns the set of roles occupying the front row (zones 2, 3, 4)
  /// for a given rotation. Used to identify blocker positions during serve.
  static Set<String> frontRowRolesFor(int rotationIndex1to6) {
    final zones = _rotationZones[rotationIndex1to6.clamp(1, 6)] ?? const {};
    return {
      for (final e in zones.entries)
        if (_isFrontRow(e.value)) e.key,
    };
  }

  /// Returns a map of role → zone number for front-row roles only (zones 2, 3, 4).
  /// Used by the block builder to sort wing blockers by proximity to the attack.
  static Map<String, int> frontRowZoneMapFor(int rotationIndex1to6) {
    final zones = _rotationZones[rotationIndex1to6.clamp(1, 6)] ?? const {};
    return {
      for (final e in zones.entries)
        if (_isFrontRow(e.value)) e.key: e.value,
    };
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Returns screen-coordinate [Offset]s for every player in this rotation's
  /// receive formation, including the replaced MB at an off-court bench position.
  ///
  /// Parameters:
  ///   [side]             — TeamSide.home or TeamSide.away
  ///   [rotationIndex1to6]— Current rotation (1–6)
  ///   [passingRoles]     — e.g. {'L', 'OH1', 'OH2'} or {'L','OH1','OH2','OPP'}
  ///   [courtHalf]        — Pre-computed half-court Rect for this side
  static Map<String, Offset> compute({
    required TeamSide side,
    required int rotationIndex1to6,
    required Set<String> passingRoles,
    required Rect courtHalf,
  }) {
    final zoneMap =
        _rotationZones[rotationIndex1to6.clamp(1, 6)] ?? const {};
    final zoneYMap = side == TeamSide.home ? _homeZoneY : _awayZoneY;

    final result = <String, Offset>{};

    // --- Non-passers: zone-based y, front/back x ---
    for (final entry in zoneMap.entries) {
      final role = entry.key;
      final zone = entry.value;
      if (passingRoles.contains(role)) continue;

      final normX = _isFrontRow(zone) ? _frontNonPasserX : _backNonPasserX;
      final normY = zoneYMap[zone] ?? 0.50;

      final screenX = side == TeamSide.home
          ? courtHalf.left + courtHalf.width * normX
          : courtHalf.right - courtHalf.width * normX;
      final screenY = courtHalf.top + courtHalf.height * normY;

      result[role] = Offset(screenX, screenY);
    }

    // --- Passers: equal sections across court width, arc depth ---
    // Sort by zone y (ascending) so passers are ordered left-to-right on screen.
    final activePassers = zoneMap.keys
        .where(passingRoles.contains)
        .toList()
      ..sort((a, b) {
        final ay = zoneYMap[zoneMap[a]!] ?? 0.5;
        final by = zoneYMap[zoneMap[b]!] ?? 0.5;
        return ay.compareTo(by);
      });

    final n = activePassers.length;
    for (var i = 0; i < n; i++) {
      final role = activePassers[i];
      final normY = (i + 0.5) / n; // equal section centres
      final normX = _passerArcX(i, n);

      final screenX = side == TeamSide.home
          ? courtHalf.left + courtHalf.width * normX
          : courtHalf.right - courtHalf.width * normX;
      final screenY = courtHalf.top + courtHalf.height * normY;

      result[role] = Offset(screenX, screenY);
    }

    // Place the replaced MB at an off-court bench position (below the court).
    final benchRole = _benchRole[rotationIndex1to6.clamp(1, 6)];
    if (benchRole != null) {
      const benchNormX = 0.10;
      const benchNormY = 1.15;
      final benchX = side == TeamSide.home
          ? courtHalf.left + courtHalf.width * benchNormX
          : courtHalf.right - courtHalf.width * benchNormX;
      final benchY = courtHalf.top + courtHalf.height * benchNormY;
      result[benchRole] = Offset(benchX, benchY);
    }

    return result;
  }
}
