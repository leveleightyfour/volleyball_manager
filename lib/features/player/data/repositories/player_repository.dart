import 'package:volleyball_manager/core/db/database.dart';
import 'package:volleyball_manager/features/player/data/dto/player_dto.dart';
import '../local/player_dao.dart';

class PlayerRepository {
  PlayerRepository(this._dao);

  final PlayerDao _dao;

  Future<int> add(String name) => _dao.insertPlayer(name);

  Future<List<PlayerDto>> getAll() async {
    final rows = await _dao.getAll();
    return rows.toDtos();
  }

  Stream<List<PlayerDto>> watchAll() =>
      _dao.watchAll().map((players) => players.toDtos());

  Future<PlayerDto?> getById(int id) async {
    final player = await _dao.getById(id);
    return player == null ? null : PlayerDto.fromDb(player);
  }

  Future<bool> rename(int id, String name) => _dao.rename(id, name);

  Future<int> remove(int id) => _dao.deleteById(id);

  Future<bool> updatePositionRatings(
    int id, {
    required double oh,
    required double opp,
    required double mb,
    required double s,
    required double l,
  }) =>
      _dao.updatePositionRatings(
        id,
        oh: oh,
        opp: opp,
        mb: mb,
        s: s,
        l: l,
      );

  Future<void> batchUpdatePositionRatings(
    Map<int, Map<String, double>> updates,
  ) =>
      _dao.batchUpdatePositionRatings(updates);

  Future<List<PlayerDto>> getByTeamId(int teamId) async {
    final rows = await _dao.getByTeamId(teamId);
    return rows.toDtos();
  }
}
