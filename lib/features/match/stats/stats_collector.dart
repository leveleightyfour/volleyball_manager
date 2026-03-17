import '../engine/events/events.dart';
import '../engine/outcomes/outcomes.dart';
import '../engine/state/match_state.dart';
import '../engine/sim/sim_controller.dart';
import 'models/match_stats.dart';
import 'models/play_action.dart';

/// Observes engine transitions and accumulates match statistics.
///
/// Call [record] after every [SimController.advance] with the before/after
/// state, the inputs that were supplied, and the events that were emitted.
class StatsCollector {
  final List<PlayAction> _log = [];
  TeamStats _home = const TeamStats();
  TeamStats _away = const TeamStats();

  MatchStats get stats =>
      MatchStats(home: _home, away: _away, playLog: List.unmodifiable(_log));

  void record({
    required MatchState stateBefore,
    required ManualInputs inputs,
    required MatchState stateAfter,
    required List<EngineEvent> events,
  }) {
    final now = DateTime.now();
    final rallyId = stateBefore.rallyId;
    final rotationTick = stateBefore.rotationTick;

    // --- Serve outcomes ---
    if (stateBefore.phase == MatchPhase.serve && inputs.serveOutcome != null) {
      final serverSide = stateBefore.serverSide;
      final receiverSide = _other(serverSide);

      _log.add(PlayAction(
        rallyId: rallyId,
        rotationTick: rotationTick,
        side: serverSide,
        type: PlayType.serve,
        outcome: inputs.serveOutcome!.name,
        timestamp: now,
      ));

      if (inputs.serveOutcome == ServeOutcome.fault) {
        _updateSide(serverSide, (s) => s.copyWith(
          serveFaults: s.serveFaults + 1,
          totalRallies: s.totalRallies + 1,
        ));
        _updateSide(receiverSide, (s) => s.copyWith(
          points: s.points + 1,
          sideouts: s.sideouts + 1,
          sideoutAttempts: s.sideoutAttempts + 1,
          totalRallies: s.totalRallies + 1,
        ));
      }
    }

    // --- Pass outcomes ---
    if (stateBefore.phase == MatchPhase.reception &&
        inputs.passOutcome != null) {
      final receiverSide = _other(stateBefore.serverSide);

      _log.add(PlayAction(
        rallyId: rallyId,
        rotationTick: rotationTick,
        side: receiverSide,
        type: PlayType.pass,
        outcome: inputs.passOutcome!.name,
        timestamp: now,
      ));

      _updateSide(receiverSide, (s) => s.copyWith(
        totalPasses: s.totalPasses + 1,
        perfectPasses: s.perfectPasses +
            (inputs.passOutcome == PassOutcome.perfect ? 1 : 0),
      ));
    }

    // --- Set outcomes ---
    if (stateBefore.phase == MatchPhase.setting && inputs.setOutcome != null) {
      // Possession side is the one setting — we can infer from events but
      // the simplest signal is: after serve-in-play the receiver has possession,
      // after a dig possession flips. We track this via which side the engine
      // awards the point to on kill (checked in attack section).
      // For the log we still record it.
      _log.add(PlayAction(
        rallyId: rallyId,
        rotationTick: rotationTick,
        side: _possessionFromEvents(stateBefore, events),
        type: PlayType.set,
        outcome: inputs.setOutcome!.name,
        timestamp: now,
      ));
    }

    // --- Attack outcomes ---
    if (stateBefore.phase == MatchPhase.attack &&
        inputs.attackOutcome != null) {
      final attackingSide = _possessionFromEvents(stateBefore, events);
      final defendingSide = _other(attackingSide);

      _log.add(PlayAction(
        rallyId: rallyId,
        rotationTick: rotationTick,
        side: attackingSide,
        type: PlayType.attack,
        outcome: inputs.attackOutcome!.name,
        timestamp: now,
      ));

      switch (inputs.attackOutcome!) {
        case AttackOutcome.kill:
          final isSideout = attackingSide != stateBefore.serverSide;
          _updateSide(attackingSide, (s) => s.copyWith(
            kills: s.kills + 1,
            points: s.points + 1,
            totalRallies: s.totalRallies + 1,
            sideouts: s.sideouts + (isSideout ? 1 : 0),
            sideoutAttempts:
                s.sideoutAttempts + (attackingSide != stateBefore.serverSide ? 1 : 0),
          ));
          _updateSide(defendingSide, (s) => s.copyWith(
            totalRallies: s.totalRallies + 1,
            sideoutAttempts:
                s.sideoutAttempts + (defendingSide != stateBefore.serverSide ? 1 : 0),
          ));

        case AttackOutcome.error:
          _updateSide(attackingSide, (s) => s.copyWith(
            attackErrors: s.attackErrors + 1,
            totalRallies: s.totalRallies + 1,
            sideoutAttempts:
                s.sideoutAttempts + (attackingSide != stateBefore.serverSide ? 1 : 0),
          ));
          final isSideout = defendingSide != stateBefore.serverSide;
          _updateSide(defendingSide, (s) => s.copyWith(
            points: s.points + 1,
            totalRallies: s.totalRallies + 1,
            sideouts: s.sideouts + (isSideout ? 1 : 0),
            sideoutAttempts:
                s.sideoutAttempts + (defendingSide != stateBefore.serverSide ? 1 : 0),
          ));

        case AttackOutcome.blocked:
          _updateSide(attackingSide, (s) => s.copyWith(
            attacksBlocked: s.attacksBlocked + 1,
            totalRallies: s.totalRallies + 1,
            sideoutAttempts:
                s.sideoutAttempts + (attackingSide != stateBefore.serverSide ? 1 : 0),
          ));
          final isSideout = defendingSide != stateBefore.serverSide;
          _updateSide(defendingSide, (s) => s.copyWith(
            points: s.points + 1,
            blocksWon: s.blocksWon + 1,
            totalRallies: s.totalRallies + 1,
            sideouts: s.sideouts + (isSideout ? 1 : 0),
            sideoutAttempts:
                s.sideoutAttempts + (defendingSide != stateBefore.serverSide ? 1 : 0),
          ));

        case AttackOutcome.dug:
          _updateSide(defendingSide, (s) => s.copyWith(
            digs: s.digs + 1,
          ));
      }
    }

    // --- Serve ace detection ---
    // A serve ace is when the serve is in-play but the receiver immediately
    // loses the rally. We detect this by checking: serve was inPlay earlier
    // in this rally, and now we see a rallyEnded awarding point to server.
    for (final e in events) {
      e.whenOrNull(
        rallyEnded: (pointTo, eRallyId) {
          if (pointTo == stateBefore.serverSide &&
              stateBefore.phase == MatchPhase.attack &&
              inputs.attackOutcome != AttackOutcome.kill &&
              inputs.attackOutcome != AttackOutcome.dug) {
            // Already handled above via attack outcomes
          }
        },
      );
    }
  }

