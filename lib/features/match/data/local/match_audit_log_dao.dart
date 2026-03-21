import 'package:drift/drift.dart';
import 'package:volleyball_manager/core/db/database.dart';
import 'match_audit_log_table.dart';

part 'match_audit_log_dao.g.dart';

@DriftAccessor(tables: [MatchAuditLog])
class MatchAuditLogDao extends DatabaseAccessor<AppDatabase>
    with _$MatchAuditLogDaoMixin {
  MatchAuditLogDao(super.db);

  Future<void> insertEntry(MatchAuditLogCompanion entry) =>
      into(matchAuditLog).insert(entry);

  Future<void> insertEntries(List<MatchAuditLogCompanion> entries) =>
      batch((b) => b.insertAll(matchAuditLog, entries));

  Future<List<MatchAuditEntry>> getByMatch(int matchId) =>
      (select(matchAuditLog)
            ..where((t) => t.matchId.equals(matchId))
            ..orderBy([(t) => OrderingTerm.asc(t.occurredAt)]))
          .get();

  Future<List<MatchAuditEntry>> getByRally(int matchId, int rallyId) =>
      (select(matchAuditLog)
            ..where((t) =>
                t.matchId.equals(matchId) & t.rallyId.equals(rallyId))
            ..orderBy([(t) => OrderingTerm.asc(t.occurredAt)]))
          .get();

  Stream<List<MatchAuditEntry>> watchByMatch(int matchId) =>
      (select(matchAuditLog)
            ..where((t) => t.matchId.equals(matchId))
            ..orderBy([(t) => OrderingTerm.asc(t.occurredAt)]))
          .watch();
}
