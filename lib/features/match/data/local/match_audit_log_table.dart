import 'package:drift/drift.dart';

/// Stores a granular log of every action in a match.
///
/// Each row captures one EngineEvent with full context:
/// - Which phase it occurred in
/// - The match score and rotations at that moment
/// - The result of any player skill comparison that drove the outcome
/// - The raw probability distribution used
///
/// Designed for diagnostics: every tweak to formulas/curves can be validated
/// by replaying the audit log.
@DataClassName('MatchAuditEntry')
class MatchAuditLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get matchId => integer()();
  IntColumn get rallyId => integer()();

  /// Match phase: preServe | serve | reception | setting | attack | rallyEnd
  TextColumn get phase => text()();

  /// Event type: phaseChanged | serveBallFlight | scoreChanged |
  ///             rotationAdvanced | rallyEnded | attackOutcome |
  ///             passOutcome | setOutcome | serveOutcome
  TextColumn get eventType => text()();

  /// JSON payload — varies by eventType.
  ///
  /// For outcome events includes:
  /// { score, rotationHome, rotationAway, serverSide, result,
  ///   playerComparison: { serverSkill, receiverSkill, differential, probs } }
  TextColumn get payload => text()();

  DateTimeColumn get occurredAt => dateTime().withDefault(currentDateAndTime)();
}
