import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:volleyball_manager/core/db/database.dart';
import '../dto/player_dto.dart';
import '../local/player_dao.dart';
import '../repositories/player_repository.dart';

part 'player_providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase db(Ref ref) => AppDatabase();

@Riverpod(keepAlive: true)
PlayerDao playerDao(Ref ref) => PlayerDao(ref.watch(dbProvider));

@Riverpod(keepAlive: true)
PlayerRepository playerRepository(Ref ref) =>
    PlayerRepository(ref.watch(playerDaoProvider));

@riverpod
Stream<List<PlayerDto>> playersStream(Ref ref) =>
    ref.watch(playerRepositoryProvider).watchAll();

@riverpod
Future<List<PlayerDto>> playersOnce(Ref ref) =>
    ref.watch(playerRepositoryProvider).getAll();
