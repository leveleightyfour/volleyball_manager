import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:volleyball_manager/features/player/data/dto/player_dto.dart';
import 'package:volleyball_manager/features/player/domain/skill_calculator.dart';
import 'package:volleyball_manager/core/db/database.dart';

import '../../state/match_state.dart';
import '../../state/match_roster.dart';
import '../../state/match_roster_provider.dart';
import '../../state/tactics_state.dart';
import '../outcomes/outcomes.dart';
import '../positions/receive_formation_calculator.dart';
import 'package:volleyball_manager/features/match/data/services/audit_log_service.dart';
import 'outcome_weights.dart';

abstract class OutcomeStrategy {
  Future<ServeOutcome?> getServeOutcome(MatchState s);
  Future<PassOutcome?> getPassOutcome(MatchState s);
  Future<SetOutcome?> getSetOutcome(MatchState s);
  Future<AttackOutcome?> getAttackOutcome(MatchState s);
  PassOutcome get lastPassOutcome;
  SetOutcome get lastSetOutcome;
  AttackDirection get lastAttackDirection;
  AttackOutcome get lastAttackOutcome;

  /// Quality of the transition touch computed during the last [getAttackOutcome]
  /// call that resulted in [AttackOutcome.dug].
  TransitionOutcome get lastTransitionOutcome;

  /// True when the setter received the dug ball and cannot set — a different
  /// player must take over as setter for this transition.
  bool get setterDidDig;
}

class EngineOutcomeStrategy implements OutcomeStrategy {
  EngineOutcomeStrategy(this.ref, {int? seed}) : _rng = Random(seed);

  final Ref ref;
  final Random _rng;

  Future<OutcomeWeights> _getWeights() => OutcomeWeights.load();

  // ── Per-rally internal state ─────────────────────────────────────────────
  // Reset whenever the rallyId changes. Allows downstream phases to use
  // results from upstream phases without changing MatchState shape.

  int? _currentRallyId;
  PassOutcome _lastPassOutcome = PassOutcome.average;
  SetOutcome _lastSetOutcomeExposed = SetOutcome.leftSideHigh;

  @override
  PassOutcome get lastPassOutcome => _lastPassOutcome;

  @override
  SetOutcome get lastSetOutcome => _lastSetOutcomeExposed;
  SetOutcome _lastSetOutcome = SetOutcome.leftSideHigh;
  AttackDirection _lastAttackDirection = AttackDirection.ohLine;
  AttackOutcome _lastAttackOutcome = AttackOutcome.kill;

  @override
  AttackDirection get lastAttackDirection => _lastAttackDirection;

  @override
  AttackOutcome get lastAttackOutcome => _lastAttackOutcome;

  TransitionOutcome _lastTransitionOutcome = TransitionOutcome.average;
  bool _setterDidDig = false;
  int _lastBlockerCount = 0;

  @override
  TransitionOutcome get lastTransitionOutcome => _lastTransitionOutcome;

  @override
  bool get setterDidDig => _setterDidDig;
  // Track which side has possession (set when serve goes inPlay)
  TeamSide? _possessionSide;
  // Serve vs reception differential carried into the pass phase to drive shank probability.
  double _serveDifferential = 0.0;
  // Server reference kept for ace attribution on a shank.
  PlayerDto? _lastServer;
  // Serve zone carried into the pass phase for passer selection.
  String _lastServeZone = 'zone6';

  void _resetIfNewRally(int rallyId) {
    if (_currentRallyId != rallyId) {
      _currentRallyId = rallyId;
      _lastPassOutcome = PassOutcome.average;
      _lastSetOutcome = SetOutcome.leftSideHigh;
      _lastSetOutcomeExposed = SetOutcome.leftSideHigh;
      _lastAttackDirection = AttackDirection.ohLine;
      _lastTransitionOutcome = TransitionOutcome.average;
      _setterDidDig = false;
      _lastBlockerCount = 0;
      _possessionSide = null;
      _serveDifferential = 0.0;
      _lastServer = null;
      _lastServeZone = 'zone6';
    }
  }

  // ── Skill + Curve helpers ────────────────────────────────────────────────

  Future<SkillCalculator?> _getSkillCalc() async {
    try {
      final db = ref.read(databaseProvider);
      final rows = await db.select(db.skillFormulas).get();
      final map = {for (final r in rows) r.skillKey: r};
      return SkillCalculator(map);
    } catch (_) {
      return null;
    }
  }

  Future<OutcomeCalculator?> _getOutcomeCalc() async {
    try {
      final db = ref.read(databaseProvider);
      final curves = await db.select(db.outcomeCurves).get();
      return OutcomeCalculator(curves);
    } catch (_) {
      return null;
    }
  }

  double _calcSkill(
      SkillCalculator? calc, String key, PlayerDto? player, double fallback) {
    if (calc == null || player == null) return fallback;
    try {
      return calc.calculateSkill(key, player);
    } catch (_) {
      return fallback;
    }
  }

