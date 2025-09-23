import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

/// Yellow ball that lerps from A -> B. Renders above players.
class BallComponent extends PositionComponent {
  BallComponent({
    this.radius = 10.0,
    this.fill = const Color(0xFFFFEB3B),
    this.stroke = const Color(0xFF000000),
    Vector2? position,
    Anchor anchor = Anchor.center,
    int priority = 1000,
  }) : super(
         size: Vector2.all(radius * 2),
         anchor: anchor,
         position: position ?? Vector2.zero(),
         priority: priority,
       );

  double radius;
  Color fill;
  Color stroke;

  bool _visible = false;
  bool _animating = false;
  final Vector2 _from = Vector2.zero();
  final Vector2 _to = Vector2.zero();
  double _t = 0.0;
  double _dur = 1.0;
  void Function()? _onComplete;

  @override
  void render(Canvas canvas) {
    if (!_visible) return;
    final center = Offset(size.x / 2, size.y / 2);
    canvas.drawCircle(center, radius, Paint()..color = fill);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_animating) return;

    _t += dt;
    final u = (_t / _dur).clamp(0.0, 1.0);
    final e = 1.0 - (1.0 - u) * (1.0 - u); // ease-out
    position
      ..x = _from.x + (_to.x - _from.x) * e
      ..y = _from.y + (_to.y - _from.y) * e;

    if (u >= 1.0) {
      _animating = false;
      _visible = false;
      final cb = _onComplete;
      _onComplete = null;
      cb?.call();
    }
  }

  void serve({
    required Offset from,
    required Offset to,
    double durationSec = 0.9,
    void Function()? onComplete,
  }) {
    _from.setValues(from.dx, from.dy);
    _to.setValues(to.dx, to.dy);
    position.setFrom(_from);
    _dur = durationSec > 0 ? durationSec : 0.001;
    _t = 0.0;
    _onComplete = onComplete;
    _visible = true;
    _animating = true;
  }
}
