import 'dart:ui';
import '../state/match_state.dart';
import 'position_models.dart';

class PositionResolver {
  PositionResolver(this.book);
  final PositionBook book;

  Map<String, Offset> resolve({
    required PositionPhase phase,
    required int rotationIndex1to6,
    required TeamSide side,
    required Rect courtRect,
    String tactic = 'default',
  }) {
    final phaseKey = _phaseKey(phase);
    final rotKey = 'r$rotationIndex1to6';

    // 🔑 use the flat lookup now
    final layout = book.getLayout(phaseKey, 'home', rotKey, tactic: tactic);
    if (layout == null) return {};

    // split court into home (left) vs away (right) halves
    final cx = courtRect.left + courtRect.width / 2;
    final leftHalf = Rect.fromLTRB(
      courtRect.left,
      courtRect.top,
      cx,
      courtRect.bottom,
    );
    final rightHalf = Rect.fromLTRB(
      cx,
      courtRect.top,
      courtRect.right,
      courtRect.bottom,
    );
    final half = side == TeamSide.home ? leftHalf : rightHalf;

    Offset mapPoint(RolePoint p) {
      final nx = p.x.clamp(-0.10, 1.10);
      final ny = p.y.clamp(0.0, 1.0);

      final x = side == TeamSide.home
          ? half.left + half.width * nx
          : half.right - half.width * nx; // mirror horizontally
      final y = half.top + half.height * ny;

      return Offset(x, y);
    }

    return layout.roles.map((role, rp) => MapEntry(role, mapPoint(rp)));
  }

  String _phaseKey(PositionPhase p) {
    switch (p) {
      case PositionPhase.receive:
        return 'receive';
      case PositionPhase.serve:
        return 'serve';
      case PositionPhase.transition_offense:
        return 'transition_offense';
      case PositionPhase.defense:
        return 'defense';
    }
  }
}
