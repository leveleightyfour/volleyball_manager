import 'dart:math';

import 'package:volleyball_manager/features/player/data/dto/player_dto.dart';
import 'package:volleyball_manager/features/match/state/match_state.dart';
import 'package:volleyball_manager/features/match/engine/outcomes/outcomes.dart';

/// Holds the two team rosters for an active match, keyed by role tag.
///
/// Role tags: S | OH1 | OH2 | MB1 | MB2 | OPP | L
///
/// Provides helpers that the OutcomeStrategy uses to look up the specific
/// player involved in each sim phase (server, passer, setter, attacker, etc.)
class MatchRoster {
  const MatchRoster({required this.home, required this.away});

  /// Players keyed by role tag for the home team.
  final Map<String, PlayerDto> home;

  /// Players keyed by role tag for the away team.
  final Map<String, PlayerDto> away;

  static const MatchRoster empty = MatchRoster(home: {}, away: {});

  bool get isLoaded => home.isNotEmpty && away.isNotEmpty;

  // Rotation 1–6 → the role tag that occupies position 1 (serves) in a 5-1.
  // Libero cannot serve; MB2 covers R6.
  static const List<String> _rotationServerRole = [
    'S',    // R1: setter serves (P1)
    'MB1',  // R2: MB1 serves (P1)
    'OH1',  // R3: OH1 serves (P1)
    'OPP',  // R4: OPP serves (P1)
    'OH2',  // R5: OH2 serves (P1)
    'MB2',  // R6: MB2 serves (libero never in P1)
  ];

  Map<String, PlayerDto> _side(TeamSide side) =>
      side == TeamSide.home ? home : away;

  PlayerDto? getByRole(TeamSide side, String roleTag) =>
      _side(side)[roleTag];

  /// Which player serves in the given rotation index (1–6).
  PlayerDto? getServer(TeamSide side, int rotationIndex1to6) {
    final tag = _rotationServerRole[(rotationIndex1to6 - 1).clamp(0, 5)];
    return getByRole(side, tag);
  }

  PlayerDto? getSetter(TeamSide side) => getByRole(side, 'S');

  /// Which player attacks based on the set type.
  PlayerDto? getAttacker(TeamSide side, SetOutcome setOutcome) =>
      switch (setOutcome) {
        SetOutcome.middle         => getByRole(side, 'MB1'),
        SetOutcome.leftSideHigh    => getByRole(side, 'OH1'),
        SetOutcome.leftSideTempo   => getByRole(side, 'OH1'),
        SetOutcome.rightSideHigh  => getByRole(side, 'OPP'),
        SetOutcome.rightSideTempo => getByRole(side, 'OPP'),
        SetOutcome.backrow        => getByRole(side, 'OPP'),
        SetOutcome.pipe           => getByRole(side, 'OPP'),
        SetOutcome.tip            => getByRole(side, 'S'),
      };

  /// Blockers from the defending side.
  ///
  /// Count is driven by pass quality: perfect → 1, average → 2,
  /// singleOption → 3. The specific roles depend on the set type.
  /// (Future: blocker count will also be influenced by blocking tactics.)
  List<PlayerDto> getBlockers(
      TeamSide defendingSide, SetOutcome setOutcome, PassOutcome passQuality) {
    final t = _side(defendingSide);

    final count = switch (passQuality) {
      PassOutcome.perfect      => 1,
      PassOutcome.average      => 2,
      PassOutcome.singleOption => 3,
      _                        => 1,
    };

    // Priority-ordered role lists — take the first [count] that exist.
    final allTags = switch (setOutcome) {
      SetOutcome.leftSideHigh || SetOutcome.leftSideTempo =>
        ['MB1', 'OH2', 'OPP'],
      SetOutcome.rightSideHigh || SetOutcome.rightSideTempo =>
        ['MB1', 'OH1', 'OH2'],
      SetOutcome.middle =>
        ['MB1', 'MB2', 'OPP'],
      SetOutcome.pipe =>
        ['MB1', 'MB2', 'OH2'],
      SetOutcome.backrow =>
        ['MB1', 'OPP', 'OH2'],
      SetOutcome.tip =>
        <String>[],
    };

    return allTags.take(count).map((tag) => t[tag]).nonNulls.toList();
  }

