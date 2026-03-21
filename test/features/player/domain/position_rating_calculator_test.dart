import 'package:flutter_test/flutter_test.dart';
import 'package:volleyball_manager/core/db/database.dart';
import 'package:volleyball_manager/features/player/data/dto/player_dto.dart';
import 'package:volleyball_manager/features/player/domain/position_rating_calculator.dart';
import 'package:volleyball_manager/features/player/domain/skill_calculator.dart';

PlayerDto createPlayerDto({
  int id = 1,
  String name = 'Test Player',
  int wristSnap = 10,
  int power = 10,
  int accuracy = 10,
  int aggression = 10,
  int strength = 10,
  int positioning = 10,
  int predictability = 10,
  int creativity = 10,
  int penetration = 10,
  int height = 10,
  int form = 10,
  int anticipation = 10,
  int footwork = 10,
  int platform = 10,
  int stability = 10,
  int touch = 10,
  int vision = 10,
  int timing = 10,
  int versatility = 10,
  int reaction = 10,
  int reading = 10,
  int intention = 10,
  int control = 10,
  double ratingOh = 10.0,
  double ratingOpp = 10.0,
  double ratingMb = 10.0,
  double ratingS = 10.0,
  double ratingL = 10.0,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final timestamp = createdAt ?? updatedAt ?? DateTime.now();
  return PlayerDto(
    id: id,
    name: name,
    wristSnap: wristSnap,
    power: power,
    accuracy: accuracy,
    aggression: aggression,
    strength: strength,
    positioning: positioning,
    predictability: predictability,
    creativity: creativity,
    penetration: penetration,
    height: height,
    form: form,
    anticipation: anticipation,
    footwork: footwork,
    platform: platform,
    stability: stability,
    touch: touch,
    vision: vision,
    timing: timing,
    versatility: versatility,
    reaction: reaction,
    reading: reading,
    intention: intention,
    control: control,
    ratingOh: ratingOh,
    ratingOpp: ratingOpp,
    ratingMb: ratingMb,
    ratingS: ratingS,
    ratingL: ratingL,
    createdAt: timestamp,
    updatedAt: updatedAt ?? timestamp,
  );
}

void main() {
  group('PositionRatingCalculator', () {
    late SkillCalculator skillCalculator;
    late PositionRatingCalculator positionCalculator;

    setUp(() {
      // Create mock skill formulas for testing
      final formulas = {
        'attackOutsideTempo': SkillFormula(
          id: 1,
          skillKey: 'attackOutsideTempo',
          skillName: 'Attack an Outside Tempo Ball',
          category: 'attack',
          formula: '{"vision": 0.40, "timing": 0.15, "power": 0.15, "versatility": 0.30}',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        'attackOutsideHigh': SkillFormula(
          id: 2,
          skillKey: 'attackOutsideHigh',
          skillName: 'Attack an Outside High Ball',
          category: 'attack',
          formula: '{"vision": 0.30, "timing": 0.05, "power": 0.50, "versatility": 0.25}',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        'receptionJumpServe': SkillFormula(
          id: 3,
          skillKey: 'receptionJumpServe',
          skillName: 'Receive Jump Serve',
          category: 'reception',
          formula: '{"footwork": 0.10, "platform": 0.50, "stability": 0.35, "touch": 0.15}',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        'setOutsideTempo': SkillFormula(
          id: 4,
          skillKey: 'setOutsideTempo',
          skillName: 'Set the Outside Tempo',
          category: 'setting',
          formula: '{"strength": 0.10, "positioning": 0.15, "predictability": 0.40, "creativity": 0.25}',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        'blockMiddle': SkillFormula(
          id: 5,
          skillKey: 'blockMiddle',
          skillName: 'Block Middle Attack',
          category: 'blocking',
          formula: '{"penetration": 0.40, "height": 0.10, "form": 0.20, "anticipation": 0.30}',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      };

      skillCalculator = SkillCalculator(formulas);

      // Create position configs for testing
      final positionConfigs = {
        'oh': PositionWeightConfig(
          positionName: 'Outside Hitter',
          description: 'Test OH',
          skillWeights: {
            'attackOutsideTempo': 0.50,
            'receptionJumpServe': 0.30,
            'blockMiddle': 0.20,
          },
        ),
        's': PositionWeightConfig(
          positionName: 'Setter',
          description: 'Test Setter',
          skillWeights: {
            'setOutsideTempo': 0.80,
            'blockMiddle': 0.20,
          },
        ),
      };

      positionCalculator = PositionRatingCalculator(
        skillCalculator: skillCalculator,
        positionConfigs: positionConfigs,
      );
    });

    test('calculates position rating correctly', () {
      // Create a test player with specific attributes
      final player = createPlayerDto(
        vision: 15,
        timing: 12,
        power: 18,
        versatility: 14,
        footwork: 16,
        platform: 14,
        stability: 13,
        touch: 15,
        penetration: 10,
        height: 12,
        form: 11,
        anticipation: 13,
      );

      final rating = positionCalculator.calculatePositionRating('oh', player);

      // Rating should be a weighted average of the relevant skills
      // Attack Outside Tempo: vision(15)*0.4 + timing(12)*0.15 + power(18)*0.15 + versatility(14)*0.3 = 14.7
      // Reception Jump Serve: footwork(16)*0.1 + platform(14)*0.5 + stability(13)*0.35 + touch(15)*0.15 = 14.1
      // Block Middle: penetration(10)*0.4 + height(12)*0.1 + form(11)*0.2 + anticipation(13)*0.3 = 11.1
      // OH Rating: 14.7*0.5 + 14.1*0.3 + 11.1*0.2 = 13.8
      expect(rating, closeTo(13.8, 0.1));
    });

    test('calculates all position ratings', () {
      final player = createPlayerDto(
        vision: 15,
        timing: 12,
        power: 15,
        versatility: 14,
        footwork: 14,
        platform: 14,
        stability: 13,
        touch: 15,
        penetration: 12,
        height: 14,
        form: 13,
        anticipation: 13,
        strength: 16,
        positioning: 15,
        predictability: 14,
        creativity: 13,
      );

      final ratings = positionCalculator.calculateAllPositionRatings(player);

      expect(ratings, contains('oh'));
      expect(ratings, contains('s'));
      expect(ratings['oh'], isA<double>());
      expect(ratings['s'], isA<double>());
    });

    test('identifies best position for player', () {
      final player = createPlayerDto(
        name: 'Setter Player',
        strength: 18,
        positioning: 17,
        predictability: 16,
        creativity: 15,
      );

      final bestPosition = positionCalculator.getBestPosition(player);

      // Player should be best at setter
      expect(bestPosition.key, equals('s'));
      expect(bestPosition.value, greaterThan(12.0));
    });

    test('ranks positions correctly', () {
      final player = createPlayerDto(
        vision: 12,
        timing: 12,
        power: 12,
        versatility: 12,
        footwork: 12,
        platform: 12,
        stability: 12,
        touch: 12,
        penetration: 12,
        height: 12,
        form: 12,
        anticipation: 12,
        strength: 12,
        positioning: 12,
        predictability: 12,
        creativity: 12,
        wristSnap: 12,
        accuracy: 12,
        aggression: 12,
        reaction: 12,
        reading: 12,
        intention: 12,
        control: 12,
      );

      final ranked = positionCalculator.getRankedPositions(player);

      expect(ranked.length, equals(2)); // oh and s
      expect(ranked[0].value, greaterThanOrEqualTo(ranked[1].value));
    });

    test('gets position metadata', () {
      expect(positionCalculator.getPositionName('oh'), equals('Outside Hitter'));
      expect(positionCalculator.getPositionName('s'), equals('Setter'));
      expect(positionCalculator.getPositionDescription('oh'), equals('Test OH'));
    });
  });
}
