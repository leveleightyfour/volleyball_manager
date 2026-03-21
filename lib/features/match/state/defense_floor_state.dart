// lib/features/match/state/defense_floor_state.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'match_state.dart';
import '../engine/outcomes/outcomes.dart';

/// Normalised (nx from own endline, ny absolute) screen position for one role.
typedef FloorMap = Map<String, (double, double)>;

// ---------------------------------------------------------------------------
// Default floor coverage table
//
// These mirror the former static LayoutManager._floorDefensePositions table
// and serve as the seed for DefenseFloorNotifier._initDefaults().
// ---------------------------------------------------------------------------

/// Returns the default floor-defence positions for [set] at [blockerCount]
/// for [side]. Positions are expressed as (nx, ny) absolute screen coordinates
/// consistent with [floorZonePosition].
///
/// L always covers zone 5 (left-back cross-court).
/// OH1/OH2 rotate between zones 1 and 6 based on attack direction.
/// OPP covers zone 6 (middle) when free.
///
/// Exposed as a top-level function so the notifier and tests can seed from it
/// without importing LayoutManager (avoiding circular imports).
FloorMap defaultFloorFor(SetOutcome set, int blockerCount, TeamSide side) {
  (double, double) z(int zone) => floorZonePosition(side, zone);

  return switch (set) {
    // Left-side attack — blockers: MB1(1), MB1+OH2(2), MB1+OH2+OPP(3)
    SetOutcome.leftSideHigh || SetOutcome.leftSideTempo => switch (blockerCount) {
        3 => {'L': z(5), 'OH1': z(1)},
        2 => {'L': z(5), 'OH1': z(1), 'OPP': z(6)},
        _ => {'L': z(5), 'OH1': z(1), 'OH2': z(6)},
      },
    // Right-side attack — blockers: MB1(1), MB1+OH1(2), MB1+OH1+OH2(3)
    SetOutcome.rightSideHigh || SetOutcome.rightSideTempo => switch (blockerCount) {
        3 => {'L': z(5), 'OPP': z(6)},
        2 => {'L': z(5), 'OH2': z(1), 'OPP': z(6)},
        _ => {'L': z(5), 'OH1': z(6), 'OH2': z(1)},
      },
    // Middle / pipe — blockers: MB1(1), MB1+MB2(2), MB1+MB2+OPP(3)
    SetOutcome.middle || SetOutcome.pipe => {
        'L':   z(5),
        'OH1': z(6),
        'OH2': z(1),
      },
    // Back-row — blockers: MB1(1), MB1+OPP(2), MB1+OPP+OH2(3)
    SetOutcome.backrow => {
        'L':   z(5),
        'OH1': z(6),
        'OH2': z(1),
      },
    // Tip — defenders spread across back court
    SetOutcome.tip => {
        'L':   z(5),
        'OH1': z(6),
        'OH2': z(1),
      },
  };
}

// ---------------------------------------------------------------------------
// Floor zone helpers (consistent with positions.json values)
// ---------------------------------------------------------------------------

/// Normalised positions for the three back-court defense zones per side.
/// These values match the authored positions.json defense entries.
const _homeFloorZones = <int, (double, double)>{
  1: (0.22, 0.88), // right-back (near bottom/right sideline)
  5: (0.22, 0.12), // left-back  (near top/left sideline)
  6: (0.28, 0.50), // middle-back
};

const _awayFloorZones = <int, (double, double)>{
  1: (0.22, 0.12), // right-back (away — y mirrored: near top/left sideline)
  5: (0.22, 0.88), // left-back  (near bottom/right sideline)
  6: (0.28, 0.50), // middle-back (symmetric)
};

/// (nx, ny) for the given back-court [zone] (1, 5, or 6) on [side].
(double, double) floorZonePosition(TeamSide side, int zone) =>
    (side == TeamSide.home ? _homeFloorZones : _awayFloorZones)[zone] ??
    (0.25, 0.50);

/// Reverse-map a position to the nearest back-court zone (1, 5, or 6).
int nearestFloorZone(TeamSide side, (double, double) pos) {
  final zones = side == TeamSide.home ? _homeFloorZones : _awayFloorZones;
  var best = 6;
  var bestDist = double.infinity;
  for (final e in zones.entries) {
    final dx = e.value.$1 - pos.$1;
    final dy = e.value.$2 - pos.$2;
    final d = dx * dx + dy * dy;
    if (d < bestDist) {
      bestDist = d;
      best = e.key;
    }
  }
  return best;
}