  Map<String, double> _getProbs(
      OutcomeCalculator? calc, String matchupKey, double differential) {
    if (calc == null) return {};
    try {
      return calc.getOutcomeProbabilities(
          matchupKey: matchupKey, differential: differential);
    } catch (_) {
      return {};
    }
  }

  int _rotationIndex(TeamSide side, int rotationTick) {
    final sideouts =
        side == TeamSide.home ? rotationTick ~/ 2 : (rotationTick + 1) ~/ 2;
    return (sideouts % 6) + 1;
  }

  TeamSide _other(TeamSide s) =>
      s == TeamSide.home ? TeamSide.away : TeamSide.home;

  double _roll() => _rng.nextDouble();

  // Pick a weighted outcome from a probability map.
  String _pickFromMap(Map<String, double> probs, List<String> order) {
    var r = _roll();
    for (final key in order) {
      final p = probs[key] ?? 0.0;
      if (r < p) return key;
      r -= p;
    }
    return order.last;
  }

  // ── Serve ────────────────────────────────────────────────────────────────

  @override
  Future<ServeOutcome?> getServeOutcome(MatchState s) async {
    _resetIfNewRally(s.rallyId);

    final roster = ref.read(matchRosterCacheProvider);
    final calc = await _getSkillCalc();
    final outcomeCalc = await _getOutcomeCalc();
    final audit = ref.read(auditLogServiceProvider);

    final rotIdx = _rotationIndex(s.serverSide, s.rotationTick);
    final server = roster.getServer(s.serverSide, rotIdx);

    // Serve type from skill dominance
    final jumpSkill = _calcSkill(calc, 'serveJumpServe', server, 12.0);
    final floatSkill = _calcSkill(calc, 'serveJumpFloat', server, 10.0);
    final prefersJump = jumpSkill >= floatSkill;
    final serveSkill = prefersJump ? jumpSkill : floatSkill;
    final serveSkillKey =
        prefersJump ? 'serveJumpServe' : 'serveJumpFloat';
    final recvSkillKey =
        prefersJump ? 'receptionJumpServe' : 'receptionJumpFloat';

    // Serve zone
    final recvSide = _other(s.serverSide);
    final recvRot = _rotationIndex(recvSide, s.rotationTick);
    final spec = ref.read(tacticsProvider.notifier).getSpec(recvSide, recvRot);
    final zones = _serveZonesForNumPassers(spec.numPassers);
    final zone = zones[_rng.nextInt(zones.length)];

    // Primary receiver — chosen by serve zone so skill comparison is accurate.
    final receiver = roster.getPasserForZone(
        recvSide, spec.passingRoles.toList(), zone, _rng);
    final recvSkill = _calcSkill(calc, recvSkillKey, receiver, 10.0);

    final differential = serveSkill - recvSkill;

    // Store for use in the pass phase.
    _serveDifferential = differential;
    _lastServer = server;
    _lastServeZone = zone;

    final rawProbs = _getProbs(outcomeCalc, 'serve_vs_reception', differential);
    // The curve may use legacy keys (ace/error/good/perfect). Remap to the
    // current two-outcome model: error → fault, everything else → in_play.
    final Map<String, double> resolved;
    if (rawProbs.isNotEmpty) {
      final fault  = rawProbs['error'] ?? 0.0;
      final inPlay = (rawProbs['ace'] ?? 0.0) +
                     (rawProbs['good'] ?? 0.0) +
                     (rawProbs['perfect'] ?? 0.0) +
                     (rawProbs['in_play'] ?? 0.0);
      resolved = {'fault': fault, 'in_play': inPlay > 0 ? inPlay : 1.0 - fault};
    } else {
      resolved = _fallbackServeProbs(differential);
    }

    // Serve only resolves to fault or in_play.
    // Any ace probability is folded into in_play; aces emerge from shanks in
    // the pass phase instead.
    final pick = _pickFromMap(resolved, ['fault', 'in_play']);
    final result = pick == 'fault' ? ServeOutcome.fault : ServeOutcome.inPlay;

    if (result == ServeOutcome.inPlay) {
      _possessionSide = recvSide;
    }

    await audit.logServeOutcome(
      state: s,
      result: pick,
      server: server,
      serverSkill: serveSkill,
      serverSkillKey: serveSkillKey,
      receiver: receiver,
      receiverSkill: recvSkill,
      receiverSkillKey: recvSkillKey,
      differential: differential,
      probabilities: resolved,
      serveZone: zone,
    );

    return result;
  }

  List<String> _serveZonesForNumPassers(int n) => switch (n) {
        2 => ['seam16', 'seam56', 'zone1', 'zone5'],
        4 => ['zone1', 'zone5', 'zone6'],
        _ => ['zone1', 'zone5', 'zone6', 'seam16'],
      };

  Map<String, double> _fallbackServeProbs(double diff) {
    // Fault probability only — in_play is the complement.
    if (diff > 3)  return {'fault': 0.05, 'in_play': 0.95};
    if (diff < -3) return {'fault': 0.12, 'in_play': 0.88};
    return {'fault': 0.08, 'in_play': 0.92};
  }

