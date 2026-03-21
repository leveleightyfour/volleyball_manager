// lib/features/match/engine/positions/attack_formation_config.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Loaded representation of assets/config/attack_formations.json.
///
/// All coordinates are normalised within the attacking team's half-court:
///   x = 0.0 → own endline   x = 1.0 → net
///   y = 0.0 → top sideline  y = 1.0 → bottom sideline
///
/// The y axis is absolute (same physical sidelines for both teams).
class AttackFormationConfig {
  const AttackFormationConfig({
    required this.approach,
    required this.cover,
  });

  /// Pre-set approach positions keyed by role tag.
  /// Roles not listed (S, L, OH2, MB2) do not approach.
  final Map<String, (double, double)> approach;

  /// Cover positions per [SetOutcome.name], each entry maps role tag → (nx, ny).
  /// The attacker's own tag is omitted — they move to the attack contact point.
  final Map<String, Map<String, (double, double)>> cover;

  // ── Loading ──────────────────────────────────────────────────────────────

  static AttackFormationConfig? _cache;

  static Future<AttackFormationConfig> load({
    String assetPath = 'assets/config/attack_formations.json',
  }) async {
    if (_cache != null) return _cache!;
    try {
      final raw = await rootBundle.loadString(assetPath);
      final json = jsonDecode(raw) as Map<String, dynamic>;
      _cache = AttackFormationConfig._fromJson(json);
    } catch (_) {
      _cache = _defaults();
    }
    return _cache!;
  }

  /// Clears cache so tests or hot-reload can force a re-load.
  static void clearCache() => _cache = null;

  // ── JSON parsing ─────────────────────────────────────────────────────────

  factory AttackFormationConfig._fromJson(Map<String, dynamic> json) {
    (double, double) parseXY(dynamic v) {
      final m = v as Map<String, dynamic>;
      return ((m['x'] as num).toDouble(), (m['y'] as num).toDouble());
    }

    final approach = <String, (double, double)>{};
    final rawApproach = json['approach'] as Map<String, dynamic>? ?? {};
    for (final e in rawApproach.entries) {
      approach[e.key] = parseXY(e.value);
    }

    final cover = <String, Map<String, (double, double)>>{};
    final rawCover = json['cover'] as Map<String, dynamic>? ?? {};
    for (final outcome in rawCover.entries) {
      final positions = <String, (double, double)>{};
      final rawPositions = outcome.value as Map<String, dynamic>;
      for (final role in rawPositions.entries) {
        positions[role.key] = parseXY(role.value);
      }
      cover[outcome.key] = positions;
    }

    return AttackFormationConfig(approach: approach, cover: cover);
  }

  // ── Compile-time fallback (mirrors the JSON) ──────────────────────────────

  static AttackFormationConfig _defaults() => const AttackFormationConfig(
        approach: {
          'OH1': (0.73, 0.10),
          'OH2': (0.73, 0.10), // fallback when OH2 is the front-row OH
          'OPP': (0.73, 0.90),
          'MB1': (0.78, 0.50),
          'MB2': (0.78, 0.50), // fallback when MB2 is the front-row MB
        },
        cover: {
          'leftSideHigh': {
            'S': (0.78, 0.35), 'MB1': (0.82, 0.52), 'OPP': (0.52, 0.85),
            'OH2': (0.48, 0.15), 'L': (0.32, 0.22), 'MB2': (0.25, 0.50),
          },
          'leftSideTempo': {
            'S': (0.78, 0.35), 'MB1': (0.82, 0.52), 'OPP': (0.52, 0.85),
            'OH2': (0.48, 0.15), 'L': (0.32, 0.22), 'MB2': (0.25, 0.50),
          },
          'rightSideHigh': {
            'S': (0.78, 0.70), 'MB1': (0.82, 0.48), 'OH1': (0.52, 0.12),
            'OH2': (0.48, 0.82), 'L': (0.32, 0.22), 'MB2': (0.25, 0.50),
          },
          'rightSideTempo': {
            'S': (0.78, 0.70), 'MB1': (0.82, 0.48), 'OH1': (0.52, 0.12),
            'OH2': (0.48, 0.82), 'L': (0.32, 0.22), 'MB2': (0.25, 0.50),
          },
          'middle': {
            'S': (0.80, 0.42), 'OH1': (0.82, 0.12), 'OPP': (0.80, 0.88),
            'OH2': (0.45, 0.18), 'L': (0.32, 0.22), 'MB2': (0.25, 0.50),
          },
          'backrow': {
            'S': (0.85, 0.45), 'OH1': (0.82, 0.12), 'MB1': (0.82, 0.50),
            'OH2': (0.45, 0.18), 'L': (0.32, 0.22), 'MB2': (0.25, 0.50),
          },
          'pipe': {
            'S': (0.85, 0.45), 'OH1': (0.82, 0.12), 'MB1': (0.82, 0.50),
            'OH2': (0.45, 0.18), 'L': (0.32, 0.22), 'MB2': (0.25, 0.50),
          },
          'tip': {
            'OH1': (0.75, 0.12), 'OPP': (0.75, 0.88), 'MB1': (0.78, 0.50),
            'OH2': (0.45, 0.18), 'L': (0.32, 0.22), 'MB2': (0.25, 0.50),
          },
        },
      );
}
