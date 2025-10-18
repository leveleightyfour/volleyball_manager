import '../../state/match_state.dart';

/// Which roles are passing isn’t needed yet for the mock distribution,
/// but we store it so your future engine can use it.
class RotationTacticsSpec {
  RotationTacticsSpec({required this.numPassers, required this.passingRoles});
  int numPassers; // 2, 3, or 4
  Set<String> passingRoles; // e.g. {'L','OH1','OH2'}
}

class TacticsRegistry {
  final Map<TeamSide, Map<int, RotationTacticsSpec>> _bySide = {
    TeamSide.home: {
      for (var r = 1; r <= 6; r++)
        r: RotationTacticsSpec(
          numPassers: 3,
          passingRoles: {'L', 'OH1', 'OH2'},
        ),
    },
    TeamSide.away: {
      for (var r = 1; r <= 6; r++)
        r: RotationTacticsSpec(
          numPassers: 3,
          passingRoles: {'L', 'OH1', 'OH2'},
        ),
    },
  };

  RotationTacticsSpec get(TeamSide side, int rotationIndex1to6) =>
      _bySide[side]![rotationIndex1to6]!;

  void set(TeamSide side, int rotationIndex1to6, RotationTacticsSpec spec) {
    _bySide[side]![rotationIndex1to6] = spec;
  }

  /// Convenience for debug UI
  void setNumPassers(TeamSide side, int rotationIndex1to6, int n) {
    final cur = get(side, rotationIndex1to6);
    set(
      side,
      rotationIndex1to6,
      RotationTacticsSpec(numPassers: n, passingRoles: cur.passingRoles),
    );
  }
}