  // ── Pass / Reception ─────────────────────────────────────────────────────

  @override
  Future<PassOutcome?> getPassOutcome(MatchState s) async {
    final roster = ref.read(matchRosterCacheProvider);
    final calc = await _getSkillCalc();
    final audit = ref.read(auditLogServiceProvider);

    final recvSide = _possessionSide ?? _other(s.serverSide);
    final recvRot = _rotationIndex(recvSide, s.rotationTick);
    final spec = ref.read(tacticsProvider.notifier).getSpec(recvSide, recvRot);

    // Passer selected by the zone the serve was aimed at.
    final passer = roster.getPasserForZone(
        recvSide, spec.passingRoles.toList(), _lastServeZone, _rng);

    // Serve type determines reception skill key
    final serverRot = _rotationIndex(s.serverSide, s.rotationTick);
    final server = roster.getServer(s.serverSide, serverRot);
    final jumpSkill = _calcSkill(calc, 'serveJumpServe', server, 12.0);
    final floatSkill = _calcSkill(calc, 'serveJumpFloat', server, 10.0);
    final recvSkillKey = jumpSkill >= floatSkill
        ? 'receptionJumpServe'
        : 'receptionJumpFloat';

    final passerSkill = _calcSkill(calc, recvSkillKey, passer, 10.0);

    final (basePerfect, baseAvg, baseSingle) = switch (spec.numPassers) {
      2 => (0.20, 0.40, 0.25),
      3 => (0.35, 0.40, 0.18),
      4 => (0.42, 0.38, 0.14),
      _ => (0.33, 0.40, 0.20),
    };

    final skillMod = (passerSkill - 10.0) * 0.015;
    final pPerf   = (basePerfect + skillMod).clamp(0.05, 0.70);
    final pSingle = (baseSingle  - skillMod * 0.5).clamp(0.02, 0.40);

    // Shank probability rises with serve advantage; only when server is ahead.
    // Each point of differential above 0 adds ~1.3%, capped at 18%.
    final pShank = (_serveDifferential * 0.013).clamp(0.0, 0.18);

    // Remaining budget for overpass after allocating to shank.
    final pOverpass = (1.0 - pPerf - baseAvg - pSingle - pShank).clamp(0.01, 0.20);

    final r = _roll();
    final PassOutcome out;
    if (r < pPerf) {
      out = PassOutcome.perfect;
    } else if (r < pPerf + baseAvg) {
      out = PassOutcome.average;
    } else if (r < pPerf + baseAvg + pSingle) {
      out = PassOutcome.singleOption;
    } else if (r < pPerf + baseAvg + pSingle + pOverpass) {
      out = PassOutcome.overpass;
    } else {
      // Shank — attributed as an ace to the server.
      out = PassOutcome.shank;
    }

    _lastPassOutcome = out;

    await audit.logPassOutcome(
      state: s,
      passingSide: recvSide,
      result: out.name,
      passer: passer,
      passerSkill: passerSkill,
      skillKey: recvSkillKey,
      numPassers: spec.numPassers,
      modifiedProbPerfect: pPerf,
      server: _lastServer,
      serverSide: s.serverSide,
    );

    return out;
  }

  // ── Set ──────────────────────────────────────────────────────────────────

  /// Returns rotation index 1–6 for [side] given the current [MatchState].
  static int _rotationFor(MatchState s, TeamSide side) {
    final offset = side == TeamSide.home
        ? (s.rotationTick ~/ 2)
        : ((s.rotationTick + 1) ~/ 2);
    return (offset % 6) + 1;
  }

