// lib/features/match/game/services/layout_manager.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:volleyball_manager/shared/models/player_lite.dart';
import 'package:volleyball_manager/features/match/engine/positions/position_resolver.dart';
import 'package:volleyball_manager/features/match/engine/positions/receive_formation_calculator.dart';
import 'package:volleyball_manager/features/match/state/match_state.dart' show TeamSide;
import 'package:volleyball_manager/features/match/state/tactics_state.dart'
    show tacticsProvider, ServeReceiveTacticSpec;
import 'package:volleyball_manager/features/match/engine/outcomes/outcomes.dart';
import 'package:volleyball_manager/features/match/engine/positions/attack_formation_config.dart';
import 'package:volleyball_manager/features/match/engine/presentation/serve_target_planner.dart';
import 'package:volleyball_manager/features/match/state/defense_floor_state.dart';
import 'package:volleyball_manager/features/match/game/components/player_component.dart';
import 'package:volleyball_manager/features/match/game/components/zone_overlay_component.dart';
import 'package:volleyball_manager/features/match/game/model/move_command.dart';

/// Manages player positioning and court layout calculations.
///
/// Responsibilities:
/// - Calculate court dimensions and bounds
/// - Resolve player positions based on tactics and rotation
/// - Handle serve/receive formation layouts
/// - Map role tags to player IDs
/// - Update visual components (players, overlays) with new positions
class LayoutManager {
  LayoutManager({
    required this.positionResolver,
    required this.ref,
    required this.playerNodes,
    required this.overlay,
    required this.homePlayers,
    required this.awayPlayers,
    required this.courtPadding,
    required this.rng,
  });

  final PositionResolver positionResolver;
  final WidgetRef ref;
  final Map<int, PlayerComponent> playerNodes;
  final ZoneOverlayComponent overlay;
  final List<PlayerLite> homePlayers;
  final List<PlayerLite> awayPlayers;
  final double courtPadding;
  final Random rng;

  /// Compute court rectangle from canvas size
  Rect computeCourtRect(Vector2 canvasSize) {
    final arena = Rect.fromLTWH(
      courtPadding,
      courtPadding,
      canvasSize.x - courtPadding * 2,
      canvasSize.y - courtPadding * 2,
    );
    const aspect = 18 / 9;
    late double w, h;
    if (arena.width / arena.height >= aspect) {
      h = arena.height;
      w = h * aspect;
    } else {
      w = arena.width;
      h = w / aspect;
    }
    final fitted = Rect.fromLTWH(
      arena.left + (arena.width - w) / 2,
      arena.top + (arena.height - h) / 2,
      w,
      h,
    );
    const scale = 0.70;
    return Rect.fromLTWH(
      fitted.left + fitted.width * (1 - scale) / 2,
      fitted.top + fitted.height * (1 - scale) / 2,
      fitted.width * scale,
      fitted.height * scale,
    );
  }

  /// Get half of the court for a given side
  Rect getHalfRect(Rect court, TeamSide side) {
    final cx = court.left + court.width / 2;
    return (side == TeamSide.home)
        ? Rect.fromLTRB(court.left, court.top, cx, court.bottom)
        : Rect.fromLTRB(cx, court.top, court.right, court.bottom);
  }

  /// Update player positions and overlay based on current game state
  void updateLayout({
    required Vector2 canvasSize,
    required TeamSide serverSide,
    required int rotationTick,
    required int Function(TeamSide) getRotationIndex,
  }) {
    final court = computeCourtRect(canvasSize);
    final serving = serverSide;
    final rotHome = getRotationIndex(TeamSide.home);
    final rotAway = getRotationIndex(TeamSide.away);

    // --- SERVE layouts (serve tactic currently fixed to "default")
    final serveHome = positionResolver.resolveRoles(
      phase: 'serve',
      side: TeamSide.home,
      rotationIndex1to6: rotHome,
      courtRect: court,
      tactic: 'default',
    );
    final serveAway = positionResolver.resolveRoles(
      phase: 'serve',
      side: TeamSide.away,
      rotationIndex1to6: rotAway,
      courtRect: court,
      tactic: 'default',
    );

    // Note: RECEIVE layouts are resolved inside _placeReceiving()
    // based on tactics state

    // Place players based on who's serving — front-row get blocking x
    if (serving == TeamSide.home) {
      _placeFromRoleMap(
        _withBlockingX(roles: serveHome, side: TeamSide.home, rotation: rotHome, court: court),
        homePlayers,
      );
      _placeReceiving(side: TeamSide.away, rotation: rotAway, court: court);
    } else {
      _placeFromRoleMap(
        _withBlockingX(roles: serveAway, side: TeamSide.away, rotation: rotAway, court: court),
        awayPlayers,
      );
      _placeReceiving(side: TeamSide.home, rotation: rotHome, court: court);
    }

    // Update overlay
    overlay
      ..courtRect = court
      ..rotationTick = rotationTick
      ..servingLabel = serverSide == TeamSide.home ? 'HOME' : 'AWAY';
  }

  /// Get fallback server starting position
  Offset getFallbackServerStart(Rect court, TeamSide side) {
    final half = getHalfRect(court, side);
    final y = half.top + half.height * 0.75;
    final x = side == TeamSide.home
        ? half.left - court.width * 0.06
        : half.right + court.width * 0.06;
    return Offset(x, y);
  }

