import 'package:drift/drift.dart';
import 'package:volleyball_manager/features/team/data/local/team_tables.dart';
import 'package:volleyball_manager/features/player/data/local/player_tables.dart';

/// Join table linking players to teams with their role assignment.
///
/// Role tags match the position-system strings: S, OH1, OH2, MB1, MB2, OPP, L.
/// rotationOrder (1-7) defines the player's slot in the starting rotation.
@DataClassName('TeamPlayer')
class TeamPlayers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get teamId => integer().references(Teams, #id)();
  IntColumn get playerId => integer().references(Players, #id)();

  /// Role tag: S | OH1 | OH2 | MB1 | MB2 | OPP | L
  TextColumn get roleTag => text()();

  /// Position in starting rotation (1 = serves first, 7 = libero)
  IntColumn get rotationOrder => integer()();

  BoolColumn get isStarter => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {teamId, playerId},
        {teamId, rotationOrder},
      ];
}