  @override
  Future<SetOutcome?> getSetOutcome(MatchState s) async {
    final roster = ref.read(matchRosterCacheProvider);
    final calc = await _getSkillCalc();
    final audit = ref.read(auditLogServiceProvider);

    final attackingSide = _possessionSide ?? _other(s.serverSide);

    // Consume setter-did-dig flag; reset so it doesn't carry into the next set.
    final wasSetterDig = _setterDidDig;
    _setterDidDig = false;

    // Determine who's setting and which options are available.
    final PlayerDto? setter;
    final Map<String, double> options;

    final rotation = _rotationFor(s, attackingSide);
    final frontRow = ReceiveFormationCalculator.frontRowRolesFor(rotation);
    final isSetterFront = frontRow.contains('S');
    final isOppFront = frontRow.contains('OPP');

    if (wasSetterDig) {
      if (_lastBlockerCount >= 2) {
        // 2-3 blockers: use the tactics-configured backup setter.
        final backupTag =
            ref.read(tacticsProvider.notifier).getBackupSetter(attackingSide);
        setter = roster.getByRole(attackingSide, backupTag) ??
            roster.getSetter(attackingSide);
        options = _setOptionsForPassQuality(
          _lastPassOutcome,
          isSetterFront: isSetterFront,
          isOppFront: isOppFront,
          serveZone: _lastServeZone,
        );
      } else {
        // 1 blocker: emergency setter, forced to one outside option.
        setter = _pickRandomNonSetter(roster, attackingSide);
        options = _singleOutsideOptions(isOppFront);
      }
    } else {
      setter = roster.getSetter(attackingSide);
      options = _setOptionsForPassQuality(
        _lastPassOutcome,
        isSetterFront: isSetterFront,
        isOppFront: isOppFront,
        serveZone: _lastServeZone,
      );
    }

    final passQ = _lastPassOutcome;

    double total = 0.0;
    final weights = <String, double>{};
    for (final opt in options.entries) {
      final setterSkill = _calcSkill(calc, opt.key, setter, 10.0);
      final w = opt.value * (setterSkill / 10.0).clamp(0.5, 2.0);
      weights[opt.key] = w;
      total += w;
    }

    var r = _roll();
    String pickedSkillKey = options.keys.last;
    for (final entry in weights.entries) {
      final norm = entry.value / total;
      if (r < norm) { pickedSkillKey = entry.key; break; }
      r -= norm;
    }

    final out = _setOutcomeFromSkillKey(pickedSkillKey);
    _lastSetOutcome = out;
    _lastSetOutcomeExposed = out;

    final setterSkill = _calcSkill(calc, pickedSkillKey, setter, 10.0);

    await audit.logSetOutcome(
      state: s,
      attackingSide: attackingSide,
      result: out.name,
      setter: setter,
      setterSkill: setterSkill,
      skillKey: pickedSkillKey,
      passQuality: passQ.name,
      weights: weights,
    );

    return out;
  }

  /// Returns the weighted skill-key options available for this pass quality.
  ///
  /// [isSetterFront] — setter is in the front row (enables tip).
  /// [isOppFront]    — OPP is in the front row (right-side = pos 2, else pos 1).
  /// [serveZone]     — zone the serve was aimed at; used to constrain singleOption side.
  Map<String, double> _setOptionsForPassQuality(
    PassOutcome passQ, {
    required bool isSetterFront,
    required bool isOppFront,
    required String serveZone,
  }) {
    // Right-side option depends on OPP position.
    // Backrow/pipe require setter to be front-court; otherwise fall back to left-side.
    final rightTempoKey = isOppFront
        ? 'setRightSideTempo'
        : (isSetterFront ? 'setBackRow' : 'setLeftSideTempo');
    final rightHighKey = isOppFront
        ? 'setRightSideHigh'
        : (isSetterFront ? 'setBackRow' : 'setLeftSideHigh');

    return switch (passQ) {
      // Perfect → all options; tip and pipe only when setter is front court.
      PassOutcome.perfect => {
          'setLeftSideTempo': 0.25,
          rightTempoKey: 0.20,
          'setMiddle': 0.25,
          if (isSetterFront) 'setPipe': 0.10,
          'setLeftSideHigh': 0.10,
          if (isSetterFront) 'setTip': 0.10,
        },
      // Average → both wide tempo options; high ball also available.
      PassOutcome.average => {
          'setLeftSideTempo': 0.40,
          rightTempoKey: 0.40,
          'setLeftSideHigh': 0.20,
        },
      // Single option — the forced side is determined by where the serve went:
      //   zone5 / seam56 → ball stayed left  → setter forced to leftSideHigh
      //   zone1 / seam16 → ball stayed right → setter forced to rightSideHigh
      //   zone6 (centre) → either side plausible → random 50/50
      PassOutcome.singleOption => switch (serveZone) {
          'zone5' || 'seam56' => {'setLeftSideHigh': 1.0},
          'zone1' || 'seam16' => {rightHighKey: 1.0},
          _ => {if (_rng.nextBool()) 'setLeftSideHigh': 1.0 else rightHighKey: 1.0},
        },
      // Overpass / shank end the rally before setting — should never reach here.
      _ => {'setLeftSideHigh': 1.0},
    };
  }

  SetOutcome _setOutcomeFromSkillKey(String key) => switch (key) {
        'setMiddle'          => SetOutcome.middle,
        'setLeftSideTempo'    => SetOutcome.leftSideTempo,
        'setLeftSideHigh'     => SetOutcome.leftSideHigh,
        'setRightSideTempo'  => SetOutcome.rightSideTempo,
        'setRightSideHigh'   => SetOutcome.rightSideHigh,
        'setBackRow'         => SetOutcome.backrow,
        'setPipe'            => SetOutcome.pipe,
        'setTip'             => SetOutcome.tip,
        _                    => SetOutcome.leftSideHigh,
      };

  // ── Attack ───────────────────────────────────────────────────────────────

