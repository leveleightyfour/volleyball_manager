import 'package:drift/drift.dart';

/// Stores outcome probability curves based on skill differentials
///
/// This allows tweaking match outcomes without code changes. Curves map
/// skill differentials (attacker - defender) to outcome probabilities.
///
/// Example: serve_vs_reception with differential +6 might yield:
/// {"ace": 0.30, "error": 0.05, "good": 0.50, "perfect": 0.15}
@DataClassName('OutcomeCurve')
class OutcomeCurves extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Skill matchup identifier (e.g., "serve_vs_reception", "attack_vs_block")
  TextColumn get matchupKey => text()();

  /// Skill differential threshold (e.g., -6.0, -3.0, 0.0, 3.0, 6.0)
  /// Positive = attacker advantage, Negative = defender advantage
  RealColumn get differential => real()();

  /// JSON probabilities: {"ace": 0.30, "error": 0.05, "good": 0.50, "perfect": 0.15}
  TextColumn get probabilities => text()();

  /// Whether this curve is active
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
