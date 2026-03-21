// lib/features/match/engine/sim/sim_controller.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/match_state.dart';
import '../events/events.dart';
import '../outcomes/outcomes.dart';
import 'outcome_strategy.dart';

class SimController {
  SimController(
    this.read, {
    MatchState? initial,
    required OutcomeStrategy strategy,
  }) : _state = initial ?? MatchState.initial(),
       _strategy = strategy {
    _possession = _state.serverSide;
  }

  MatchState get state => _state;
  PassOutcome get lastPassOutcome => _strategy.lastPassOutcome;
  SetOutcome get lastSetOutcome => _strategy.lastSetOutcome;

  /// The team currently in possession (about to set/attack).
  /// Updated on every serve, dig, and rally reset — always current.
  TeamSide get possession => _possession;

  /// Quality of the transition touch from the last dug attack.
  /// Drives set options in the subsequent setting phase.
  TransitionOutcome get lastTransitionOutcome => _strategy.lastTransitionOutcome;

  /// True when the setter received the dug ball and cannot set next rally.
  bool get setterDidDig => _strategy.setterDidDig;
  AttackDirection get lastAttackDirection => _strategy.lastAttackDirection;
  AttackOutcome get lastAttackOutcome => _strategy.lastAttackOutcome;
  MatchState _state;

  final OutcomeStrategy _strategy;
  final Ref read;

  // Which team is currently in control of the ball (attacking next)?
  late TeamSide _possession;

  Future<({MatchState state, List<EngineEvent> events})> advance() async {
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
        {
          final so = await _strategy.getServeOutcome(s);
          if (so == null) return (state: s, events: events);

          if (so == ServeOutcome.fault) {
            // Serve fault → receiver gets point + rotation
            final receiver = _other(s.serverSide);
            final newScore = _addPoint(s.score, receiver);
            final nextTick = s.rotationTick + 1;
            final nextServer = receiver;

            events.add(
              EngineEvent.scoreChanged(
                home: newScore.home,
                away: newScore.away,
              ),
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
            // In-play serve → receiving side has possession
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
        }

      case MatchPhase.reception:
        {
          final po = await _strategy.getPassOutcome(s);
          if (po == null) return (state: s, events: events);

          if (po == PassOutcome.overpass || po == PassOutcome.shank) {
            // Serving team wins the point — same as an ace, no rotation change.
            final server = s.serverSide;
            final newScore = _addPoint(s.score, server);
            events.add(EngineEvent.scoreChanged(home: newScore.home, away: newScore.away));
            events.add(EngineEvent.rallyEnded(pointTo: server, rallyId: s.rallyId));
            s = s.copyWith(score: newScore, phase: MatchPhase.rallyEnd);
          } else {
            events.add(
              EngineEvent.phaseChanged(phase: MatchPhase.setting, rallyId: s.rallyId),
            );
            s = s.copyWith(phase: MatchPhase.setting);
          }
          break;
        }

      case MatchPhase.setting:
        {
          final so = await _strategy.getSetOutcome(s);
          if (so == null) return (state: s, events: events);

          // You could enqueue playerMove for hitters/setter here.
          events.add(
            EngineEvent.phaseChanged(
              phase: MatchPhase.attack,
              rallyId: s.rallyId,
            ),
          );
          s = s.copyWith(phase: MatchPhase.attack);
          break;
        }

      case MatchPhase.attack:
        {
          final atk = await _strategy.getAttackOutcome(s);
          if (atk == null) return (state: s, events: events);

          if (atk == AttackOutcome.kill) {
            final pointTo = _possession; // attacker scores
            final newScore = _addPoint(s.score, pointTo);
            final sideout = pointTo != s.serverSide;

            events.add(
              EngineEvent.scoreChanged(
                home: newScore.home,
                away: newScore.away,
              ),
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
          } else if (atk == AttackOutcome.error ||
              atk == AttackOutcome.blocked) {
            final pointTo = _other(_possession); // defender scores
            final newScore = _addPoint(s.score, pointTo);
            final sideout = pointTo != s.serverSide;

            events.add(
              EngineEvent.scoreChanged(
                home: newScore.home,
                away: newScore.away,
              ),
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
            // dug/continue → flip possession and go to dig phase
            _possession = _other(_possession);
            events.add(
              EngineEvent.phaseChanged(
                phase: MatchPhase.dig,
                rallyId: s.rallyId,
              ),
            );
            s = s.copyWith(phase: MatchPhase.dig);
          }
          break;
        }

      case MatchPhase.dig:
        // TransitionOutcome already stored in _lastPassOutcome by getAttackOutcome.
        // Advance to setting so getSetOutcome picks it up.
        events.add(
          EngineEvent.phaseChanged(phase: MatchPhase.setting, rallyId: s.rallyId),
        );
        s = s.copyWith(phase: MatchPhase.setting);
        break;

      case MatchPhase.rallyEnd:
        final setWinner = _checkSetWin(s);
        if (setWinner != null) {
          final newSetsHome = s.setsHome + (setWinner == TeamSide.home ? 1 : 0);
          final newSetsAway = s.setsAway + (setWinner == TeamSide.away ? 1 : 0);
          final matchOver = newSetsHome >= 3 || newSetsAway >= 3;

          if (matchOver) {
            events.add(EngineEvent.matchEnded(
              winner: setWinner,
              setsHome: newSetsHome,
              setsAway: newSetsAway,
              finalScoreHome: s.score.home,
              finalScoreAway: s.score.away,
            ));
            s = s.copyWith(
              setsHome: newSetsHome,
              setsAway: newSetsAway,
              isMatchOver: true,
            );
          } else {
            final nextSetNumber = s.setNumber + 1;
            final nextRally = s.rallyId + 1;
            // Winner of the set serves first in the next set.
            final nextTick = setWinner == TeamSide.home ? 0 : 1;
            events.add(EngineEvent.setEnded(
              winner: setWinner,
              setsHome: newSetsHome,
              setsAway: newSetsAway,
              setNumber: s.setNumber,
              finalScoreHome: s.score.home,
              finalScoreAway: s.score.away,
            ));
            events.add(EngineEvent.phaseChanged(
              phase: MatchPhase.preServe,
              rallyId: nextRally,
            ));
            s = s.copyWith(
              setsHome: newSetsHome,
              setsAway: newSetsAway,
              setNumber: nextSetNumber,
              score: const Score(),
              rotationTick: nextTick,
              serverSide: setWinner,
              phase: MatchPhase.preServe,
              rallyId: nextRally,
            );
          }
        } else {
          final nextRally = s.rallyId + 1;
          _possession = s.serverSide; // reset; will switch on inPlay
          events.add(
            EngineEvent.phaseChanged(
              phase: MatchPhase.preServe,
              rallyId: nextRally,
            ),
          );
          s = s.copyWith(phase: MatchPhase.preServe, rallyId: nextRally);
        }
        break;
    }

    _state = s;
    return (state: s, events: events);
  }
}

// ---------- helpers ----------
TeamSide? _checkSetWin(MatchState s) {
  final target = s.setNumber == 5 ? 15 : 25;
  if (s.score.home >= target && s.score.home - s.score.away >= 2) {
    return TeamSide.home;
  }
  if (s.score.away >= target && s.score.away - s.score.home >= 2) {
    return TeamSide.away;
  }
  return null;
}

TeamSide _other(TeamSide s) =>
    s == TeamSide.home ? TeamSide.away : TeamSide.home;

Score _addPoint(Score s, TeamSide to) => to == TeamSide.home
    ? s.copyWith(home: s.home + 1)
    : s.copyWith(away: s.away + 1);
