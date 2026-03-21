import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:volleyball_manager/core/db/database.dart';
import 'package:drift/drift.dart' as drift;

/// Seeds the database with default data from JSON assets.
class DatabaseSeeder {
  DatabaseSeeder(this.db);

  final AppDatabase db;

  /// Full seed: formulas, curves, players, teams (used on first install).
  Future<void> seedAll() async {
    await seedSkillFormulas();
    await seedOutcomeCurves();
    await seedPlayersAndTeams();
  }

  // ---------- Skill Formulas ----------

  Future<void> seedSkillFormulas() async {
    final existing = await db.select(db.skillFormulas).get();
    if (existing.isNotEmpty) return;

    final jsonString =
        await rootBundle.loadString('assets/config/skill_formulas.json');
    final Map<String, dynamic> formulasJson = jsonDecode(jsonString);

    await db.batch((batch) {
      for (final entry in formulasJson.entries) {
        final data = entry.value as Map<String, dynamic>;
        batch.insert(
          db.skillFormulas,
          SkillFormulasCompanion(
            skillKey: drift.Value(entry.key),
            skillName: drift.Value(data['skillName'] as String),
            category: drift.Value(data['category'] as String),
            formula: drift.Value(jsonEncode(data['formula'])),
            isActive: drift.Value(data['isActive'] as bool),
          ),
        );
      }
    });
  }

  // ---------- Outcome Curves ----------

  Future<void> seedOutcomeCurves() async {
    // Incremental seed: only insert matchup keys not yet in the DB.
    // Allows adding new matchup types without wiping existing tuned data.
    final existing = await db.select(db.outcomeCurves).get();
    final existingKeys = existing.map((e) => e.matchupKey).toSet();

    final jsonString =
        await rootBundle.loadString('assets/config/outcome_curves.json');
    final Map<String, dynamic> curvesJson = jsonDecode(jsonString);

    final newEntries = curvesJson.entries
        .where((e) => !existingKeys.contains(e.key))
        .toList();
    if (newEntries.isEmpty) return;

    await db.batch((batch) {
      for (final entry in newEntries) {
        final curves = entry.value as List<dynamic>;
        for (final curveData in curves) {
          final curve = curveData as Map<String, dynamic>;
          batch.insert(
            db.outcomeCurves,
            OutcomeCurvesCompanion(
              matchupKey: drift.Value(entry.key),
              differential:
                  drift.Value((curve['differential'] as num).toDouble()),
              probabilities:
                  drift.Value(jsonEncode(curve['probabilities'])),
              isActive: drift.Value(curve['isActive'] as bool),
            ),
          );
        }
      }
    });
  }

  // ---------- Players & Teams ----------

  /// Seeds players and teams from player_seed.json.
  /// Safe to call multiple times — checks for existing data first.
  Future<void> seedPlayersAndTeams() async {
    final existingTeams = await db.select(db.teams).get();
    if (existingTeams.isNotEmpty) return;

    final jsonString =
        await rootBundle.loadString('assets/config/player_seed.json');
    final Map<String, dynamic> seedJson = jsonDecode(jsonString);

    final teamsData = seedJson['teams'] as List<dynamic>;
    final playersData = seedJson['players'] as List<dynamic>;

    await db.transaction(() async {
      // 1) Teams
      for (final t in teamsData) {
        final team = t as Map<String, dynamic>;
        await db.into(db.teams).insert(
              TeamsCompanion.insert(name: team['name'] as String),
            );
      }

      // 2) Players
      for (final p in playersData) {
        final d = p as Map<String, dynamic>;
        await db.into(db.players).insert(
              PlayersCompanion(
                name: drift.Value(d['name'] as String),
                wristSnap: drift.Value(d['wristSnap'] as int),
                power: drift.Value(d['power'] as int),
                accuracy: drift.Value(d['accuracy'] as int),
                aggression: drift.Value(d['aggression'] as int),
                strength: drift.Value(d['strength'] as int),
                positioning: drift.Value(d['positioning'] as int),
                predictability: drift.Value(d['predictability'] as int),
                creativity: drift.Value(d['creativity'] as int),
                penetration: drift.Value(d['penetration'] as int),
                height: drift.Value(d['height'] as int),
                form: drift.Value(d['form'] as int),
                anticipation: drift.Value(d['anticipation'] as int),
                footwork: drift.Value(d['footwork'] as int),
                platform: drift.Value(d['platform'] as int),
                stability: drift.Value(d['stability'] as int),
                touch: drift.Value(d['touch'] as int),
                vision: drift.Value(d['vision'] as int),
                timing: drift.Value(d['timing'] as int),
                versatility: drift.Value(d['versatility'] as int),
                reaction: drift.Value(d['reaction'] as int),
                reading: drift.Value(d['reading'] as int),
                intention: drift.Value(d['intention'] as int),
                control: drift.Value(d['control'] as int),
              ),
            );
      }

      // 3) TeamPlayers join
      for (final p in playersData) {
        final d = p as Map<String, dynamic>;
        await db.into(db.teamPlayers).insert(
              TeamPlayersCompanion(
                teamId: drift.Value(d['teamId'] as int),
                playerId: drift.Value(d['id'] as int),
                roleTag: drift.Value(d['roleTag'] as String),
                rotationOrder: drift.Value(d['rotationOrder'] as int),
              ),
            );
      }
    });
  }

  // ---------- Dev helpers ----------

  Future<void> resetSeedData() async {
    await db.delete(db.skillFormulas).go();
    await db.delete(db.outcomeCurves).go();
    await seedAll();
  }
}