  /// Defenders in the back/middle court for the chosen attack direction.
  ///
  /// [blockerCount] shapes which players are available:
  /// - 1 blocker (perfect pass): only MB1 is at the net; MB1 stays in the
  ///   middle of the court and is added as a floor defender.
  /// - 2 blockers (average pass): standard floor coverage.
  /// - 3 blockers (single option): the sharp-cross player is up blocking;
  ///   any OH that joined the block is removed from the floor.
  ///
  /// Blocker compositions (from getBlockers priority lists):
  ///   leftSide  → MB1 / MB1+OH2 / MB1+OH2+OPP
  ///   rightSide → MB1 / MB1+OH1 / MB1+OH1+OH2
  ///   middle    → MB1 / MB1+MB2 / MB1+MB2+OPP
  List<PlayerDto> getDefenders(
      TeamSide defendingSide, AttackDirection dir, int blockerCount) {
    final t = _side(defendingSide);
    final tags = switch (dir) {
      // ── OH / left-side attack ────────────────────────────────────────────
      // blockers: MB1(1)  MB1+OH2(2)  MB1+OH2+OPP(3)
      AttackDirection.ohLine => switch (blockerCount) {
          3 => ['L'],             // OH2 is blocking
          1 => ['L', 'OH2', 'MB1'], // MB stays middle of court
          _ => ['L', 'OH2'],     // 2 blockers: standard
        },
      AttackDirection.ohCrossShallow => switch (blockerCount) {
          1 => ['L', 'OH1', 'MB1'], // MB stays middle of court
          _ => ['L', 'OH1'],     // OH1 never blocks leftSide
        },
      AttackDirection.ohCrossSharp =>
        ['OH1'],                  // only reached with 1 blocker (perfect pass)

      // ── OPP / right-side attack ──────────────────────────────────────────
      // blockers: MB1(1)  MB1+OH1(2)  MB1+OH1+OH2(3)
      AttackDirection.oppLine => switch (blockerCount) {
          3 => ['L'],             // OH1 is blocking
          2 => ['L'],             // OH1 is blocking (2nd blocker)
          _ => ['L', 'OH1', 'MB1'], // 1 blocker: MB stays middle
        },
      AttackDirection.oppCrossShallow => switch (blockerCount) {
          3 => ['L'],             // OH2 is now blocking (3rd)
          1 => ['L', 'OH2', 'MB1'], // MB stays middle
          _ => ['L', 'OH2'],     // 2 blockers: OH2 free
        },
      AttackDirection.oppCrossSharp =>
        ['OH2'],                  // only reached with 1 blocker (perfect pass)

      // ── Middle / pipe / backrow ──────────────────────────────────────────
      // blockers: MB1(1)  MB1+MB2(2)  MB1+MB2+OPP(3)
      AttackDirection.middleZone1 => switch (blockerCount) {
          1 => ['L', 'OH2', 'MB1'], // MB stays middle of court
          _ => ['L', 'OH2'],
        },
      AttackDirection.middleZone5 => switch (blockerCount) {
          1 => ['L', 'OH1', 'MB1'], // MB stays middle of court
          _ => ['L', 'OH1'],
        },
      AttackDirection.middleZone6 => switch (blockerCount) {
          1 => ['L', 'MB1'],     // MB stays middle of court
          _ => ['L'],
        },

      // ── At-block — deflections; no floor defender in position ─────────────
      AttackDirection.atBlock => <String>[],
    };
    return tags.map((tag) => t[tag]).nonNulls.toList();
  }

  /// Active passers for a team based on the passing role tags from tactics.
  List<PlayerDto> getPassers(TeamSide side, List<String> roleTags) =>
      roleTags.map((tag) => _side(side)[tag]).nonNulls.toList();

  /// Select the passer most likely to receive a serve in [zone].
  ///
  /// Zone strings: 'zone1' (right back), 'zone5' (left back), 'zone6'
  /// (middle back), 'seam16' (right-middle seam), 'seam56' (left-middle seam).
  ///
  /// Tries each preferred role in priority order; falls back to a random
  /// passer from the active list if none of the preferred roles are passing.
  PlayerDto? getPasserForZone(
    TeamSide side,
    List<String> roleTags,
    String zone,
    Random rng,
  ) {
    final passers = getPassers(side, roleTags);
    if (passers.isEmpty) return null;
    if (passers.length == 1) return passers.first;

    // Priority order of role tags per zone.
    final preferred = switch (zone) {
      'zone5'  => ['OH1', 'L'],
      'zone6'  => ['L', 'OH1', 'OH2'],
      'zone1'  => ['OH2', 'OPP', 'L'],
      'seam56' => ['L', 'OH1'],
      'seam16' => ['L', 'OH2', 'OPP'],
      _        => <String>[],
    };

    final tagSet = roleTags.toSet();
    for (final role in preferred) {
      if (tagSet.contains(role)) {
        final player = getByRole(side, role);
        if (player != null) return player;
      }
    }
    return passers[rng.nextInt(passers.length)];
  }
}