  /// Pick a serve target using the serve target planner
  ServeTarget pickServeTarget({
    required TeamSide toSide,
    required int rotationIndex1to6,
    required Rect courtRect,
    required ServeReceiveTacticSpec spec,
  }) {
    return ServeTargetPlanner(positionResolver, rng: rng).pickTarget(
      toSide: toSide,
      rotationIndex1to6: rotationIndex1to6,
      courtRect: courtRect,
      spec: spec,
    );
  }

  // ------------- Formation Animation -------------

  /// Returns [MoveCommand]s for all 12 players moving to their serve/receive
  /// formation positions. Call this on every phase change to animate players
  /// continuously into the correct formation.
  List<MoveCommand> buildFormationMoves({
    required Vector2 canvasSize,
    required TeamSide serverSide,
    required int Function(TeamSide) getRotationIndex,
    required double durationSec,
  }) {
    final court = computeCourtRect(canvasSize);
    final rotHome = getRotationIndex(TeamSide.home);
    final rotAway = getRotationIndex(TeamSide.away);

    final servingSide = serverSide;
    final servingRot = serverSide == TeamSide.home ? rotHome : rotAway;
    final rawServeRoles = positionResolver.resolveRoles(
      phase: 'serve',
      side: servingSide,
      rotationIndex1to6: servingRot,
      courtRect: court,
      tactic: 'default',
    );
    final servingRoles = _withBlockingX(
      roles: rawServeRoles,
      side: servingSide,
      rotation: servingRot,
      court: court,
    );

    final receivingRoster = serverSide == TeamSide.home ? awayPlayers : homePlayers;
    final receivingSide = serverSide == TeamSide.home ? TeamSide.away : TeamSide.home;
    final receivingRot = serverSide == TeamSide.home ? rotAway : rotHome;
    final specRaw = ref.read(tacticsProvider.notifier).getSpec(receivingSide, receivingRot);
    final receivingRoles = ReceiveFormationCalculator.compute(
      side: receivingSide,
      rotationIndex1to6: receivingRot,
      passingRoles: specRaw.passingRoles,
      courtHalf: getHalfRect(court, receivingSide),
    );

    final servingRoster = serverSide == TeamSide.home ? homePlayers : awayPlayers;
    final servingIds = _roleTagToPlayerId(servingRoster);
    final receivingIds = _roleTagToPlayerId(receivingRoster);
    final servingBench = ReceiveFormationCalculator.servingBenchRoleFor(servingRot);

    final commands = <MoveCommand>[];

    servingRoles.forEach((tag, pos) {
      if (tag == servingBench) return;
      final pid = servingIds[tag];
      if (pid != null) {
        commands.add(MoveCommand(playerId: pid, to: pos, durationSec: durationSec));
      }
    });

    receivingRoles.forEach((tag, pos) {
      final pid = receivingIds[tag];
      if (pid != null) {
        commands.add(MoveCommand(playerId: pid, to: pos, durationSec: durationSec));
      }
    });

    return commands;
  }

  // ------------- Reception Formation -------------

  /// Returns [MoveCommand]s for the receiving team during the reception phase.
  ///
  /// The **single passer closest to [ballLandingZone]** moves to the ball.
  /// All other players (including unused passers) sprint to their
  /// setting-formation positions (setter to front-right, MBs to attack line, etc.).
  List<MoveCommand> buildReceptionMoves({
    required Vector2 canvasSize,
    required TeamSide receivingSide,
    required int rotationIndex,
    required Set<String> passingRoles,
    required Offset ballLandingZone,
    required double durationSec,
  }) {
    final court = computeCourtRect(canvasSize);

    final settingRoles = positionResolver.resolveRoles(
      phase: 'setting',
      side: receivingSide,
      rotationIndex1to6: rotationIndex,
      courtRect: court,
      tactic: 'default',
    );

    // Get each passer's current receive-formation position to find the closest
    final receivePositions = ReceiveFormationCalculator.compute(
      side: receivingSide,
      rotationIndex1to6: rotationIndex,
      passingRoles: passingRoles,
      courtHalf: getHalfRect(court, receivingSide),
    );

    // Pick the passer whose receive position is closest to the ball
    String? closestPasser;
    double closestDist = double.infinity;
    for (final role in passingRoles) {
      final pos = receivePositions[role];
      if (pos != null) {
        final dx = pos.dx - ballLandingZone.dx;
        final dy = pos.dy - ballLandingZone.dy;
        final dist = sqrt(dx * dx + dy * dy);
        if (dist < closestDist) {
          closestDist = dist;
          closestPasser = role;
        }
      }
    }

    // L's post-pass position: zone 5 (LB) — left-back defensive coverage.
    // y from unique zone map (home z5=0.29, away z5=0.71), x=0.45 (mid-back depth).
    final half = getHalfRect(court, receivingSide);
    const liberoNormX = 0.45;
    final liberoNormY = receivingSide == TeamSide.home ? 0.29 : 0.71;
    final liberoZ5Pos = Offset(
      receivingSide == TeamSide.home
          ? half.left + half.width * liberoNormX
          : half.right - half.width * liberoNormX,
      half.top + half.height * liberoNormY,
    );

    final roster = receivingSide == TeamSide.home ? homePlayers : awayPlayers;
    final ids = _roleTagToPlayerId(roster);
    final commands = <MoveCommand>[];

    final benchRole = ReceiveFormationCalculator.benchRoleFor(rotationIndex);
    final frontRow = ReceiveFormationCalculator.frontRowRolesFor(rotationIndex);

    // Everyone except the closest passer, L, and bench MB → setting formation.
    // Back-row non-setters are skipped — they hold their receive positions.
    settingRoles.forEach((tag, pos) {
      if (tag != closestPasser && tag != 'L' && tag != benchRole) {
        if (tag != 'S' && !frontRow.contains(tag)) return;
        final pid = ids[tag];
        if (pid != null) {
          commands.add(MoveCommand(playerId: pid, to: pos, durationSec: durationSec));
        }
      }
    });

    // Closest passer → ball. Always, even if it's L — L moves to zone 5 after
    // the pass via buildSettingFormationMoves when the setting phase fires.
    if (closestPasser != null) {
      final pid = ids[closestPasser];
      if (pid != null) {
        commands.add(MoveCommand(
          playerId: pid,
          to: ballLandingZone,
          durationSec: durationSec * 0.7,
        ));
      }
    }

    // L moves to zone 5 (LB) now — unless L is the one receiving the ball.
    if (closestPasser != 'L') {
      final pid = ids['L'];
      if (pid != null) {
        commands.add(MoveCommand(playerId: pid, to: liberoZ5Pos, durationSec: durationSec));
      }
    }

    return commands;
  }

