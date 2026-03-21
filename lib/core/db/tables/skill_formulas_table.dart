import 'package:drift/drift.dart';

/// Stores skill formula configurations (JSON)
///
/// This allows tweaking formulas without code changes. Formulas define how
/// base player attributes combine to create derived skill values.
///
/// Example: "Serve Jump Serve" = 40% wristSnap + 40% power + 10% accuracy + 10% aggression
@DataClassName('SkillFormula')
class SkillFormulas extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Unique identifier for the skill (e.g., "serveJumpServe")
  TextColumn get skillKey => text().unique()();

  /// Human-readable name (e.g., "Serve a Jump Serve")
  TextColumn get skillName => text()();

  /// Category (e.g., "serving", "blocking", "reception")
  TextColumn get category => text()();

  /// JSON formula: {"wristSnap": 0.40, "power": 0.40, "accuracy": 0.10, "aggression": 0.10}
  TextColumn get formula => text()();

  /// Whether this formula is active
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