  @override
  Future<AttackOutcome?> getAttackOutcome(MatchState s) async {
    final roster = ref.read(matchRosterCacheProvider);
    final calc = await _getSkillCalc();
    final outcomeCalc = await _getOutcomeCalc();
    final weights = await _getWeights();
    final audit = ref.read(auditLogServiceProvider);

    final attackingSide = _possessionSide ?? _other(s.serverSide);
    final defendingSide = _other(attackingSide);
    final set = _lastSetOutcome;

    final attacker = roster.getAttacker(attackingSide, set);

    // Skill-adjusted blocker quality:
    //   perfect pass  → MB read-blocking can upgrade 1→2 blockers
    //   average pass  → wing blocker read can upgrade 2→3 blockers
    final effectivePassQ = _adjustBlockerQuality(
      _lastPassOutcome, roster, defendingSide, set, calc, weights,
    );
    final blockers = roster.getBlockers(defendingSide, set, effectivePassQ);
    _lastBlockerCount = blockers.length;

    final attackSkillKey = _attackSkillKey(set);
    final attackerSkill = _calcSkill(calc, attackSkillKey, attacker, 12.0);

    final blockSkillKey = _blockSkillKey(set, blockers.length);
    final rawBlockAggregate = blockers.isEmpty
        ? 0.0
        : blockers
                .map((b) => _calcSkill(calc, blockSkillKey, b, 10.0))
                .reduce((a, b) => a + b) /
            blockers.length;
    final blockAggregate = blockers.length == 3
        ? rawBlockAggregate * weights.tripleBlockBonus
        : rawBlockAggregate;

    final atkVsBlockDiff = attackerSkill - blockAggregate;
    final blockProbs = _getProbs(outcomeCalc, 'attack_vs_block', atkVsBlockDiff);
    final resolvedBlockProbs = blockProbs.isNotEmpty
        ? blockProbs
        : _fallbackBlockProbs(atkVsBlockDiff);

    final dir = _pickAttackDirection(attacker, set, _lastPassOutcome);
    _lastAttackDirection = dir;

    String finalPick;
    Map<String, double> defProbs = {};
    double defAggregate = 0.0;
    double atkVsDefDiff = 0.0;
    List<PlayerDto> defenders = [];

    if (dir == AttackDirection.atBlock) {
      // ── Attack aimed at the block: tool / stuff / partial comparison ──────
      final rawTouchProbs = _getProbs(outcomeCalc, 'attack_vs_block_touch', atkVsBlockDiff);
      final touchProbs = rawTouchProbs.isNotEmpty
          ? rawTouchProbs
          : _fallbackBlockTouchProbs(atkVsBlockDiff);
      final touchPick = _pickFromMap(touchProbs, ['tool', 'partial', 'stuff']);
      switch (touchPick) {
        case 'tool':
          // Attacker wipes the block edge → point to attacker.
          finalPick = 'kill';
        case 'partial':
          // Block deflects ball back into defending side → freeball to dig.
          finalPick = 'dug';
          _lastTransitionOutcome = TransitionOutcome.freeball;
          _lastPassOutcome = TransitionOutcome.freeball.toPassOutcome();
          _lastServeZone = 'zone6';
          _possessionSide = defendingSide;
        default: // 'stuff'
          // Blocker cleans the ball → point to defender.
          finalPick = 'blocked';
      }
    } else {
      // ── Standard block comparison ─────────────────────────────────────────
      final blockPick =
          _pickFromMap(resolvedBlockProbs, ['kill', 'blocked', 'dug', 'error']);
      finalPick = blockPick;

      if (blockPick == 'dug') {
        // Ball got through the block — compare attack vs floor defence.
        defenders = roster.getDefenders(defendingSide, dir, blockers.length);
        final defSkillKey = _defenceSkillKey(set);
        defAggregate = defenders.isEmpty
            ? 8.0
            : defenders
                    .map((d) => _calcSkill(calc, defSkillKey, d, 10.0))
                    .reduce((a, b) => a + b) /
                defenders.length;
        atkVsDefDiff = attackerSkill - defAggregate;
        defProbs = _getProbs(outcomeCalc, 'attack_vs_defense', atkVsDefDiff);
        final resolvedDefProbs =
            defProbs.isNotEmpty ? defProbs : _fallbackDefProbs(atkVsDefDiff);
        finalPick = _pickFromMap(resolvedDefProbs, ['kill', 'dug', 'error']);

        if (finalPick == 'dug') {
          // Compute transition quality from how hard the dig was.
          _lastTransitionOutcome = _computeTransitionOutcome(atkVsDefDiff, weights);
          // Update pass quality so getSetOutcome sees transition options.
          _lastPassOutcome = _lastTransitionOutcome.toPassOutcome();
          // Reset serve zone so singleOption is not biased by the original serve.
          _lastServeZone = 'zone6';
          _possessionSide = defendingSide;
          // Check if the setter was in position to dig (back row, or front row
          // on a sharp-cross attack aimed at their zone).
          final defRot = _rotationFor(s, defendingSide);
          if (_setterCanDig(dir, defRot)) _setterDidDig = true;
        }
      }
    }

    final out = switch (finalPick) {
      'kill'    => AttackOutcome.kill,
      'blocked' => AttackOutcome.blocked,
      'error'   => AttackOutcome.error,
      _         => AttackOutcome.dug,
    };

    _lastAttackOutcome = out;

    // For non-atBlock dug the possession is set above; guard against double-set.
    if (out == AttackOutcome.dug && _possessionSide != defendingSide) {
      _possessionSide = defendingSide;
    }

    await audit.logAttackOutcome(
      state: s,
      attackingSide: attackingSide,
      result: finalPick,
      attacker: attacker,
      attackerSkill: attackerSkill,
      attackerSkillKey: attackSkillKey,
      blockers: blockers,
      blockAggregate: blockAggregate,
      atkVsBlockDiff: atkVsBlockDiff,
      atkVsBlockProbs: resolvedBlockProbs,
      defenders: defenders,
      defAggregate: defAggregate,
      atkVsDefDiff: atkVsDefDiff,
      atkVsDefProbs: defProbs.isNotEmpty ? defProbs : _fallbackDefProbs(atkVsDefDiff),
      attackDirection: dir.name,
      setOutcome: set.name,
    );

    return out;
  }

