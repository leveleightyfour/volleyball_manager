// lib/features/match/state/tactics_state.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'match_state.dart';

/// We support these tactic role tags for serve–receive.
/// Keep the spelling stable; UI and planners use these.
const srRoleOrder = <String>['L', 'OH1', 'OH2', 'OPP'];

/// Utility: stable combo key like "L+OH1+OPP"
String buildComboKey(Iterable<String> roles) {
  final set = {...roles};
  final ordered = srRoleOrder.where(set.contains).toList();
  return ordered.join('+');
}

/// One rotation’s serve–receive tactic.
@immutable
class ServeReceiveTacticSpec {
  final int numPassers; // 2 | 3 | 4
  final Set<String> passingRoles; // subset of {L, OH1, OH2, OPP}
  const ServeReceiveTacticSpec({
    required this.numPassers,
    required this.passingRoles,
  });

  ServeReceiveTacticSpec copyWith({
    int? numPassers,
    Set<String>? passingRoles,
  }) => ServeReceiveTacticSpec(
    numPassers: numPassers ?? this.numPassers,
    passingRoles: passingRoles ?? this.passingRoles,
  );

  String get comboKey => buildComboKey(passingRoles);

  @override
  String toString() => 'SRSpec(passers=$numPassers, roles=$passingRoles)';
}

/// Entire tactics state keyed by (TeamSide, rotation 1..6).
@immutable
class TacticsState {
  final Map<(TeamSide, int), ServeReceiveTacticSpec> byRot;

  /// Role tag of the player who takes over setting when the regular setter
  /// plays the first ball (digs) and the attack was defended with 2 or 3
  /// blockers. Team-wide (not per-rotation). Default: 'OH1'.
  final Map<TeamSide, String> backupSetterByTeam;

  const TacticsState(
    this.byRot, {
    this.backupSetterByTeam = const {},
  });

  TacticsState copyWith({
    Map<(TeamSide, int), ServeReceiveTacticSpec>? byRot,
    Map<TeamSide, String>? backupSetterByTeam,
  }) => TacticsState(
        byRot ?? this.byRot,
        backupSetterByTeam: backupSetterByTeam ?? this.backupSetterByTeam,
      );
}

/// Allowed combos per #passers.
/// - 2 passers: all pairs from {L, OH1, OH2, OPP}
/// - 3 passers: all 3-tuples
/// - 4 passers: the single 4-tuple
Map<int, List<String>> _buildAllowedCombos() {
  final base = srRoleOrder;
  final asKey = (List<String> roles) => buildComboKey(roles);
  final combos = <int, List<String>>{
    2: [],
    3: [],
    4: [asKey(base)],
  };

  // all pairs (2)
  for (var i = 0; i < base.length; i++) {
    for (var j = i + 1; j < base.length; j++) {
      combos[2]!.add(asKey([base[i], base[j]]));
    }
  }
  // all triples (3)
  for (var i = 0; i < base.length; i++) {
    for (var j = i + 1; j < base.length; j++) {
      for (var k = j + 1; k < base.length; k++) {
        combos[3]!.add(asKey([base[i], base[j], base[k]]));
      }
    }
  }

  // nice deterministic ordering (by role order then lexicographic)
  int score(String role) => srRoleOrder.indexOf(role);
  int keyScore(String key) =>
      key.split('+').fold<int>(0, (acc, r) => acc * 10 + score(r));

  for (final n in [2, 3]) {
    combos[n]!.sort((a, b) => keyScore(a).compareTo(keyScore(b)));
  }

  return combos;
}

final _allowedCombos = _buildAllowedCombos();

/// Riverpod StateNotifier that owns tactics and exposes mutators.
class TacticsNotifier extends StateNotifier<TacticsState> {
  TacticsNotifier() : super(const TacticsState({})) {
    _initDefaults();
  }

  void _initDefaults() {
    // Default: 3 passers (L + OH1 + OH2) for both teams, all 6 rotations.
    final defaults = <(TeamSide, int), ServeReceiveTacticSpec>{};
    final defaultRoles = {'L', 'OH1', 'OH2'};
    for (final side in TeamSide.values) {
      for (var r = 1; r <= 6; r++) {
        defaults[(side, r)] = ServeReceiveTacticSpec(
          numPassers: 3,
          passingRoles: defaultRoles,
        );
      }
    }
    state = TacticsState(
      defaults,
      backupSetterByTeam: {
        TeamSide.home: 'OH1',
        TeamSide.away: 'OH1',
      },
    );
  }

  /// Returns the role tag configured as backup setter for [side].
  String getBackupSetter(TeamSide side) =>
      state.backupSetterByTeam[side] ?? 'OH1';

  /// Configures which role takes over setting when the setter plays the first
  /// ball with 2+ blockers on the previous attack.
  void setBackupSetter(TeamSide side, String roleTag) {
    state = state.copyWith(
      backupSetterByTeam: {...state.backupSetterByTeam, side: roleTag},
    );
  }

  /// Read current spec (always returns something—initializes if absent).
  ServeReceiveTacticSpec getSpec(TeamSide side, int rotation1to6) {
    final key = (side, rotation1to6.clamp(1, 6));
    final existing = state.byRot[key];
    if (existing != null) return existing;

    final spec = const ServeReceiveTacticSpec(
      numPassers: 3,
      passingRoles: {'L', 'OH1', 'OH2'},
    );
    state = state.copyWith(byRot: {...state.byRot, key: spec});
    return spec;
  }

  /// Change #passers; if current combo becomes invalid, snap to first allowed.
  void setNumPassers(TeamSide side, int rotation1to6, int n) {
    final key = (side, rotation1to6.clamp(1, 6));
    final cur = getSpec(side, rotation1to6);
    final allowed = allowedComboKeys(n);
    var nextRoles = cur.passingRoles;

    if (!allowed.contains(cur.comboKey)) {
      // snap to first allowed combo for n
      final fallbackKey = allowed.isNotEmpty ? allowed.first : 'L+OH1';
      nextRoles = fallbackKey.split('+').toSet();
    }

    final next = cur.copyWith(
      numPassers: n.clamp(2, 4),
      passingRoles: nextRoles,
    );
    state = state.copyWith(byRot: {...state.byRot, key: next});
  }

  /// Set exact combo by its key (e.g. "L+OH1+OPP"). Also updates numPassers.
  void setPassingComboKey(TeamSide side, int rotation1to6, String keyStr) {
    final parts = keyStr.split('+').toSet();
    final n = parts.length.clamp(2, 4);
    final allowed = allowedComboKeys(n);
    final canonical = buildComboKey(parts);
    if (!allowed.contains(canonical)) {
      // refuse silently if invalid; you may also assert/throw in dev
      return;
    }
    final key = (side, rotation1to6.clamp(1, 6));
    final cur = getSpec(side, rotation1to6);
    final next = cur.copyWith(numPassers: n, passingRoles: parts);
    state = state.copyWith(byRot: {...state.byRot, key: next});
  }

  /// List of valid combo keys for a given #passers (2/3/4).
  List<String> allowedComboKeys(int numPassers) {
    return List.unmodifiable(
      _allowedCombos[numPassers.clamp(2, 4)] ?? const [],
    );
  }
}

/// Public provider to use across UI/engine:
final tacticsProvider = StateNotifierProvider<TacticsNotifier, TacticsState>((
  ref,
) {
  return TacticsNotifier();
});