  // ------------- Defense Formation -------------

  /// Returns [MoveCommand]s for the serving side's players moving to their
  /// neutral defensive positions as the ball is in flight.
  ///
  /// Positions are rotation-specific (handles MB-serves case where MB→zone5
  /// and L is on bench, vs normal case where front-row MB blocks at zone3).
  List<MoveCommand> buildDefenseFormationMoves({
    required Vector2 canvasSize,
    required TeamSide servingSide,
    required int rotationIndex,
    required double durationSec,
  }) {
    final court = computeCourtRect(canvasSize);
    final roles = positionResolver.resolveRoles(
      phase: 'defense',
      side: servingSide,
      rotationIndex1to6: rotationIndex,
      courtRect: court,
      tactic: 'default',
    );

    // When serving, L is on bench in R3/R6 (MB serves); use servingBenchRoleFor.
    final benchRole = ReceiveFormationCalculator.servingBenchRoleFor(rotationIndex);
    final roster = servingSide == TeamSide.home ? homePlayers : awayPlayers;
    final ids = _roleTagToPlayerId(roster);

    final commands = <MoveCommand>[];
    roles.forEach((tag, pos) {
      if (tag == benchRole) return;
      final pid = ids[tag];
      if (pid != null) {
        commands.add(MoveCommand(playerId: pid, to: pos, durationSec: durationSec));
      }
    });
    return commands;
  }

  // ------------- Setting Formation -------------

  /// Returns [MoveCommand]s for all players on the attacking side moving to
  /// their neutral setting positions (setter sprints front-right, attackers
  /// take approach positions).
  List<MoveCommand> buildSettingFormationMoves({
    required Vector2 canvasSize,
    required TeamSide attackingSide,
    required int rotationIndex,
    required double durationSec,
    Offset? setterDestination, // if provided, setter runs to the ball landing spot
  }) {
    final court = computeCourtRect(canvasSize);
    final roles = positionResolver.resolveRoles(
      phase: 'setting',
      side: attackingSide,
      rotationIndex1to6: rotationIndex,
      courtRect: court,
      tactic: 'default',
    );

    final benchRole = ReceiveFormationCalculator.benchRoleFor(rotationIndex);
    // Back-row players must not be sent to net-area setting positions.
    final frontRow = ReceiveFormationCalculator.frontRowRolesFor(rotationIndex);

    // L's post-reception position: zone 5 (LB).
    final half = getHalfRect(court, attackingSide);
    const liberoNormX = 0.45;
    final liberoNormY = attackingSide == TeamSide.home ? 0.29 : 0.71;
    final liberoZ5Pos = Offset(
      attackingSide == TeamSide.home
          ? half.left + half.width * liberoNormX
          : half.right - half.width * liberoNormX,
      half.top + half.height * liberoNormY,
    );

    final roster = attackingSide == TeamSide.home ? homePlayers : awayPlayers;
    final ids = _roleTagToPlayerId(roster);

    final commands = <MoveCommand>[];
    roles.forEach((tag, pos) {
      // Bench MB stays off-court; L always goes to zone 5.
      if (tag == benchRole) return;
      // Back-row non-setters stay in their receive position — the setting
      // JSON may have them at the net which would be wrong for back-row players.
      if (tag != 'L' && tag != 'S' && !frontRow.contains(tag)) return;
      final pid = ids[tag];
      if (pid != null) {
        final Offset dest;
        if (tag == 'L') {
          dest = liberoZ5Pos;
        } else if (tag == 'S' && setterDestination != null) {
          dest = setterDestination;
        } else {
          dest = pos;
        }
        commands.add(MoveCommand(playerId: pid, to: dest, durationSec: durationSec));
      }
    });

    // If L wasn't in the setting JSON, add them explicitly.
    if (!roles.containsKey('L')) {
      final pid = ids['L'];
      if (pid != null) {
        commands.add(MoveCommand(playerId: pid, to: liberoZ5Pos, durationSec: durationSec));
      }
    }

    return commands;
  }