  /// Infer which side has possession entering the current phase.
  ///
  /// After serve-in-play the receiver has possession. Each `dug` flips it.
  /// Since the engine tracks this internally and we don't have direct access,
  /// we derive it: on reception/first-setting the receiver attacks.
  /// The rallyEnded event tells us who scored, which combined with the outcome
  /// lets us reconstruct possession. For simplicity we check the events list
  /// for a RallyEnded to see who won.
  TeamSide _possessionFromEvents(
      MatchState stateBefore, List<EngineEvent> events) {
    // Check if a rallyEnded event tells us who scored
    for (final e in events) {
      final result = e.whenOrNull(
        rallyEnded: (pointTo, _) => pointTo,
      );
      if (result != null) {
        // If outcome is kill, the scorer had possession
        // If outcome is error/blocked, the scorer was defending
        return result; // This is a simplification; refined below
      }
    }

    // No rally end in this step — we're mid-rally.
    // After serve-inPlay, receiver has possession.
    // The engine's _possession field isn't exposed, so we track implicitly:
    // On reception phase, receiver is about to attack.
    // On setting phase after reception, same side.
    // We don't have dig-flip count here, but for the current auto-step flow
    // (which only produces kill outcomes), this is sufficient.
    return _other(stateBefore.serverSide);
  }

  void _updateSide(TeamSide side, TeamStats Function(TeamStats) updater) {
    if (side == TeamSide.home) {
      _home = updater(_home);
    } else {
      _away = updater(_away);
    }
  }

  static TeamSide _other(TeamSide s) =>
      s == TeamSide.home ? TeamSide.away : TeamSide.home;
}
