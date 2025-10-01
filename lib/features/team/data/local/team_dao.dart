import 'package:drift/drift.dart';
import '../../../../core/db/database.dart';
import 'team_tables.dart';

part 'team_dao.g.dart';

@DriftAccessor(tables: [Teams])
class TeamDao extends DatabaseAccessor<AppDatabase> with _$TeamDaoMixin {
  TeamDao(AppDatabase db) : super(db);

  Future<int> insertTeam(String name) =>
      into(teams).insert(TeamsCompanion.insert(name: name));

  Future<List<Team>> getAll() => select(teams).get();
  Stream<List<Team>> watchAll() => select(teams).watch();

  Future<Team?> getById(int id) =>
      (select(teams)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<bool> rename(int id, String name) =>
      (update(teams)..where((t) => t.id.equals(id)))
          .write(TeamsCompanion(name: Value(name)))
          .then((rows) => rows > 0);

  Future<int> deleteById(int id) =>
      (delete(teams)..where((t) => t.id.equals(id))).go();
}