  String _attackSkillKey(SetOutcome set) => switch (set) {
        SetOutcome.middle         => 'attackMiddle',
        SetOutcome.leftSideTempo   => 'attackLeftSideTempo',
        SetOutcome.leftSideHigh    => 'attackLeftSideHigh',
        SetOutcome.rightSideTempo => 'attackLeftSideTempo',
        SetOutcome.rightSideHigh  => 'attackLeftSideHigh',
        SetOutcome.backrow        => 'attackBackRow',
        SetOutcome.pipe           => 'attackBackRow',
        SetOutcome.tip            => 'attackLeftSideTempo',
      };

  String _blockSkillKey(SetOutcome set, int blockerCount) => switch (set) {
        SetOutcome.leftSideHigh || SetOutcome.leftSideTempo =>
          blockerCount <= 1 ? 'blockLeftSideTempo' : 'blockLeftSideHigh',
        SetOutcome.rightSideHigh || SetOutcome.rightSideTempo =>
          blockerCount <= 1 ? 'blockRightSideTempo' : 'blockRightSideHigh',
        SetOutcome.middle  => 'blockMiddle',
        SetOutcome.backrow => 'blockRightSideHigh',
        SetOutcome.pipe    => 'blockMiddle',
        SetOutcome.tip     => 'blockLeftSideHigh',
      };

  String _defenceSkillKey(SetOutcome set) => switch (set) {
        SetOutcome.middle         => 'defendMiddle',
        SetOutcome.leftSideTempo   => 'defendLeftSideTempo',
        SetOutcome.leftSideHigh    => 'defendLeftSideHigh',
        SetOutcome.rightSideTempo => 'defendBackRow',
        SetOutcome.rightSideHigh  => 'defendBackRow',
        SetOutcome.backrow        => 'defendBackRow',
        SetOutcome.pipe           => 'defendBackRow',
        SetOutcome.tip            => 'defendLeftSideHigh',
      };

  AttackDirection _pickAttackDirection(
      PlayerDto? attacker, SetOutcome set, PassOutcome passQuality) {
    final vision = attacker?.vision ?? 10;
    final versatility = attacker?.versatility ?? 10;

    final available = _attackDirectionsFor(set, passQuality);
    final weights = {
      for (final dir in available) dir: _directionWeight(dir, vision, versatility),
    };
    final total = weights.values.reduce((a, b) => a + b);
    var r = _roll();
    for (final entry in weights.entries) {
      final norm = entry.value / total;
      if (r < norm) return entry.key;
      r -= norm;
    }
    return available.last;
  }

