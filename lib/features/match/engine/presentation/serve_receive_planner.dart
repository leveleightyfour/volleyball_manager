// lib/features/match/engine/presentation/serve_receive_planner.dart
import 'dart:math';
import 'dart:ui';
import '../../state/match_state.dart';
import '../../state/tactics_state.dart' show ServeReceiveTacticSpec;
import '../positions/position_resolver.dart';
import '../positions/tactic_layout_key.dart'; // receiveTacticSuffix

class ServeReceivePlanOutput {
  const ServeReceivePlanOutput({required this.receiveSpots});

  /// Map<playerId, target Offset> only for passers. Others stay at base positions.
  final Map<int, Offset> receiveSpots;
}

class ServeReceivePlanner {
  const ServeReceivePlanner(this.resolver);
  final PositionResolver resolver;

  ServeReceivePlanOutput plan({
    required TeamSide side,
    required int rotationIndex1to6,
    required Rect courtRect,
    required ServeReceiveTacticSpec spec,
    required Map<String, int> roleTagToPlayerId,
    Random? rng,
  }) {
    final r = rng ?? Random();

    // Base layout based on the SPECIFIC tactic (e.g., "p3_L+OH1+OPP").
    final baseRoles = resolver.resolveRoles(
      phase: 'receive',
      side: side,
      rotationIndex1to6: rotationIndex1to6,
      courtRect: courtRect,
      tactic: receiveTacticSuffix(spec),
    );

    // Decide which *actual players* are passers (IDS) from role tags in spec.
    final passers = <int>[];
    for (final roleTag in spec.passingRoles) {
      final pid = roleTagToPlayerId[roleTag];
      if (pid != null) passers.add(pid);
    }

    // Place passers at canonical receive spots:
    // For 2: use seams around Z6; for 3: Z5/Z6/Z1; for 4: quarters (if provided in JSON, otherwise Z5/Z6/Z1).
    final recvHalf = _half(courtRect, side);
    final zone5 =
        baseRoles['zone5'] ?? baseRoles['L'] ?? _spot(recvHalf, 0.15, 0.33);
    final zone6 = baseRoles['zone6'] ?? _spot(recvHalf, 0.15, 0.50);
    final zone1 = baseRoles['zone1'] ?? _spot(recvHalf, 0.15, 0.66);

    final out = <int, Offset>{};
    switch (spec.numPassers.clamp(2, 4)) {
      case 2:
        final seam16 = _mid(zone1, zone6);
        final seam56 = _mid(zone5, zone6);
        if (passers.isNotEmpty) out[passers[0]] = seam16;
        if (passers.length > 1) out[passers[1]] = seam56;
        break;

      case 3:
        final spots = [zone5, zone6, zone1];
        for (var i = 0; i < passers.length && i < spots.length; i++) {
          out[passers[i]] = spots[i];
        }
        break;

      case 4:
        final q = _quarters(recvHalf);
        final spots = q.isNotEmpty
            ? q
            : [zone5, zone6, zone1, _spot(recvHalf, 0.28, 0.50)];
        for (var i = 0; i < passers.length && i < spots.length; i++) {
          out[passers[i]] = spots[i];
        }
        break;
    }

    return ServeReceivePlanOutput(receiveSpots: out);
  }

  Rect _half(Rect court, TeamSide side) {
    final cx = court.left + court.width / 2;
    return (side == TeamSide.home)
        ? Rect.fromLTRB(court.left, court.top, cx, court.bottom)
        : Rect.fromLTRB(cx, court.top, court.right, court.bottom);
  }

  Offset _spot(Rect r, double nx, double ny) =>
      Offset(r.left + r.width * nx, r.top + r.height * ny);

  Offset _mid(Offset a, Offset b) =>
      Offset((a.dx + b.dx) * 0.5, (a.dy + b.dy) * 0.5);

  List<Offset> _quarters(Rect r) => [
    _spot(r, 0.25, 0.33),
    _spot(r, 0.75, 0.33),
    _spot(r, 0.25, 0.66),
    _spot(r, 0.75, 0.66),
  ];
}
