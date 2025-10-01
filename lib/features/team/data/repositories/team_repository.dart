import 'package:volleyball_manager/core/db/database.dart';

import '../local/team_dao.dart';

class TeamRepository {
  TeamRepository(this._dao);
  final TeamDao _dao;

  Future<int> add(String name) => _dao.insertTeam(name);
  Future<List<Team>> getAll() => _dao.getAll();
  Stream<List<Team>> watchAll() => _dao.watchAll();
  Future<Team?> getById(int id) => _dao.getById(id);
  Future<bool> rename(int id, String name) => _dao.rename(id, name);
  Future<int> remove(int id) => _dao.deleteById(id);
}
