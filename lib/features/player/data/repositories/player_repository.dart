import 'package:volleyball_manager/core/db/database.dart';
import '../local/player_dao.dart';

class PlayerRepository {
  PlayerRepository(this._dao);

  final PlayerDao _dao;

  Future<int> add(String name) => _dao.insertPlayer(name);

  Future<List<Player>> getAll() => _dao.getAll();

  Stream<List<Player>> watchAll() => _dao.watchAll();

  Future<Player?> getById(int id) => _dao.getById(id);

  Future<bool> rename(int id, String name) => _dao.rename(id, name);

  Future<int> remove(int id) => _dao.deleteById(id);
}
