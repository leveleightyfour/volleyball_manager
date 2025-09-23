import '../state/match_state.dart';
import '../events/events.dart';
import '../outcomes/outcomes.dart';

/// Minimal deterministic controller driven by supplied outcomes.
/// Tracks ball possession, handles sideout/rotation correctly.
class SimController {
  SimController({MatchState? initial})
    : _state = initial ?? MatchState.initial() {
    _possession = _state.serverSide; // server starts with the ball each rally
  }

  MatchState get state => _state;
  MatchState _state;

  // Which team is currently in control of the ball (attacking next)?
  late TeamSide _possession;

  ({MatchState state, List<EngineEvent> events}) advance({
    required ManualInputs manual,
  }) {
    final events = <EngineEvent>[];
    var s = _state;

    switch (s.phase) {
      case MatchPhase.preServe:
        _possession = s.serverSide; // reset each rally
        events.add(
          EngineEvent.phaseChanged(phase: MatchPhase.serve, rallyId: s.rallyId),
        );
        events.add(
          EngineEvent.serveBallFlight(fromSide: s.serverSide, durationSec: 0.9),
        );
        s = s.copyWith(phase: MatchPhase.serve);
        break;

      case MatchPhase.serve:
        final so = manual.serveOutcome;
        if (so == null) return (state: s, events: events);

        if (so == ServeOutcome.ace) {
          final newScore = _addPoint(s.score, s.serverSide);
          events.add(
            EngineEvent.scoreChanged(home: newScore.home, away: newScore.away),
          );
          events.add(
            EngineEvent.rallyEnded(pointTo: s.serverSide, rallyId: s.rallyId),
          );
          s = s.copyWith(score: newScore, phase: MatchPhase.rallyEnd);
        } else if (so == ServeOutcome.fault) {
          final receiver = _other(s.serverSide);
          final newScore = _addPoint(s.score, receiver);
          final nextTick = s.rotationTick + 1; // sideout rotation
          final nextServer = receiver;
          events.add(
            EngineEvent.scoreChanged(home: newScore.home, away: newScore.away),
          );
          events.add(
            EngineEvent.rotationAdvanced(
              rotationTick: nextTick,
              serverSide: nextServer,
            ),
          );
          events.add(
            EngineEvent.rallyEnded(pointTo: receiver, rallyId: s.rallyId),
          );
          s = s.copyWith(
            score: newScore,
            rotationTick: nextTick,
            serverSide: nextServer,
            phase: MatchPhase.rallyEnd,
          );
        } else {
          // inPlay → receiving team has possession (they'll attack)
          _possession = _other(s.serverSide);
          events.add(
            EngineEvent.phaseChanged(
              phase: MatchPhase.reception,
              rallyId: s.rallyId,
            ),
          );
          s = s.copyWith(phase: MatchPhase.reception);
        }
        break;

      case MatchPhase.reception:
        if (manual.passOutcome == null) return (state: s, events: events);
        events.add(
          EngineEvent.phaseChanged(
            phase: MatchPhase.setting,
            rallyId: s.rallyId,
          ),
        );
        s = s.copyWith(phase: MatchPhase.setting);
        break;

      case MatchPhase.setting:
        if (manual.setOutcome == null) return (state: s, events: events);
        events.add(
          EngineEvent.phaseChanged(
            phase: MatchPhase.attack,
            rallyId: s.rallyId,
          ),
        );
        s = s.copyWith(phase: MatchPhase.attack);
        break;

      case MatchPhase.attack:
        final atk = manual.attackOutcome;
        if (atk == null) return (state: s, events: events);

        if (atk == AttackOutcome.kill) {
          final pointTo = _possession; // attacker scores
          final newScore = _addPoint(s.score, pointTo);
          final sideout =
              pointTo != s.serverSide; // receiving side won → flip serve

          events.add(
            EngineEvent.scoreChanged(home: newScore.home, away: newScore.away),
          );
          if (sideout) {
            final nextTick = s.rotationTick + 1;
            final nextServer = _other(s.serverSide);
            events.add(
              EngineEvent.rotationAdvanced(
                rotationTick: nextTick,
                serverSide: nextServer,
              ),
            );
            s = s.copyWith(rotationTick: nextTick, serverSide: nextServer);
          }
          events.add(
            EngineEvent.rallyEnded(pointTo: pointTo, rallyId: s.rallyId),
          );
          s = s.copyWith(score: newScore, phase: MatchPhase.rallyEnd);
        } else if (atk == AttackOutcome.error || atk == AttackOutcome.blocked) {
          final pointTo = _other(_possession); // defender scores
          final newScore = _addPoint(s.score, pointTo);
          final sideout = pointTo != s.serverSide;

          events.add(
            EngineEvent.scoreChanged(home: newScore.home, away: newScore.away),
          );
          if (sideout) {
            final nextTick = s.rotationTick + 1;
            final nextServer = _other(s.serverSide);
            events.add(
              EngineEvent.rotationAdvanced(
                rotationTick: nextTick,
                serverSide: nextServer,
              ),
            );
            s = s.copyWith(rotationTick: nextTick, serverSide: nextServer);
          }
          events.add(
            EngineEvent.rallyEnded(pointTo: pointTo, rallyId: s.rallyId),
          );
          s = s.copyWith(score: newScore, phase: MatchPhase.rallyEnd);
        } else {
          // dug → rally continues; possession flips and we go back to setting
          _possession = _other(_possession);
          events.add(
            EngineEvent.phaseChanged(
              phase: MatchPhase.setting,
              rallyId: s.rallyId,
            ),
          );
          s = s.copyWith(phase: MatchPhase.setting);
        }
        break;

      case MatchPhase.rallyEnd:
        final nextRally = s.rallyId + 1;
        _possession = s.serverSide; // reset; will switch on inPlay
        events.add(
          EngineEvent.phaseChanged(
            phase: MatchPhase.preServe,
            rallyId: nextRally,
          ),
        );
        s = s.copyWith(phase: MatchPhase.preServe, rallyId: nextRally);
        break;
    }

    _state = s;
    return (state: s, events: events);
  }
}

/// Inputs for a single step. Provide only what the current phase needs.
class ManualInputs {
  final ServeOutcome? serveOutcome;
  final PassOutcome? passOutcome;
  final SetOutcome? setOutcome;
  final AttackOutcome? attackOutcome;

  const ManualInputs({
    this.serveOutcome,
    this.passOutcome,
    this.setOutcome,
    this.attackOutcome,
  });
}

// ---------- helpers ----------
TeamSide _other(TeamSide s) =>
    s == TeamSide.home ? TeamSide.away : TeamSide.home;

Score _addPoint(Score s, TeamSide to) => to == TeamSide.home
    ? s.copyWith(home: s.home + 1)
    : s.copyWith(away: s.away + 1);
