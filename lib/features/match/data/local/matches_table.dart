import 'package:drift/drift.dart';
import 'package:volleyball_manager/features/team/data/local/team_tables.dart';

/// Stores top-level match metadata for grouping audit log entries.
@DataClassName('Match')
class Matches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get homeTeamId => integer().references(Teams, #id)();
  IntColumn get awayTeamId => integer().references(Teams, #id)();
  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get homeScore => integer().withDefault(const Constant(0))();
  IntColumn get awayScore => integer().withDefault(const Constant(0))();
  BoolColumn get isComplete => boolean().withDefault(const Constant(false))();
}
