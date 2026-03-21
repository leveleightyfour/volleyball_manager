import 'package:volleyball_manager/features/player/domain/skill_calculator.dart';
import 'package:volleyball_manager/features/player/data/dto/player_dto.dart';

/// Represents the weight configuration for a single position
class PositionWeightConfig {
  final String positionName;
  final String description;
  final Map<String, double> skillWeights;

  PositionWeightConfig({
    required this.positionName,
    required this.description,
    required this.skillWeights,
  });

  factory PositionWeightConfig.fromJson(Map<String, dynamic> json) {
    final weightsJson = json['skillWeights'] as Map<String, dynamic>;
    final weights = weightsJson.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    return PositionWeightConfig(
      positionName: json['positionName'] as String,
      description: json['description'] as String,
      skillWeights: weights,
    );
  }
}

/// Calculates position suitability ratings for players
///
/// This calculator uses the player's skill values (from SkillCalculator)
/// and position-specific weights to determine how well-suited a player
/// is for each position. Ratings are on a 1-20 scale matching player attributes.
class PositionRatingCalculator {
  final SkillCalculator skillCalculator;
  final Map<String, PositionWeightConfig> positionConfigs;

  PositionRatingCalculator({
    required this.skillCalculator,
    required this.positionConfigs,
  });

  /// Factory to load from JSON configuration
  factory PositionRatingCalculator.fromJson(
    Map<String, dynamic> positionWeightsJson,
    SkillCalculator skillCalculator,
  ) {
    final configs = <String, PositionWeightConfig>{};

    for (final entry in positionWeightsJson.entries) {
      configs[entry.key] = PositionWeightConfig.fromJson(
        entry.value as Map<String, dynamic>,
      );
    }

    return PositionRatingCalculator(
      skillCalculator: skillCalculator,
      positionConfigs: configs,
    );
  }

  /// Calculate rating for a specific position (1-20 scale)
  ///
  /// Formula: Sum of (skill_value * weight) for all skills in the position
  /// Since skills are calculated from 1-20 attributes and weights sum to 1.0,
  /// the result naturally falls in the 1-20 range.
  double calculatePositionRating(String position, PlayerDto player) {
    final config = positionConfigs[position];
    if (config == null) {
      throw Exception('Unknown position: $position');
    }

    // Calculate all skills for the player
    final playerSkills = skillCalculator.calculateAllSkills(player);

    double totalRating = 0.0;

    // Apply position-specific weights to relevant skills
    for (final entry in config.skillWeights.entries) {
      final skillKey = entry.key;
      final weight = entry.value;

      final skillValue = playerSkills[skillKey];
      if (skillValue == null) {
        // Skill not found - this shouldn't happen if config is correct
        throw Exception(
          'Skill $skillKey required for position $position not found in player skills',
        );
      }

      totalRating += skillValue * weight;
    }

    return totalRating;
  }

  /// Calculate ratings for all positions
  ///
  /// Returns a map of position keys (oh, opp, mb, s, l) to ratings (1-20)
  Map<String, double> calculateAllPositionRatings(PlayerDto player) {
    final ratings = <String, double>{};

    for (final position in positionConfigs.keys) {
      ratings[position] = calculatePositionRating(position, player);
    }

    return ratings;
  }

  /// Get the best position for a player based on ratings
  ///
  /// Returns a tuple of (positionKey, rating)
  MapEntry<String, double> getBestPosition(PlayerDto player) {
    final ratings = calculateAllPositionRatings(player);

    return ratings.entries.reduce(
      (best, current) => current.value > best.value ? current : best,
    );
  }

  /// Get positions ranked by suitability (best to worst)
  List<MapEntry<String, double>> getRankedPositions(PlayerDto player) {
    final ratings = calculateAllPositionRatings(player);
    final ranked = ratings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ranked;
  }

  /// Check if a player is suitable for a position (above threshold)
  ///
  /// Default threshold is 12.0 (60% of max rating)
  bool isSuitableForPosition(
    String position,
    PlayerDto player, {
    double threshold = 12.0,
  }) {
    final rating = calculatePositionRating(position, player);
    return rating >= threshold;
  }

  /// Get position name from key
  String getPositionName(String positionKey) {
    return positionConfigs[positionKey]?.positionName ?? positionKey;
  }

  /// Get position description
  String? getPositionDescription(String positionKey) {
    return positionConfigs[positionKey]?.description;
  }

  /// Get all available position keys
  List<String> get availablePositions => positionConfigs.keys.toList();
}