  // ------------- First-attack rotation-aware position -------------

  /// Returns the attack contact point for the **first** attack of a rally.
  ///
  /// Uses the attacker's *actual* rotation zone y so that contact happens from
  /// where they are standing. In R1 OH is at zone 2 (right) and OPP is at
  /// zone 4 (left); after the first net-crossing they switch to canonical
  /// positions (OH→zone 4, OPP→zone 2). Subsequent attacks use canonical zone
  /// positions which are already correct post-switch.
  Offset? getFirstAttackPosition({
    required Vector2 canvasSize,
    required TeamSide attackingSide,
    required int rotationIndex,
    required SetOutcome setOutcome,
  }) {
    final attackerTag = _attackerTagFor(setOutcome, rotationIndex);
    if (attackerTag == null) return null;

    final court = computeCourtRect(canvasSize);
    final half = getHalfRect(court, attackingSide);

    const netNormX = 0.90;
    final netX = attackingSide == TeamSide.home
        ? half.left + half.width * netNormX
        : half.right - half.width * netNormX;

    // Look up the attacker's zone in the current rotation and convert to y.
    final zoneMap = ReceiveFormationCalculator.frontRowZoneMapFor(rotationIndex);
    final attackerZone = zoneMap[attackerTag] ?? 3;
    final ny = _zoneContactY(attackerZone, attackingSide);
    return Offset(netX, half.top + half.height * ny);
  }

  // ------------- Pre-set Approach -------------

  /// Returns [MoveCommand]s for all potential attackers (OH1, OPP, MB1) to
  /// begin their approach run toward the net while the ball is still in flight
  /// to the setter.  Called with a delay so movement starts roughly 0.6 s
  /// into the 1.2 s pass animation — matching real approach timing.
  List<MoveCommand> buildPreSetApproachMoves({
    required Vector2 canvasSize,
    required TeamSide attackingSide,
    required int rotationIndex,
    required AttackFormationConfig formations,
    required double durationSec,
  }) {
    final court = computeCourtRect(canvasSize);
    final half = getHalfRect(court, attackingSide);
    final benchRole = ReceiveFormationCalculator.benchRoleFor(rotationIndex);
    final roster = attackingSide == TeamSide.home ? homePlayers : awayPlayers;
    final ids = _roleTagToPlayerId(roster);

    // Only front-row players approach the net — back-row players must not go
    // to the front court (e.g. OH1 in R3 is back-row and should stay back).
    final frontRow = ReceiveFormationCalculator.frontRowRolesFor(rotationIndex);

    final commands = <MoveCommand>[];
    formations.approach.forEach((tag, normPos) {
      if (tag == benchRole) return;
      if (!frontRow.contains(tag)) return; // skip back-row players
      final pid = ids[tag];
      if (pid == null) return;
      // attack_formations.json y values are authored for home team (absolute).
      // Away team has a mirrored court so y must be flipped.
      final ny = attackingSide == TeamSide.away ? 1.0 - normPos.$2 : normPos.$2;
      commands.add(MoveCommand(
        playerId: pid,
        to: _normToScreen(half, attackingSide, normPos.$1, ny),
        durationSec: durationSec,
      ));
    });
    return commands;
  }

  // ------------- Attack Cover Formation -------------

  /// Returns [MoveCommand]s for:
  ///   • The chosen attacker  → moves to [attackContactPoint].
  ///   • All other players    → move to their cover positions for [setOutcome].
  ///
  /// Cover positions are defined in attack_formations.json so they can be
  /// tweaked without recompiling.
  List<MoveCommand> buildAttackCoverMoves({
    required Vector2 canvasSize,
    required TeamSide attackingSide,
    required int rotationIndex,
    required SetOutcome setOutcome,
    required Offset attackContactPoint,
    required AttackFormationConfig formations,
    required double durationSec,
  }) {
    final court = computeCourtRect(canvasSize);
    final half = getHalfRect(court, attackingSide);
    final benchRole = ReceiveFormationCalculator.benchRoleFor(rotationIndex);
    final roster = attackingSide == TeamSide.home ? homePlayers : awayPlayers;
    final ids = _roleTagToPlayerId(roster);

    final attackerTag = _attackerTagFor(setOutcome, rotationIndex);
    final coverMap = formations.cover[setOutcome.name] ?? {};

    final commands = <MoveCommand>[];

    // Chosen attacker → attack contact point.
    if (attackerTag != null && attackerTag != benchRole) {
      final pid = ids[attackerTag];
      if (pid != null) {
        commands.add(MoveCommand(
          playerId: pid,
          to: attackContactPoint,
          durationSec: durationSec,
        ));
      }
    }

    // Others → cover positions from JSON.
    // attack_formations.json y values are authored for home team (absolute).
    // Away team has a mirrored court so y must be flipped.
    coverMap.forEach((tag, normPos) {
      if (tag == benchRole || tag == attackerTag) return;
      final pid = ids[tag];
      if (pid == null) return;
      final ny = attackingSide == TeamSide.away ? 1.0 - normPos.$2 : normPos.$2;
      commands.add(MoveCommand(
        playerId: pid,
        to: _normToScreen(half, attackingSide, normPos.$1, ny),
        durationSec: durationSec,
      ));
    });

    return commands;
  }

  // ------------- Defense Attack Positions -------------

