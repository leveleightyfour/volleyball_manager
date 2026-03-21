import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:volleyball_manager/core/db/database.dart';
import 'package:volleyball_manager/features/player/data/providers/player_providers.dart';
import 'package:volleyball_manager/features/player/domain/position_rating_calculator.dart';
import 'package:volleyball_manager/features/player/domain/position_rating_service.dart';
import 'package:volleyball_manager/features/player/domain/skill_calculator.dart';

part 'position_rating_providers.g.dart';

/// Provider for position weight configurations
@riverpod
Future<Map<String, PositionWeightConfig>> positionWeights(
  Ref ref,
) async {
  final jsonString = await rootBundle.loadString(
    'assets/config/position_weights.json',
  );
  final Map<String, dynamic> weightsJson = jsonDecode(jsonString);

  final configs = <String, PositionWeightConfig>{};
  for (final entry in weightsJson.entries) {
    configs[entry.key] = PositionWeightConfig.fromJson(
      entry.value as Map<String, dynamic>,
    );
  }

  return configs;
}

/// Provider for SkillCalculator
@riverpod
Future<SkillCalculator> skillCalculator(Ref ref) async {
  final db = ref.watch(dbProvider);
  final formulas = await db.select(db.skillFormulas).get();

  final formulaMap = <String, SkillFormula>{};
  for (final formula in formulas) {
    formulaMap[formula.skillKey] = formula;
  }

  return SkillCalculator(formulaMap);
}

/// Provider for PositionRatingCalculator
@riverpod
Future<PositionRatingCalculator> positionRatingCalculator(
  Ref ref,
) async {
  final configs = await ref.watch(positionWeightsProvider.future);
  final skillCalc = await ref.watch(skillCalculatorProvider.future);

  return PositionRatingCalculator(
    skillCalculator: skillCalc,
    positionConfigs: configs,
  );
}

/// Provider for PositionRatingService
@riverpod
Future<PositionRatingService> positionRatingService(
  Ref ref,
) async {
  final playerRepository = ref.watch(playerRepositoryProvider);
  final skillCalc = await ref.watch(skillCalculatorProvider.future);

  final service = PositionRatingService(
    playerRepository: playerRepository,
    skillCalculator: skillCalc,
  );

  await service.initialize();
  return service;
}

/// Provider to get position ratings for a specific player
@riverpod
Future<Map<String, double>> playerPositionRatings(
  Ref ref,
  int playerId,
) async {
  final service = await ref.watch(positionRatingServiceProvider.future);
  return service.getPlayerRatings(playerId);
}

/// Provider to get the best position for a specific player
@riverpod
Future<MapEntry<String, double>> playerBestPosition(
  Ref ref,
  int playerId,
) async {
  final service = await ref.watch(positionRatingServiceProvider.future);
  return service.getBestPosition(playerId);
}

/// Provider to get ranked positions for a specific player
@riverpod
Future<List<MapEntry<String, double>>> playerRankedPositions(
  Ref ref,
  int playerId,
) async {
  final service = await ref.watch(positionRatingServiceProvider.future);
  return service.getRankedPositions(playerId);
}
