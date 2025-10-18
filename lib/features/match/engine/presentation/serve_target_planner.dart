// lib/features/match/engine/presentation/serve_target_planner.dart
import 'dart:math';
import 'dart:ui';
import '../../state/match_state.dart';
import '../../state/tactics_state.dart' show ServeReceiveTacticSpec;
import '../positions/position_resolver.dart';
import '../positions/tactic_layout_key.dart'; // receiveTacticSuffix

class ServeTarget {
  final Offset target;
  final String label;
  const ServeTarget(this.target, this.label);
}

class ServeTargetPlanner {
  ServeTargetPlanner(this.resolver, {Random? rng}) : _rng = rng ?? Random();
  final PositionResolver resolver;
  final Random _rng;

  ServeTarget pickTarget({
    required TeamSide toSide,
    required int rotationIndex1to6,
    required Rect courtRect,
    required ServeReceiveTacticSpec spec,
  }) {
    // Try tactic-specific anchors first (seam16, seam56, zone5/6/1, quarters).
    Offset? seam16 = resolver.resolveAnchor(
      phase: 'receive',
      side: toSide,
      rotationIndex1to6: rotationIndex1to6,
      courtRect: courtRect,
      anchorName: 'seam16',
      tactic: receiveTacticSuffix(spec),
    );
    Offset? seam56 = resolver.resolveAnchor(
      phase: 'receive',
      side: toSide,
      rotationIndex1to6: rotationIndex1to6,
      courtRect: courtRect,
      anchorName: 'seam56',
      tactic: receiveTacticSuffix(spec),
    );

    List<(String, Offset)> picks = [];

    final n = spec.numPassers.clamp(2, 4);
    if (n <= 2) {
      if (seam16 != null) picks.add(('seam16', seam16));
      if (seam56 != null) picks.add(('seam56', seam56));
      if (picks.isEmpty) {
        final z6 = resolver.resolveAnchor(
          phase: 'receive',
          side: toSide,
          rotationIndex1to6: rotationIndex1to6,
          courtRect: courtRect,
          anchorName: 'zone6',
          tactic: receiveTacticSuffix(spec),
        );
        final z1 = resolver.resolveAnchor(
          phase: 'receive',
          side: toSide,
          rotationIndex1to6: rotationIndex1to6,
          courtRect: courtRect,
          anchorName: 'zone1',
          tactic: receiveTacticSuffix(spec),
        );
        final z5 = resolver.resolveAnchor(
          phase: 'receive',
          side: toSide,
          rotationIndex1to6: rotationIndex1to6,
          courtRect: courtRect,
          anchorName: 'zone5',
          tactic: receiveTacticSuffix(spec),
        );
        if (z6 != null) picks.add(('zone6', z6));
        if (z1 != null) picks.add(('zone1', z1));
        if (z5 != null) picks.add(('zone5', z5));
      }
    } else if (n == 3) {
      final z5 = resolver.resolveAnchor(
        phase: 'receive',
        side: toSide,
        rotationIndex1to6: rotationIndex1to6,
        courtRect: courtRect,
        anchorName: 'zone5',
        tactic: receiveTacticSuffix(spec),
      );
      final z6 = resolver.resolveAnchor(
        phase: 'receive',
        side: toSide,
        rotationIndex1to6: rotationIndex1to6,
        courtRect: courtRect,
        anchorName: 'zone6',
        tactic: receiveTacticSuffix(spec),
      );
      final z1 = resolver.resolveAnchor(
        phase: 'receive',
        side: toSide,
        rotationIndex1to6: rotationIndex1to6,
        courtRect: courtRect,
        anchorName: 'zone1',
        tactic: receiveTacticSuffix(spec),
      );
      if (z5 != null) picks.add(('zone5', z5));
      if (z6 != null) picks.add(('zone6', z6));
      if (z1 != null) picks.add(('zone1', z1));
    } else {
      // 4 passers → quarters if available
      for (final a in [
        'quarter_lt',
        'quarter_rt',
        'quarter_lb',
        'quarter_rb',
      ]) {
        final p = resolver.resolveAnchor(
          phase: 'receive',
          side: toSide,
          rotationIndex1to6: rotationIndex1to6,
          courtRect: courtRect,
          anchorName: a,
          tactic: receiveTacticSuffix(spec),
        );
        if (p != null) picks.add((a, p));
      }
      if (picks.isEmpty) {
        for (final a in ['zone5', 'zone6', 'zone1']) {
          final p = resolver.resolveAnchor(
            phase: 'receive',
            side: toSide,
            rotationIndex1to6: rotationIndex1to6,
            courtRect: courtRect,
            anchorName: a,
            tactic: receiveTacticSuffix(spec),
          );
          if (p != null) picks.add((a, p));
        }
      }
    }

    if (picks.isEmpty) {
      final half = _halfRect(courtRect, toSide);
      final fb = Offset(half.left + half.width * 0.25, half.center.dy);
      return ServeTarget(fb, 'fallback_zone6ish');
    }

    final chosen = picks[_rng.nextInt(picks.length)].$2;
    final half = _halfRect(courtRect, toSide);
    final jitter = Offset(
      (half.width * 0.015) * (_rng.nextDouble() - 0.5) * 2,
      (half.height * 0.040) * (_rng.nextDouble() - 0.5) * 2,
    );
    return ServeTarget(chosen + jitter, 'anchor');
  }

  Rect _halfRect(Rect court, TeamSide side) {
    final cx = court.left + court.width / 2;
    return (side == TeamSide.home)
        ? Rect.fromLTRB(court.left, court.top, cx, court.bottom)
        : Rect.fromLTRB(cx, court.top, court.right, court.bottom);
  }
}