  /// Returns [MoveCommand]s moving the defending team into their block and
  /// floor-defence positions when the set phase is known.
  ///
  /// Blockers go to the net at the y-position corresponding to the set type.
  /// Blocker count is derived from [passOutcome] (perfect=1, average=2,
  /// singleOption=3). Floor defenders go to default coverage zones.
  List<MoveCommand> buildDefenseAttackMoves({
    required Vector2 canvasSize,
    required TeamSide defendingSide,
    required SetOutcome setOutcome,
    required PassOutcome passOutcome,
    required int rotationIndex,
    required double durationSec,
  }) {
    final court = computeCourtRect(canvasSize);
    final half = getHalfRect(court, defendingSide);
    final roster = defendingSide == TeamSide.home ? homePlayers : awayPlayers;
    final ids = _roleTagToPlayerId(roster);
    // Defending side is the serving team — use servingBenchRoleFor (L off in R3/R6).
    final benchRole = ReceiveFormationCalculator.servingBenchRoleFor(rotationIndex);

    final blockerCount = switch (passOutcome) {
      PassOutcome.perfect      => 1,
      PassOutcome.average      => 2,
      PassOutcome.singleOption => 3,
      _                        => 1,
    };

    // Only front-row players can block — back-row roles (e.g. OPP in rotation 4)
    // are filtered out and instead appear as floor defenders.
    final frontRow = ReceiveFormationCalculator.frontRowRolesFor(rotationIndex);

    final commands = <MoveCommand>[];

    // ── Blockers at the net (front-row only) ──────────────────────────────
    // Filter first (eligibility), then take N — ensures we get up to blockerCount
    // actual front-row non-bench blockers rather than wasting slots on bench/back-row.
    final blockerRoles = _blockerRolesForSet(setOutcome, defendingSide, rotationIndex)
        .where((r) => r != benchRole && frontRow.contains(r))
        .take(blockerCount)
        .toList();
    final actualBlockerCount = blockerRoles.length;
    final centerY = _blockerCenterY(setOutcome, defendingSide);
    final spreads = _blockerYSpreads(actualBlockerCount, setOutcome, defendingSide);

    for (var i = 0; i < blockerRoles.length; i++) {
      final pid = ids[blockerRoles[i]];
      if (pid != null) {
        final ny = (centerY + spreads[i]).clamp(0.04, 0.96);
        commands.add(MoveCommand(
          playerId: pid,
          to: _normToScreen(half, defendingSide, 0.88, ny),
          durationSec: durationSec,
        ));
      }
    }

    // ── Back-row floor defenders ─────────────────────────────────────────────
    // Build zone map from who is actually in zones 1, 5, 6 this rotation.
    // In R3/R6 serving the Libero is on bench — the receive-bench MB fills z1.

    // Assign sharp-cross for left/right side attacks (1-block and 2-block):
    //   leftSide (P4 attack)  → zone-4 player plays sharp-cross
    //   rightSide (P2 attack) → zone-2 player plays sharp-cross
    // If the designated zone player is already a blocker, no sharp-cross assigned.
    final sharpY = _sharpCrossY(setOutcome, defendingSide);

    String? sharpCrossRole;
    if (sharpY != null) {
      final zoneMap =
          ReceiveFormationCalculator.frontRowZoneMapFor(rotationIndex);
      final isLeft = setOutcome == SetOutcome.leftSideHigh ||
          setOutcome == SetOutcome.leftSideTempo;
      final targetZone = isLeft ? 4 : 2;

      // Prefer the player in the target zone (P4 for leftSide, P2 for rightSide).
      // MB is never eligible. S and all others are eligible if front-court.
      for (final e in zoneMap.entries) {
        if (e.value == targetZone &&
            !blockerRoles.contains(e.key) &&
            e.key != benchRole &&
            e.key != 'MB1' &&
            e.key != 'MB2') {
          sharpCrossRole = e.key;
          break;
        }
      }
      // If the target zone has no eligible player (e.g. MB is stationed there),
      // fall back to any other eligible front-row non-MB non-blocking player.
      if (sharpCrossRole == null) {
        for (final e in zoneMap.entries) {
          if (!blockerRoles.contains(e.key) &&
              e.key != benchRole &&
              e.key != 'MB1' &&
              e.key != 'MB2') {
            sharpCrossRole = e.key;
            break;
          }
        }
      }
      if (sharpCrossRole != null) {
        final pid = ids[sharpCrossRole];
        if (pid != null) {
          commands.add(MoveCommand(
            playerId: pid,
            to: _normToScreen(half, defendingSide, 0.75, sharpY),
            durationSec: durationSec,
          ));
        }
      }
    }

    // ── Front-row MB not assigned to block (1-block scenario) ───────────────
    // In a 1-block the MB never goes to the net — they hold their mid-court
    // starting position (zone 3 / centre of the front court). A mid-court
    // anchor at x≈0.65, y=0.50 keeps them from freezing in a stale position.
    final frontZoneMap =
        ReceiveFormationCalculator.frontRowZoneMapFor(rotationIndex);
    for (final e in frontZoneMap.entries) {
      final role = e.key;
      if (role != 'MB1' && role != 'MB2') continue;
      if (role == benchRole) continue;
      if (blockerRoles.contains(role)) continue;
      if (role == sharpCrossRole) continue;
      final pid = ids[role];
      if (pid == null) continue;
      commands.add(MoveCommand(
        playerId: pid,
        to: _normToScreen(half, defendingSide, 0.65, 0.50),
        durationSec: durationSec,
      ));
    }

    // Build rotation-aware back-row zone map.
    // In R3/R6 serving, L is bench and the receive-bench MB is actually in z1.
    final backRowZones = Map<String, int>.from(
        ReceiveFormationCalculator.backRowZoneMapFor(rotationIndex));
    if (benchRole == 'L') {
      backRowZones.remove('L');
      final serveMB = ReceiveFormationCalculator.benchRoleFor(rotationIndex);
      if (serveMB != null) backRowZones[serveMB] = 1;
    }

    for (final e in backRowZones.entries) {
      final role = e.key;
      final zone = e.value;
      if (role == benchRole) continue;
      if (frontRow.contains(role)) continue;    // front-row holds formation
      if (blockerRoles.contains(role)) continue; // already at the net
      if (role == sharpCrossRole) continue;       // already assigned sharp-cross
      final pid = ids[role];
      if (pid == null) continue;

      final norm = _backRowFloorPosition(zone, setOutcome, defendingSide);
      commands.add(MoveCommand(
        playerId: pid,
        to: _normToScreen(half, defendingSide, norm.$1, norm.$2),
        durationSec: durationSec,
      ));
    }

    return commands;
  }

