import 'package:drift/drift.dart';

class Teams extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}
