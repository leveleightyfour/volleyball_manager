import 'dart:convert';
import 'package:volleyball_manager/core/db/database.dart';
import 'package:volleyball_manager/features/player/data/dto/player_dto.dart';

/// Calculates derived skill values from player attributes using configurable formulas
class SkillCalculator {
  SkillCalculator(this.formulas);

  final Map<String, SkillFormula> formulas;

  /// Calculate a specific skill value for a player
  double calculateSkill(String skillKey, PlayerDto player) {
    final formula = formulas[skillKey];
    if (formula == null || !formula.isActive) {
      throw Exception('Skill formula not found or inactive: $skillKey');
    }

    final weights = _parseFormula(formula.formula);
    return _applyFormula(weights, player);
  }

  /// Get all calculated skills for a player
  Map<String, double> calculateAllSkills(PlayerDto player) {
    final results = <String, double>{};

    for (final entry in formulas.entries) {
      if (entry.value.isActive) {
        try {
          results[entry.key] = calculateSkill(entry.key, player);
        } catch (e) {
          // Skip skills that fail to calculate
          // In production, consider using a proper logging framework
          continue;
        }
      }
    }

    return results;
  }

  /// Parse JSON formula into attribute weights
  Map<String, double> _parseFormula(String formulaJson) {
    final Map<String, dynamic> json = jsonDecode(formulaJson);
    return json.map((key, value) => MapEntry(key, (value as num).toDouble()));
  }

  /// Apply weighted formula to player attributes
  double _applyFormula(Map<String, double> weights, PlayerDto player) {
    double total = 0.0;

    for (final entry in weights.entries) {
      final attributeName = entry.key;
      final weight = entry.value;
      final attributeValue = _getAttributeValue(player, attributeName);
      total += weight * attributeValue;
    }

    return total;
  }

  /// Get player attribute value by name (camelCase)
  int _getAttributeValue(PlayerDto player, String attributeName) {
    switch (attributeName) {
      // Serving
      case 'wristSnap':
        return player.wristSnap;
      case 'power':
        return player.power;
      case 'accuracy':
        return player.accuracy;
      case 'aggression':
        return player.aggression;

      // Setting
      case 'strength':
        return player.strength;
      case 'positioning':
        return player.positioning;
      case 'predictability':
        return player.predictability;
      case 'creativity':
        return player.creativity;

      // Blocking
      case 'penetration':
        return player.penetration;
      case 'height':
        return player.height;
      case 'form':
        return player.form;
      case 'anticipation':
        return player.anticipation;

      // Reception
      case 'footwork':
        return player.footwork;
      case 'platform':
        return player.platform;
      case 'stability':
        return player.stability;
      case 'touch':
        return player.touch;

      // Attack
      case 'vision':
        return player.vision;
      case 'timing':
        return player.timing;
      case 'versatility':
        return player.versatility;

      // Defense
      case 'reaction':
        return player.reaction;
      case 'reading':
        return player.reading;
      case 'intention':
        return player.intention;
      case 'control':
        return player.control;

      default:
        throw Exception('Unknown attribute: $attributeName');
    }
  }
}

/// Calculates match outcome probabilities based on skill differentials
class OutcomeCalculator {
  OutcomeCalculator(this.curves);

  final List<OutcomeCurve> curves;

  /// Get outcome probabilities for a given skill matchup and differential
  Map<String, double> getOutcomeProbabilities({
    required String matchupKey,
    required double differential,
  }) {
    // Filter curves for this matchup
    final matchupCurves = curves
        .where((c) => c.matchupKey == matchupKey && c.isActive)
        .toList()
      ..sort((a, b) => a.differential.compareTo(b.differential));

    if (matchupCurves.isEmpty) {
      throw Exception('No outcome curves found for matchup: $matchupKey');
    }

    // Find the two closest differential thresholds
    OutcomeCurve? lower;
    OutcomeCurve? upper;

    for (final curve in matchupCurves) {
      if (curve.differential <= differential) {
        lower = curve;
      }
      if (curve.differential >= differential && upper == null) {
        upper = curve;
        break;
      }
    }

    // If exact match, return that curve
    if (lower != null && lower.differential == differential) {
      return _parseProbabilities(lower.probabilities);
    }
    if (upper != null && upper.differential == differential) {
      return _parseProbabilities(upper.probabilities);
    }

    // Interpolate between two curves
    if (lower != null && upper != null) {
      return _interpolateProbabilities(lower, upper, differential);
    }

    // Use closest curve
    final closest = lower ?? upper!;
    return _parseProbabilities(closest.probabilities);
  }

  /// Parse JSON probabilities
  Map<String, double> _parseProbabilities(String probabilitiesJson) {
    final Map<String, dynamic> json = jsonDecode(probabilitiesJson);
    return json.map((key, value) => MapEntry(key, (value as num).toDouble()));
  }

  /// Interpolate between two probability curves
  Map<String, double> _interpolateProbabilities(
    OutcomeCurve lower,
    OutcomeCurve upper,
    double differential,
  ) {
    final lowerProbs = _parseProbabilities(lower.probabilities);
    final upperProbs = _parseProbabilities(upper.probabilities);

    // Linear interpolation factor
    final range = upper.differential - lower.differential;
    final t = (differential - lower.differential) / range;

    // Interpolate each probability
    final result = <String, double>{};
    for (final key in lowerProbs.keys) {
      final lowerValue = lowerProbs[key] ?? 0.0;
      final upperValue = upperProbs[key] ?? 0.0;
      result[key] = lowerValue + (upperValue - lowerValue) * t;
    }

    return result;
  }
}