// ---------------------------------------------------------------------------
// DefenseFloorSpec — immutable spec for one (side, rotation) context
// ---------------------------------------------------------------------------

/// Tactical floor-defence positions for a single (TeamSide, rotation) context.
///
/// Internally keyed by (setOutcomeName, blockerCount) → FloorMap.
/// Use [forAttack] to retrieve the positions, and [withOverride] to produce
/// an updated copy with new positions for a specific attack scenario.
@immutable
class DefenseFloorSpec {
  const DefenseFloorSpec(this._data);

  final Map<(String, int), FloorMap> _data;

  /// Floor positions for [set] when [blockerCount] players are at the net.
  FloorMap forAttack(SetOutcome set, int blockerCount) =>
      _data[(set.name, blockerCount)] ?? const {};

  /// Returns a new [DefenseFloorSpec] with [positions] substituted for the
  /// given (set, blockerCount) key.
  DefenseFloorSpec withOverride({
    required SetOutcome set,
    required int blockerCount,
    required FloorMap positions,
  }) =>
      DefenseFloorSpec({..._data, (set.name, blockerCount): positions});
}

DefenseFloorSpec _buildDefaultSpec(TeamSide side) {
  final data = <(String, int), FloorMap>{};
  for (final s in SetOutcome.values) {
    for (var c = 1; c <= 3; c++) {
      data[(s.name, c)] = defaultFloorFor(s, c, side);
    }
  }
  return DefenseFloorSpec(data);
}

// ---------------------------------------------------------------------------
// Notifier + provider
// ---------------------------------------------------------------------------

/// Riverpod notifier that owns floor-defence positioning tactics per
/// (TeamSide, rotation 1–6). Defaults are seeded from [defaultFloorFor].
class DefenseFloorNotifier
    extends StateNotifier<Map<(TeamSide, int), DefenseFloorSpec>> {
  DefenseFloorNotifier() : super(const {}) {
    _initDefaults();
  }

  void _initDefaults() {
    final defaults = <(TeamSide, int), DefenseFloorSpec>{
      for (final side in TeamSide.values)
        for (var r = 1; r <= 6; r++) (side, r): _buildDefaultSpec(side),
    };
    state = defaults;
  }

  /// Retrieve the spec for [side] at [rotation] (1–6). Falls back to defaults.
  DefenseFloorSpec getSpec(TeamSide side, int rotation) =>
      state[(side, rotation.clamp(1, 6))] ?? _buildDefaultSpec(side);

  /// Convenience method: floor positions for [side]/[rotation] given the
  /// current [set] type and [blockerCount].
  FloorMap getFloor(
    TeamSide side,
    int rotation,
    SetOutcome set,
    int blockerCount,
  ) =>
      getSpec(side, rotation).forAttack(set, blockerCount);

  /// Override floor positions for a specific (side, rotation, set, blockerCount).
  void setFloorPositions({
    required TeamSide side,
    required int rotation,
    required SetOutcome set,
    required int blockerCount,
    required FloorMap positions,
  }) {
    final key = (side, rotation.clamp(1, 6));
    final updated = getSpec(side, rotation)
        .withOverride(set: set, blockerCount: blockerCount, positions: positions);
    state = {...state, key: updated};
  }

  /// Convenience: assign [role] to a named back-court [zone] (1, 5, or 6).
  void setRoleZone({
    required TeamSide side,
    required int rotation,
    required SetOutcome set,
    required int blockerCount,
    required String role,
    required int zone,
  }) {
    final pos = floorZonePosition(side, zone);
    final current = getFloor(side, rotation, set, blockerCount);
    setFloorPositions(
      side: side,
      rotation: rotation,
      set: set,
      blockerCount: blockerCount,
      positions: {...current, role: pos},
    );
  }

  /// Reset a single (side, rotation) to engine defaults.
  void resetToDefault(TeamSide side, int rotation) {
    final key = (side, rotation.clamp(1, 6));
    state = {...state, key: _buildDefaultSpec(side)};
  }
}

/// Provider for tactical floor-defence positions (per side × rotation).
///
/// Read-only access: `ref.watch(defenseFloorProvider)`
/// Mutation: `ref.read(defenseFloorProvider.notifier).setFloorPositions(...)`
final defenseFloorProvider = StateNotifierProvider<DefenseFloorNotifier,
    Map<(TeamSide, int), DefenseFloorSpec>>(
  (_) => DefenseFloorNotifier(),
);
