// lib/features/match/engine/sim/outcome_weights.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Non-curve configurable weights loaded from assets/config/outcome_weights.json.
///
/// Curve-based comparison probabilities (attack_vs_block, attack_vs_defense,
/// attack_vs_block_touch, serve_vs_reception) live in outcome_curves.json and
/// are accessed via [OutcomeCalculator]. This class covers the remaining scalar
/// and threshold values that don't fit a differential curve model.
class OutcomeWeights {
  const OutcomeWeights({
    required this.tripleBlockBonus,
    required this.transitionSingleOptionAbove,
    required this.transitionAverageAbove,
    required this.transitionPerfectBelow,
    required this.mbBaseProb,
    required this.mbSkillFactor,
    required this.wingBaseProb,
    required this.wingSkillFactor,
  });

  /// Multiplier applied to block aggregate when three blockers contest.
  final double tripleBlockBonus;

  /// Transition outcome thresholds (atkVsDefDiff).
  final double transitionSingleOptionAbove;
  final double transitionAverageAbove;
  final double transitionPerfectBelow;

  /// Blocker-read upgrade: perfect → average pass (MB read vs setter tempo).
  final double mbBaseProb;
  final double mbSkillFactor;

  /// Blocker-read upgrade: average → singleOption (wing blocker vs attacker).
  final double wingBaseProb;
  final double wingSkillFactor;

  // ── Loading ──────────────────────────────────────────────────────────────

  static OutcomeWeights? _cache;

  static Future<OutcomeWeights> load({
    String assetPath = 'assets/config/outcome_weights.json',
  }) async {
    if (_cache != null) return _cache!;
    try {
      final raw = await rootBundle.loadString(assetPath);
      final json = jsonDecode(raw) as Map<String, dynamic>;
      _cache = OutcomeWeights._fromJson(json);
    } catch (_) {
      _cache = _defaults();
    }
    return _cache!;
  }

  static void clearCache() => _cache = null;

  factory OutcomeWeights._fromJson(Map<String, dynamic> json) {
    double d(String key, double fallback) =>
        (json[key] as num?)?.toDouble() ?? fallback;
    double nested(String section, String key, double fallback) =>
        ((json[section] as Map<String, dynamic>?)?[key] as num?)?.toDouble() ??
        fallback;

    return OutcomeWeights(
      tripleBlockBonus: d('triple_block_bonus', 1.20),
      transitionSingleOptionAbove:
          nested('transition', 'single_option_above', 4.0),
      transitionAverageAbove: nested('transition', 'average_above', 1.0),
      transitionPerfectBelow: nested('transition', 'perfect_below', -2.0),
      mbBaseProb: nested('blocker_read', 'mb_base_prob', 0.30),
      mbSkillFactor: nested('blocker_read', 'mb_skill_factor', 0.03),
      wingBaseProb: nested('blocker_read', 'wing_base_prob', 0.25),
      wingSkillFactor: nested('blocker_read', 'wing_skill_factor', 0.02),
    );
  }

  static OutcomeWeights _defaults() => const OutcomeWeights(
        tripleBlockBonus: 1.20,
        transitionSingleOptionAbove: 4.0,
        transitionAverageAbove: 1.0,
        transitionPerfectBelow: -2.0,
        mbBaseProb: 0.30,
        mbSkillFactor: 0.03,
        wingBaseProb: 0.25,
        wingSkillFactor: 0.02,
      );
}