  /// Available attack directions driven by set type × pass quality.
  ///
  /// Perfect = 1 blocker, average = 2 blockers, single option = 3 blockers.
  List<AttackDirection> _attackDirectionsFor(
      SetOutcome set, PassOutcome passQuality) {
    return switch ((set, passQuality)) {
      // ── Perfect pass (1 blocker) ────────────────────────────────────────
      (SetOutcome.middle, PassOutcome.perfect) => [
          AttackDirection.middleZone1,
          AttackDirection.atBlock,
          AttackDirection.middleZone5,
        ],
      (SetOutcome.leftSideTempo || SetOutcome.leftSideHigh,
        PassOutcome.perfect) => [
          AttackDirection.ohLine,
          AttackDirection.atBlock,
          AttackDirection.ohCrossShallow,
          AttackDirection.ohCrossSharp,
        ],
      (SetOutcome.rightSideTempo || SetOutcome.rightSideHigh,
        PassOutcome.perfect) => [
          AttackDirection.oppLine,
          AttackDirection.atBlock,
          AttackDirection.oppCrossShallow,
          AttackDirection.oppCrossSharp,
        ],
      (SetOutcome.pipe, PassOutcome.perfect) => [
          AttackDirection.middleZone6,
          AttackDirection.atBlock,
          AttackDirection.middleZone1,
          AttackDirection.middleZone5,
        ],
      (SetOutcome.backrow, PassOutcome.perfect) => [
          AttackDirection.oppLine,
          AttackDirection.atBlock,
          AttackDirection.oppCrossShallow,
          AttackDirection.oppCrossSharp,
        ],
      (SetOutcome.tip, PassOutcome.perfect) => [
          AttackDirection.atBlock,
          AttackDirection.ohCrossShallow,
        ],
      // ── Average pass (2 blockers) ───────────────────────────────────────
      (SetOutcome.middle, PassOutcome.average) => [
          AttackDirection.middleZone1,
          AttackDirection.atBlock,
          AttackDirection.middleZone5,
        ],
      (SetOutcome.leftSideTempo || SetOutcome.leftSideHigh,
        PassOutcome.average) => [
          AttackDirection.ohLine,
          AttackDirection.atBlock,
          AttackDirection.ohCrossShallow,
        ],
      (SetOutcome.rightSideTempo || SetOutcome.rightSideHigh,
        PassOutcome.average) => [
          AttackDirection.oppLine,
          AttackDirection.atBlock,
          AttackDirection.oppCrossShallow,
        ],
      (SetOutcome.pipe, PassOutcome.average) => [
          AttackDirection.middleZone6,
          AttackDirection.atBlock,
          AttackDirection.middleZone1,
        ],
      (SetOutcome.backrow, PassOutcome.average) => [
          AttackDirection.oppLine,
          AttackDirection.atBlock,
          AttackDirection.oppCrossShallow,
        ],
      (SetOutcome.tip, PassOutcome.average) => [
          AttackDirection.atBlock,
          AttackDirection.ohCrossShallow,
        ],
      // ── Single option (3 blockers) ──────────────────────────────────────
      (SetOutcome.middle, PassOutcome.singleOption) => [
          AttackDirection.atBlock,
        ],
      (SetOutcome.leftSideTempo || SetOutcome.leftSideHigh,
        PassOutcome.singleOption) => [
          AttackDirection.atBlock,
          AttackDirection.ohCrossShallow,
        ],
      (SetOutcome.rightSideTempo || SetOutcome.rightSideHigh,
        PassOutcome.singleOption) => [
          AttackDirection.atBlock,
          AttackDirection.oppCrossShallow,
        ],
      (SetOutcome.pipe || SetOutcome.backrow, PassOutcome.singleOption) => [
          AttackDirection.atBlock,
          AttackDirection.middleZone6,
        ],
      (SetOutcome.tip, PassOutcome.singleOption) => [AttackDirection.atBlock],
      // ── Fallback ────────────────────────────────────────────────────────
      _ => [
          AttackDirection.ohLine,
          AttackDirection.atBlock,
          AttackDirection.ohCrossShallow,
        ],
    };
  }

  double _directionWeight(AttackDirection dir, int vision, int versatility) =>
      switch (dir) {
        AttackDirection.ohLine || AttackDirection.oppLine =>
          (0.30 + (vision - 10) * 0.02).clamp(0.10, 0.55),
        AttackDirection.ohCrossShallow || AttackDirection.oppCrossShallow =>
          (0.35 + (versatility - 10) * 0.015).clamp(0.10, 0.55),
        AttackDirection.ohCrossSharp || AttackDirection.oppCrossSharp =>
          (0.15 + (vision - 10) * 0.02 + (versatility - 10) * 0.02)
              .clamp(0.05, 0.40),
        AttackDirection.middleZone1 || AttackDirection.middleZone5 =>
          (0.30 + (vision - 10) * 0.02).clamp(0.10, 0.55),
        AttackDirection.middleZone6 =>
          (0.25 + (versatility - 10) * 0.015).clamp(0.10, 0.45),
        AttackDirection.atBlock =>
          (0.25 - (vision - 10) * 0.015).clamp(0.05, 0.40),
      };

  /// Adjusts the pass quality used for blocker-count selection based on
  /// skill matchups between the blocking and attacking teams.
  ///
  /// - **perfect → average** (1→2 blockers): defending MB's read-blocking
  ///   skill vs attacking setter's tempo-setting speed.
  /// - **average → singleOption** (2→3 blockers): wing blocker's block skill
  ///   vs attacker's attack skill (harder attack = less time to read and join).
  PassOutcome _adjustBlockerQuality(
    PassOutcome passQ,
    MatchRoster roster,
    TeamSide defendingSide,
    SetOutcome set,
    SkillCalculator? calc,
    OutcomeWeights weights,
  ) {
    final attackingSide = _other(defendingSide);

    if (passQ == PassOutcome.perfect) {
      final mb = roster.getByRole(defendingSide, 'MB1');
      final setter = roster.getSetter(attackingSide);
      final mbSkill = _calcSkill(calc, 'blockMiddle', mb, 10.0);
      final sSkill = _calcSkill(calc, 'setLeftSideTempo', setter, 10.0);
      final prob = (weights.mbBaseProb + (mbSkill - sSkill) * weights.mbSkillFactor)
          .clamp(0.05, 0.65);
      if (_roll() < prob) return PassOutcome.average;
    } else if (passQ == PassOutcome.average) {
      final wingTag = switch (set) {
        SetOutcome.leftSideHigh || SetOutcome.leftSideTempo   => 'OH2',
        SetOutcome.rightSideHigh || SetOutcome.rightSideTempo => 'OH1',
        SetOutcome.middle                                      => 'MB2',
        _                                                      => 'OH2',
      };
      final wingBlocker = roster.getByRole(defendingSide, wingTag);
      final attacker = roster.getAttacker(attackingSide, set);
      final wingSkill = _calcSkill(calc, _blockSkillKey(set, 2), wingBlocker, 10.0);
      final atkSkill = _calcSkill(calc, _attackSkillKey(set), attacker, 12.0);
      final prob = (weights.wingBaseProb + (wingSkill - atkSkill) * weights.wingSkillFactor)
          .clamp(0.05, 0.55);
      if (_roll() < prob) return PassOutcome.singleOption;
    }

    return passQ;
  }

