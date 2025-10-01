import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:volleyball_manager/core/db/database.dart';
import 'package:volleyball_manager/features/player/data/providers/player_providers.dart';
import '../local/team_dao.dart';
import '../repositories/team_repository.dart';

part 'team_providers.g.dart';

@Riverpod(keepAlive: true)
TeamDao teamDao(Ref ref) => TeamDao(ref.watch(dbProvider));

@Riverpod(keepAlive: true)
TeamRepository teamRepository(Ref ref) =>
    TeamRepository(ref.watch(teamDaoProvider));

@riverpod
Stream<List<Team>> teamsStream(Ref ref) =>
    ref.watch(teamRepositoryProvider).watchAll();

@riverpod
Future<List<Team>> teamsOnce(Ref ref) =>
    ref.watch(teamRepositoryProvider).getAll();
