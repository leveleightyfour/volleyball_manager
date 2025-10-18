// lib/features/match/engine/positions/position_resolver.dart
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:volleyball_manager/shared/log/live_log.dart';
import '../../state/match_state.dart';
import 'position_models.dart';

class PositionResolver {
  PositionResolver(this.book);
  final PositionBook book;

  /// Resolve role points for a phase/side/rotation/tactic into absolute Offsets.
  Map<String, Offset> resolveRoles({
    required String phase, // 'serve' | 'receive' | ...
    required TeamSide side,
    required int rotationIndex1to6, // 1..6
    required Rect courtRect,
    String tactic = 'default',
  }) {
    final key = pipeKey(
      team: side == TeamSide.home ? 'home' : 'away',
      phase: phase,
      rotationIndex1to6: rotationIndex1to6,
      tactic: tactic,
    );

    final layout = book.layouts[key];
    if (layout == null) {
      log.i0('⚠️ positions: no layout for "$key" (roles)');
      return const {};
    }

    final half = _halfOf(courtRect, side);
    Offset mapPoint(RolePoint p) {
      // allow small negative x for server-start, etc.
      final nx = p.x.clamp(-0.20, 1.20);
      final ny = p.y.clamp(0.0, 1.0);

      // Horizontal mirror for AWAY so JSON can be authored in HOME orientation
      final x = side == TeamSide.home
          ? half.left + half.width * nx
          : half.right - half.width * nx;

      final y = half.top + half.height * ny;
      return Offset(x, y);
    }

    return layout.roles.map((role, rp) => MapEntry(role, mapPoint(rp)));
  }

  /// Resolve a *single* named anchor (e.g. 'server_start', 'seam16') to absolute Offset.
  Offset? resolveAnchor({
    required String phase, // 'serve' | 'receive'
    required TeamSide side,
    required int rotationIndex1to6, // 1..6
    required Rect courtRect,
    required String anchorName,
    String tactic = 'default',
  }) {
    final key = pipeKey(
      team: side == TeamSide.home ? 'home' : 'away',
      phase: phase,
      rotationIndex1to6: rotationIndex1to6,
      tactic: tactic,
    );
    final layout = book.layouts[key];
    if (layout == null) {
      log.i0('⚠️ positions: no layout for "$key" (anchor:$anchorName)');
      return null;
    }

    final ap = layout.anchors[anchorName];
    if (ap == null) {
      log.i0('⚠️ positions: layout "$key" missing anchor "$anchorName"');
      return null;
    }

    final half = _halfOf(courtRect, side);
    final nx = ap.x.clamp(-0.20, 1.20);
    final ny = ap.y.clamp(0.0, 1.0);
    final x = side == TeamSide.home
        ? half.left + half.width * nx
        : half.right - half.width * nx;
    final y = half.top + half.height * ny;
    return Offset(x, y);
  }

  Rect _halfOf(Rect courtRect, TeamSide side) {
    final midX = courtRect.left + courtRect.width / 2;
    return side == TeamSide.home
        ? Rect.fromLTRB(courtRect.left, courtRect.top, midX, courtRect.bottom)
        : Rect.fromLTRB(midX, courtRect.top, courtRect.right, courtRect.bottom);
  }
}
