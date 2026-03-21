import 'package:drift/drift.dart';

/// Player entity with all user-facing attributes (1-20 scale)
///
/// Players have 23 base attributes across 5 categories (serving, setting, blocking,
/// reception, attack, defense). These combine via configurable formulas to create
/// derived skill values used in match simulation.
@DataClassName('Player')
class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  // ========== SERVING ATTRIBUTES ==========
  IntColumn get wristSnap => integer().withDefault(const Constant(10))();
  IntColumn get power => integer().withDefault(const Constant(10))();
  IntColumn get accuracy => integer().withDefault(const Constant(10))();
  IntColumn get aggression => integer().withDefault(const Constant(10))();

  // ========== SETTING ATTRIBUTES ==========
  IntColumn get strength => integer().withDefault(const Constant(10))();
  IntColumn get positioning => integer().withDefault(const Constant(10))();
  IntColumn get predictability => integer().withDefault(const Constant(10))();
  IntColumn get creativity => integer().withDefault(const Constant(10))();

  // ========== BLOCKING ATTRIBUTES ==========
  IntColumn get penetration => integer().withDefault(const Constant(10))();
  IntColumn get height => integer().withDefault(const Constant(10))();
  IntColumn get form => integer().withDefault(const Constant(10))();
  IntColumn get anticipation => integer().withDefault(const Constant(10))();

  // ========== RECEPTION ATTRIBUTES ==========
  IntColumn get footwork => integer().withDefault(const Constant(10))();
  IntColumn get platform => integer().withDefault(const Constant(10))();
  IntColumn get stability => integer().withDefault(const Constant(10))();
  IntColumn get touch => integer().withDefault(const Constant(10))();

  // ========== ATTACK ATTRIBUTES ==========
  IntColumn get vision => integer().withDefault(const Constant(10))();
  IntColumn get timing => integer().withDefault(const Constant(10))();
  IntColumn get versatility => integer().withDefault(const Constant(10))();

  // ========== DEFENSE ATTRIBUTES ==========
  IntColumn get reaction => integer().withDefault(const Constant(10))();
  IntColumn get reading => integer().withDefault(const Constant(10))();
  IntColumn get intention => integer().withDefault(const Constant(10))();
  IntColumn get control => integer().withDefault(const Constant(10))();

  // ========== POSITION RATINGS (1-20 scale, calculated) ==========
  // These are derived values calculated from attributes via position formulas
  RealColumn get ratingOh => real().withDefault(const Constant(10.0))();
  RealColumn get ratingOpp => real().withDefault(const Constant(10.0))();
  RealColumn get ratingMb => real().withDefault(const Constant(10.0))();
  RealColumn get ratingS => real().withDefault(const Constant(10.0))();
  RealColumn get ratingL => real().withDefault(const Constant(10.0))();

  // Metadata
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