  // Rotation-aware blocker role ordering.
  //
  // For side attacks (leftSide / rightSide):
  //   [0] Line blocker — the player in the zone on the attack side (zone 2 for
  //       leftSide, zone 4 for rightSide). They are already on that side of the
  //       court and defend the line. S and L are excluded.
  //   [1] MB — closes from center to form the 2-block.
  //   [2] Remaining front-row player — closes furthest inside for the 3-block.
  //
  // For non-side attacks (middle, pipe, backrow):
  //   MB first (directly in front of the attack), then wings.
  //
  // S and L never block.
  static List<String> _blockerRolesForSet(
      SetOutcome set, TeamSide defendingSide, int rotationIndex) {
    if (set == SetOutcome.tip) return const [];

    final zoneMap =
        ReceiveFormationCalculator.frontRowZoneMapFor(rotationIndex);

    final isLeft =
        set == SetOutcome.leftSideHigh || set == SetOutcome.leftSideTempo;
    final isRight =
        set == SetOutcome.rightSideHigh || set == SetOutcome.rightSideTempo;

    if (isLeft || isRight) {
      // Zone 2 is on the attack side for leftSide; zone 4 for rightSide.
      // (Zone 2 faces the same side of the net as zone 4 of the attacking team.)
      final lineZone = isLeft ? 2 : 4;

      String? lineRole;
      String? mbRole;
      final insideRoles = <String>[];

      for (final e in zoneMap.entries) {
        final role = e.key;
        if (role == 'S' || role == 'L') continue;
        // MB is always the seam blocker — never the line blocker, even if
        // rotation has placed them at the line zone (e.g. MB2 at zone 4 in R3).
        if (role == 'MB1' || role == 'MB2') {
          mbRole = role;
        } else if (e.value == lineZone) {
          lineRole = role;
        } else {
          insideRoles.add(role);
        }
      }

      // Standard case: non-MB at line zone → [line, MB, ...inside].
      if (lineRole != null) {
        return [lineRole, if (mbRole != null) mbRole, ...insideRoles];
      }

      // No non-MB at line zone (e.g. MB is at zone 4 in R3 defending rightSide).
      // Sort remaining non-MB players by zone proximity to the line zone so the
      // physically closest takes the line. MB is ALWAYS index 1 (seam blocker in
      // 2-block), so insert it after the first inside role.
      insideRoles.sort((a, b) {
        final az = zoneMap[a] ?? 3;
        final bz = zoneMap[b] ?? 3;
        return (az - lineZone).abs().compareTo((bz - lineZone).abs());
      });
      if (insideRoles.isEmpty) return [if (mbRole != null) mbRole];
      return [
        insideRoles.first,
        if (mbRole != null) mbRole,
        ...insideRoles.skip(1),
      ];
    }

    // Non-side attack: MB first, remaining wings in any order.
    final zoneY = defendingSide == TeamSide.home
        ? const <int, double>{2: 0.88, 3: 0.50, 4: 0.12}
        : const <int, double>{2: 0.12, 3: 0.50, 4: 0.88};
    final centerY = _blockerCenterY(set, defendingSide);

    return zoneMap.keys
        .where((r) => r != 'S' && r != 'L')
        .toList()
      ..sort((a, b) {
          final aMB = a == 'MB1' || a == 'MB2';
          final bMB = b == 'MB1' || b == 'MB2';
          if (aMB != bMB) return aMB ? -1 : 1;
          final ay = zoneY[zoneMap[a]] ?? 0.5;
          final by = zoneY[zoneMap[b]] ?? 0.5;
          return (ay - centerY).abs().compareTo((by - centerY).abs());
        });
  }

