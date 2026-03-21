import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:volleyball_manager/features/player/data/dto/player_dto.dart';
import 'package:volleyball_manager/features/player/data/repositories/player_repository.dart';
import 'package:volleyball_manager/features/player/domain/position_rating_calculator.dart';
import 'package:volleyball_manager/features/player/domain/skill_calculator.dart';

/// Service for managing player position ratings
///
/// This service handles:
/// - Loading position weight configurations
/// - Calculating position ratings for players
/// - Persisting ratings to the database
class PositionRatingService {
  final PlayerRepository playerRepository;
  final SkillCalculator skillCalculator;
  late final PositionRatingCalculator _calculator;
  bool _initialized = false;

  PositionRatingService({
    required this.playerRepository,
    required this.skillCalculator,
  });

  /// Initialize the service by loading position weights configuration
  Future<void> initialize() async {
    if (_initialized) return;

    final jsonString = await rootBundle.loadString(
      'assets/config/position_weights.json',
    );
    final Map<String, dynamic> weightsJson = jsonDecode(jsonString);

    _calculator = PositionRatingCalculator.fromJson(
      weightsJson,
      skillCalculator,
    );

    _initialized = true;
  }

  /// Ensure the service is initialized before use
  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'PositionRatingService must be initialized before use. '
        'Call initialize() first.',
      );
    }
  }

  /// Calculate and update position ratings for a single player
  Future<void> updatePlayerRatings(PlayerDto player) async {
    _ensureInitialized();

    final ratings = _calculator.calculateAllPositionRatings(player);

    await playerRepository.updatePositionRatings(
      player.id,
      oh: ratings['oh']!,
      opp: ratings['opp']!,
      mb: ratings['mb']!,
      s: ratings['s']!,
      l: ratings['l']!,
    );
  }

  /// Calculate and update position ratings for all players
  Future<void> updateAllPlayerRatings() async {
    _ensureInitialized();

    final players = await playerRepository.getAll();

    for (final player in players) {
      await updatePlayerRatings(player);
    }
  }

  /// Get position ratings for a player (from database)
  Future<Map<String, double>> getPlayerRatings(int playerId) async {
    final player = await playerRepository.getById(playerId);
    if (player == null) {
      throw Exception('Player not found: $playerId');
    }

    return {
      'oh': player.ratingOh,
      'opp': player.ratingOpp,
      'mb': player.ratingMb,
      's': player.ratingS,
      'l': player.ratingL,
    };
  }

  /// Get best position for a player (from database ratings)
  Future<MapEntry<String, double>> getBestPosition(int playerId) async {
    final ratings = await getPlayerRatings(playerId);
    return ratings.entries.reduce(
      (best, current) => current.value > best.value ? current : best,
    );
  }

  /// Get positions ranked by rating for a player (from database)
  Future<List<MapEntry<String, double>>> getRankedPositions(
    int playerId,
  ) async {
    final ratings = await getPlayerRatings(playerId);
    final ranked = ratings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return ranked;
  }

  /// Calculate position ratings without persisting (for preview/testing)
  Map<String, double> calculateRatingsPreview(PlayerDto player) {
    _ensureInitialized();
    return _calculator.calculateAllPositionRatings(player);
  }

  /// Get position name from key
  String getPositionName(String positionKey) {
    _ensureInitialized();
    return _calculator.getPositionName(positionKey);
  }

  /// Get position description
  String? getPositionDescription(String positionKey) {
    _ensureInitialized();
    return _calculator.getPositionDescription(positionKey);
  }

  /// Get all available positions
  List<String> get availablePositions {
    _ensureInitialized();
    return _calculator.availablePositions;
  }
}
