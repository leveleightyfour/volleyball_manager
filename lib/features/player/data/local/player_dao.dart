import 'package:drift/drift.dart';
import 'package:volleyball_manager/core/db/database.dart';
import 'player_tables.dart';

part 'player_dao.g.dart';

@DriftAccessor(tables: [Players])
class PlayerDao extends DatabaseAccessor<AppDatabase> with _$PlayerDaoMixin {
  PlayerDao(super.db);

  Future<int> insertPlayer(String name) =>
      into(players).insert(PlayersCompanion.insert(name: name));

  Future<List<Player>> getAll() => select(players).get();
  Stream<List<Player>> watchAll() => select(players).watch();

  Future<Player?> getById(int id) =>
      (select(players)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<bool> rename(int id, String name) =>
      (update(players)..where((t) => t.id.equals(id)))
          .write(PlayersCompanion(name: Value(name)))
          .then((rows) => rows > 0);

  Future<int> deleteById(int id) =>
      (delete(players)..where((t) => t.id.equals(id))).go();
}