  // Canonical attack-contact ny (normalised within the attacking half) for a
  // given set type and attacking side. Mirrors the approach positions in
  // attack_formations.json so the contact point is always at the correct pin
  // regardless of which zone rotation has placed the attacker in.
  /// Maps a front-row zone number (2, 3, 4) to the attack contact y.
  /// Zone 2 = front-right (high y for home), zone 4 = front-left (low y for home).
  static double _zoneContactY(int zone, TeamSide attackingSide) {
    final base = switch (zone) {
      2 => 0.90, // front-right
      4 => 0.10, // front-left
      _ => 0.50, // middle / unknown
    };
    return attackingSide == TeamSide.home ? base : 1.0 - base;
  }

  // Central ny value for the block, team-aware.
  // y values are authored for home team (OH at top y≈0.12, OPP at bottom y≈0.88).
  // When home defends (away attacks from mirrored positions), flip the center y.
  static double _blockerCenterY(SetOutcome set, TeamSide defendingSide) {
    final base = switch (set) {
      SetOutcome.leftSideHigh || SetOutcome.leftSideTempo   => 0.12,
      SetOutcome.rightSideHigh || SetOutcome.rightSideTempo => 0.88,
      SetOutcome.middle                                      => 0.50,
      SetOutcome.backrow                                     => 0.88,
      SetOutcome.pipe                                        => 0.50,
      SetOutcome.tip                                         => 0.50,
    };
    return defendingSide == TeamSide.home ? 1.0 - base : base;
  }

  // Y-offsets from the block centre for each blocker.
  //
  // For side attacks the sort order is [line, MB, inside]:
  //   Index 0 — line blocker: stays at the attack side (spread 0.0).
  //   Index 1 — MB: closes toward court centre.
  //   Index 2 — inside blocker: closes furthest toward court centre.
  //
  // fromTop = attack originates near top of screen (low y):
  //   leftSide + away defending, or rightSide + home defending.
  // "toward centre" = +y when fromTop, −y otherwise.
  //
  // For non-side attacks (middle, pipe, backrow) the order remains MB-first.
  static List<double> _blockerYSpreads(
      int count, SetOutcome set, TeamSide defendingSide) {
    final isLeft =
        set == SetOutcome.leftSideHigh || set == SetOutcome.leftSideTempo;
    final isRight =
        set == SetOutcome.rightSideHigh || set == SetOutcome.rightSideTempo;

    final fromTop = (isLeft && defendingSide == TeamSide.away) ||
        (isRight && defendingSide == TeamSide.home);

    if (isLeft || isRight) {
      // [line=0.0, MB=inward, inside=2×inward]
      final inward = fromTop ? 1.0 : -1.0;
      return switch (count) {
        1 => [0.0],
        2 => [0.0, inward * 0.07],
        3 => [0.0, inward * 0.07, inward * 0.14],
        _ => List.filled(count, 0.0),
      };
    }

    // Non-side: MB-first (index 0 at seam), wings flanking.
    return switch (count) {
      2 => [0.0, -0.07],
      3 => [0.0, -0.07, 0.07],
      _ => [0.0],
    };
  }

  // y for the sharp-cross defender when there is only 1 blocker.
  // The non-blocking front-row player drops to attack-line depth on the opposite
  // side of the court from the attack, covering the sharp angle.
  // Returns null for set types without a clear near/far side (middle, pipe, tip).
  static double? _sharpCrossY(SetOutcome set, TeamSide defendingSide) {
    final isLeft  = set == SetOutcome.leftSideHigh || set == SetOutcome.leftSideTempo;
    final isRight = set == SetOutcome.rightSideHigh || set == SetOutcome.rightSideTempo;
    if (!isLeft && !isRight) return null;
    // fromTop: attacker near top → sharp cross covers the bottom side, and vice versa.
    final fromTop = (isLeft  && defendingSide == TeamSide.away) ||
                    (isRight && defendingSide == TeamSide.home);
    return fromTop ? 0.85 : 0.15;
  }

  // Back-row floor position for a player in [zone] (1, 5, or 6).
  // Zones 1 and 5 use their standard positions (line / cross-court respectively).
  // Zone 6 (middle-back) shifts 40 % toward the cross-court side for side attacks:
  //   leftSide  → cross goes to zone-5 side  → P6 shifts toward z5
  //   rightSide → cross goes to zone-1 side  → P6 shifts toward z1
  static (double, double) _backRowFloorPosition(
      int zone, SetOutcome set, TeamSide side) {
    if (zone != 6) return floorZonePosition(side, zone);

    final isLeft =
        set == SetOutcome.leftSideHigh || set == SetOutcome.leftSideTempo;
    final isRight =
        set == SetOutcome.rightSideHigh || set == SetOutcome.rightSideTempo;
    if (!isLeft && !isRight) return floorZonePosition(side, 6);

    final crossZone = isLeft ? 5 : 1;
    final (z6x, z6y) = floorZonePosition(side, 6);
    final (_, crossY) = floorZonePosition(side, crossZone);
    return (z6x, z6y + (crossY - z6y) * 0.40);
  }

  // ------------- Serve Blocking Positions -------------

  /// Overrides the x-coordinate of every front-row role in a serve formation
  /// map so they stand at the net in a blocking position (normX = 0.88),
  /// regardless of what the positions.json entry says.
  Map<String, Offset> _withBlockingX({
    required Map<String, Offset> roles,
    required TeamSide side,
    required int rotation,
    required Rect court,
  }) {
    final frontRow = ReceiveFormationCalculator.frontRowRolesFor(rotation);
    final half = getHalfRect(court, side);
    const blockNormX = 0.88;

    return roles.map((tag, pos) {
      if (!frontRow.contains(tag)) return MapEntry(tag, pos);
      final bx = side == TeamSide.home
          ? half.left + half.width * blockNormX
          : half.right - half.width * blockNormX;
      return MapEntry(tag, Offset(bx, pos.dy));
    });
  }