  Map<String, double> _fallbackBlockProbs(double diff) {
    if (diff > 3)  return {'kill': 0.35, 'blocked': 0.10, 'dug': 0.40, 'error': 0.15};
    if (diff < -3) return {'kill': 0.18, 'blocked': 0.22, 'dug': 0.45, 'error': 0.15};
    return {'kill': 0.25, 'blocked': 0.15, 'dug': 0.45, 'error': 0.15};
  }

  Map<String, double> _fallbackDefProbs(double diff) {
    if (diff > 3)  return {'kill': 0.40, 'dug': 0.40, 'error': 0.20};
    if (diff < -3) return {'kill': 0.22, 'dug': 0.58, 'error': 0.20};
    return {'kill': 0.30, 'dug': 0.50, 'error': 0.20};
  }

  // Probabilities for an attack aimed directly at the block.
  // Higher attacker-vs-block diff = more likely to tool or deflect (partial),
  // less likely to be stuffed cleanly.
  Map<String, double> _fallbackBlockTouchProbs(double atkVsBlockDiff) {
    if (atkVsBlockDiff > 3)  return {'tool': 0.40, 'partial': 0.40, 'stuff': 0.20};
    if (atkVsBlockDiff < -3) return {'tool': 0.10, 'partial': 0.28, 'stuff': 0.62};
    return {'tool': 0.25, 'partial': 0.38, 'stuff': 0.37};
  }

  // ── Setter-did-dig helpers ───────────────────────────────────────────────

  /// True when the setter was realistically positioned to dig the ball.
  ///
  /// A back-row setter (R1–R3) always covers the floor.
  /// A front-row setter can only dig a sharp-cross attack aimed at their zone:
  ///   zone 2 (R6, right-front) → ohCrossSharp lands near them.
  ///   zone 4 (R4, left-front)  → oppCrossSharp lands near them.
  bool _setterCanDig(AttackDirection dir, int rotationIndex) {
    final frontRow = ReceiveFormationCalculator.frontRowRolesFor(rotationIndex);
    if (!frontRow.contains('S')) return true; // setter in back row
    final zoneMap = ReceiveFormationCalculator.frontRowZoneMapFor(rotationIndex);
    final setterZone = zoneMap['S'];
    if (setterZone == 2 && dir == AttackDirection.ohCrossSharp) return true;
    if (setterZone == 4 && dir == AttackDirection.oppCrossSharp) return true;
    return false;
  }

  /// Picks a random non-setter player from [side]'s roster.
  /// Falls back to the setter if no other player is found.
  PlayerDto? _pickRandomNonSetter(MatchRoster roster, TeamSide side) {
    const nonSetterRoles = ['OH1', 'OH2', 'MB1', 'OPP'];
    final available = nonSetterRoles
        .map((tag) => roster.getByRole(side, tag))
        .nonNulls
        .toList();
    if (available.isEmpty) return roster.getSetter(side);
    return available[_rng.nextInt(available.length)];
  }

  /// Forced outside-only set options when an emergency setter (1-blocker case)
  /// takes over: randomly commits to left-side high or right-side high.
  Map<String, double> _singleOutsideOptions(bool isOppFront) {
    if (_rng.nextBool()) return {'setLeftSideHigh': 1.0};
    final rightKey = isOppFront ? 'setRightSideHigh' : 'setLeftSideHigh';
    return {rightKey: 1.0};
  }

  // Maps attacker-vs-defender differential to a transition touch quality.
  // Positive diff (attacker >> defense): ball barely dug → limited options.
  // Negative diff (defence >> attack): clean dig → full options.
  // Thresholds are loaded from outcome_weights.json.
  TransitionOutcome _computeTransitionOutcome(double atkVsDefDiff, OutcomeWeights weights) {
    if (atkVsDefDiff > weights.transitionSingleOptionAbove) return TransitionOutcome.singleOption;
    if (atkVsDefDiff > weights.transitionAverageAbove)      return TransitionOutcome.average;
    if (atkVsDefDiff > weights.transitionPerfectBelow)      return TransitionOutcome.average;
    return TransitionOutcome.perfect;
  }
}
