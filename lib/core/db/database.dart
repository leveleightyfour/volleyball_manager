import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volleyball_manager/features/player/data/local/player_tables.dart';
import 'package:volleyball_manager/features/team/data/local/team_tables.dart';
import 'connection.dart';

part 'database.g.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

@DriftDatabase(tables: [Players, Teams])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(createDriftConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    onUpgrade: (m, from, to) async {},
  );
}