  // ------------- Private Helpers -------------

  /// Converts normalised half-court coords to screen [Offset].
  /// x flips for away team (net is on their left); y is absolute.
  Offset _normToScreen(Rect half, TeamSide side, double nx, double ny) {
    final x = side == TeamSide.home
        ? half.left + half.width * nx
        : half.right - half.width * nx;
    return Offset(x, half.top + half.height * ny);
  }

  /// Which role tag is the primary attacker for a given [SetOutcome],
  /// accounting for the current rotation so that the front-row OH/MB is used.
  ///
  /// - leftSide → whichever OH (OH1 or OH2) is in the front row.
  /// - middle   → whichever MB is NOT benched (MB1 or MB2).
  /// - rightSide/backrow/pipe → OPP; tip → S (unchanged).
  static String? _attackerTagFor(SetOutcome outcome, int rotationIndex) {
    switch (outcome) {
      case SetOutcome.leftSideHigh || SetOutcome.leftSideTempo:
        final frontRow =
            ReceiveFormationCalculator.frontRowRolesFor(rotationIndex);
        return frontRow.contains('OH1') ? 'OH1' : 'OH2';
      case SetOutcome.middle:
        final bench = ReceiveFormationCalculator.benchRoleFor(rotationIndex);
        return bench == 'MB1' ? 'MB2' : 'MB1';
      case SetOutcome.rightSideHigh || SetOutcome.rightSideTempo:
        return 'OPP';
      case SetOutcome.backrow:
        return 'OPP'; // OPP is always in zone 1 (back-right)
      case SetOutcome.pipe:
        // Pipe is a back-row OH attack — whichever OH is not in the front row.
        final frontRow =
            ReceiveFormationCalculator.frontRowRolesFor(rotationIndex);
        return frontRow.contains('OH1') ? 'OH2' : 'OH1';
      case SetOutcome.tip:
        return 'S';
    }
  }

  /// Map JSON role tags to player IDs (handles OH1/2, MB1/2)
  Map<String, int> _roleTagToPlayerId(List<PlayerLite> roster) {
    int pick(List<PlayerLite> list, int idx) =>
        list[(list.isEmpty ? 0 : (idx < list.length ? idx : 0))].id;

    final s = roster.where((p) => p.role == Role.s).toList();
    final opp = roster.where((p) => p.role == Role.opp).toList();
    final lib = roster.where((p) => p.role == Role.l).toList();
    final oh = roster.where((p) => p.role == Role.oh).toList();
    final mb = roster.where((p) => p.role == Role.mb).toList();

    return {
      if (s.isNotEmpty) 'S': pick(s, 0),
      if (opp.isNotEmpty) 'OPP': pick(opp, 0),
      if (lib.isNotEmpty) 'L': pick(lib, 0),
      if (oh.isNotEmpty) 'OH1': pick(oh, 0),
      if (oh.isNotEmpty) 'OH2': pick(oh, oh.length > 1 ? 1 : 0),
      if (mb.isNotEmpty) 'MB1': pick(mb, 0),
      if (mb.isNotEmpty) 'MB2': pick(mb, mb.length > 1 ? 1 : 0),
    };
  }

  /// Place players from a role map (simple positioning)
  void _placeFromRoleMap(
    Map<String, Offset> baseRoles,
    List<PlayerLite> roster,
  ) {
    final ids = _roleTagToPlayerId(roster);
    final onCourt = <int>{};

    baseRoles.forEach((tag, pos) {
      final pid = ids[tag];
      if (pid == null) return;
      playerNodes[pid]
        ?..position = Vector2(pos.dx, pos.dy)
        ..setHidden(false)
        ..setRoleLabel(tag);
      onCourt.add(pid);
    });

    for (final p in roster) {
      if (!onCourt.contains(p.id)) playerNodes[p.id]?.setHidden(true);
    }
  }

  /// Place receiving team with planner fallback
  void _placeReceiving({
    required TeamSide side,
    required int rotation,
    required Rect court,
  }) {
    final roster = side == TeamSide.home ? homePlayers : awayPlayers;

    // 1) Which tactic is active? (determines passing roles)
    final specRaw = ref.read(tacticsProvider.notifier).getSpec(side, rotation);

    // 2) Compute receive positions from rotation zone rules.
    final baseRoles = ReceiveFormationCalculator.compute(
      side: side,
      rotationIndex1to6: rotation,
      passingRoles: specRaw.passingRoles,
      courtHalf: getHalfRect(court, side),
    );

    // 3) Place players
    final tagToId = _roleTagToPlayerId(roster);
    final onCourt = <int>{};
    baseRoles.forEach((tag, pos) {
      final pid = tagToId[tag];
      if (pid == null) return;

      playerNodes[pid]
        ?..position = Vector2(pos.dx, pos.dy)
        ..setHidden(false)
        ..setRoleLabel(tag);
      onCourt.add(pid);
    });

    for (final p in roster) {
      if (!onCourt.contains(p.id)) playerNodes[p.id]?.setHidden(true);
    }
  }
}
