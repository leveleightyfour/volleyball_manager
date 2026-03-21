import 'package:volleyball_manager/core/db/database.dart';

/// Lightweight representation of a player record used outside of the
/// persistence layer. Keeps domain logic from depending on Drift types.
class PlayerDto {
  const PlayerDto({
    required this.id,
    required this.name,
    required this.wristSnap,
    required this.power,
    required this.accuracy,
    required this.aggression,
    required this.strength,
    required this.positioning,
    required this.predictability,
    required this.creativity,
    required this.penetration,
    required this.height,
    required this.form,
    required this.anticipation,
    required this.footwork,
    required this.platform,
    required this.stability,
    required this.touch,
    required this.vision,
    required this.timing,
    required this.versatility,
    required this.reaction,
    required this.reading,
    required this.intention,
    required this.control,
    required this.ratingOh,
    required this.ratingOpp,
    required this.ratingMb,
    required this.ratingS,
    required this.ratingL,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;

  // Serving
  final int wristSnap;
  final int power;
  final int accuracy;
  final int aggression;

  // Setting
  final int strength;
  final int positioning;
  final int predictability;
  final int creativity;

  // Blocking
  final int penetration;
  final int height;
  final int form;
  final int anticipation;

  // Reception
  final int footwork;
  final int platform;
  final int stability;
  final int touch;

  // Attack
  final int vision;
  final int timing;
  final int versatility;

  // Defense
  final int reaction;
  final int reading;
  final int intention;
  final int control;

  // Stored position ratings
  final double ratingOh;
  final double ratingOpp;
  final double ratingMb;
  final double ratingS;
  final double ratingL;

  final DateTime createdAt;
  final DateTime updatedAt;

  factory PlayerDto.fromDb(Player player) {
    return PlayerDto(
      id: player.id,
      name: player.name,
      wristSnap: player.wristSnap,
      power: player.power,
      accuracy: player.accuracy,
      aggression: player.aggression,
      strength: player.strength,
      positioning: player.positioning,
      predictability: player.predictability,
      creativity: player.creativity,
      penetration: player.penetration,
      height: player.height,
      form: player.form,
      anticipation: player.anticipation,
      footwork: player.footwork,
      platform: player.platform,
      stability: player.stability,
      touch: player.touch,
      vision: player.vision,
      timing: player.timing,
      versatility: player.versatility,
      reaction: player.reaction,
      reading: player.reading,
      intention: player.intention,
      control: player.control,
      ratingOh: player.ratingOh,
      ratingOpp: player.ratingOpp,
      ratingMb: player.ratingMb,
      ratingS: player.ratingS,
      ratingL: player.ratingL,
      createdAt: player.createdAt,
      updatedAt: player.updatedAt,
    );
  }

  Map<String, double> get positionRatings => {
        'oh': ratingOh,
        'opp': ratingOpp,
        'mb': ratingMb,
        's': ratingS,
        'l': ratingL,
      };
}

extension PlayerDtoListX on List<Player> {
  List<PlayerDto> toDtos() => map(PlayerDto.fromDb).toList();
}
