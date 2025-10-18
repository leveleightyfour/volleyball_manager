// lib/features/match/engine/positions/tactic_layout_key.dart

import '../../state/tactics_state.dart' show ServeReceiveTacticSpec;

/// Stable ordering for role tags in keys.
const _orderIndex = {'L': 0, 'OH1': 1, 'OH2': 2, 'OPP': 3};

List<String> _order(Iterable<String> roles) {
  return roles.toSet().toList()
    ..sort((a, b) => (_orderIndex[a] ?? 99).compareTo(_orderIndex[b] ?? 99));
}

/// Build the PositionBook tactic suffix for serve–receive.
/// Always returns "pN_<ordered-combo>" where N is 2/3/4.
/// Examples:
///  - p2_L+OH1
///  - p3_L+OH1+OPP
///  - p4_L+OH1+OH2+OPP
String receiveTacticSuffix(ServeReceiveTacticSpec spec) {
  final n = spec.numPassers.clamp(2, 4);
  final ordered = _order(spec.passingRoles);
  // Ensure the length matches n. If UI guarantees this, it's a no-op.
  final combo = (ordered.length >= n) ? ordered.take(n).toList() : ordered;
  return 'p${n}_${combo.join('+')}';
}
