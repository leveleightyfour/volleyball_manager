class RolePoint {
  final double x;
  final double y;
  const RolePoint({required this.x, required this.y});

  factory RolePoint.fromJson(Map<String, dynamic> j) =>
      RolePoint(x: (j['x'] as num).toDouble(), y: (j['y'] as num).toDouble());
}

class AnchorPoint {
  final double x;
  final double y;
  const AnchorPoint({required this.x, required this.y});

  factory AnchorPoint.fromJson(Map<String, dynamic> j) =>
      AnchorPoint(x: (j['x'] as num).toDouble(), y: (j['y'] as num).toDouble());
}

class PositionLayout {
  final Map<String, RolePoint> roles;
  final Map<String, AnchorPoint> anchors;
  const PositionLayout({required this.roles, required this.anchors});

  factory PositionLayout.fromJson(Map<String, dynamic> j) {
    final roles = <String, RolePoint>{};
    final anchors = <String, AnchorPoint>{};
    final rj = (j['roles'] as Map?) ?? const {};
    final aj = (j['anchors'] as Map?) ?? const {};
    rj.forEach((k, v) => roles[k as String] = RolePoint.fromJson(v));
    aj.forEach((k, v) => anchors[k as String] = AnchorPoint.fromJson(v));
    return PositionLayout(roles: roles, anchors: anchors);
  }
}

class PositionBook {
  /// FLAT: { "home|receive|r1|default": PositionLayout, ... }
  final Map<String, PositionLayout> layouts;

  const PositionBook({required this.layouts});

  /// Convenience factory for a usable empty book.
  factory PositionBook.empty() => const PositionBook(layouts: {});

  /// Handy getters so upstream code can do `book.isEmpty`.
  bool get isEmpty => layouts.isEmpty;
  bool get isNotEmpty => layouts.isNotEmpty;

  /// Safe lookup that mirrors your pipe-key JSON.
  PositionLayout? getLayout({
    required String team, // 'home' | 'away'
    required String phase, // 'serve' | 'receive' | ...
    required int rotationIndex1to6, // 1..6
    String tactic = 'default',
  }) {
    return layouts[pipeKey(
      team: team,
      phase: phase,
      rotationIndex1to6: rotationIndex1to6,
      tactic: tactic,
    )];
  }
}

/// Build a pipe key that matches your JSON.
String pipeKey({
  required String team, // 'home' | 'away'
  required String phase, // 'serve' | 'receive' | ...
  required int rotationIndex1to6, // 1..6
  String tactic = 'default',
}) => '$team|$phase|r$rotationIndex1to6|$tactic';
