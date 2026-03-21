import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

/// Ball component with physically-motivated height simulation.
///
/// All flights use a [fromHeightM] / [toHeightM] / [peakHeightM] / [peakT]
/// model (all in metres).  Two visual effects are derived from the current
/// height in every frame:
///
///   • **Scale** — ball is larger when higher (top-down camera, ball closer).
///     Formula: `effectiveRadius = radius * (1 + height * _kScale)`
///
///   • **Screen-Y lift** — ball is shifted upward on screen proportionally
///     to height, giving a sense of depth.
///     Formula: `screenY = linearY - height * _kLiftPx`
///
/// Typical heights (metres):
///   serve         3 m → 1 m  (descending from contact to receiver)
///   pass          1 m → 3 m  (rising from receiver to setter)
///   set / attack  3 m peak at attacker contact
///   bounce        damped decay at landing spot (end-of-rally)
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

  // ---------------------------------------------------------------------------
  // Visual constants — tune these to taste
  // ---------------------------------------------------------------------------

  /// Scale multiplier added per metre of height.
  /// At 10 m: radius × (1 + 10 × 0.06) = radius × 1.6
  static const double _kScale = 0.06;

  /// Screen pixels to lift the ball per metre of height.
  static const double _kLiftPx = 4.0;

  // ---------------------------------------------------------------------------
  // Flying state
  // ---------------------------------------------------------------------------

  bool _animating = false;
  final Vector2 _from = Vector2.zero();
  final Vector2 _to = Vector2.zero();
  double _t = 0.0;
  double _dur = 1.0;
  void Function()? _onComplete;

  double _fromHeightM = 0.0;
  double _toHeightM = 0.0;
  double _peakHeightM = 0.0;
  double _peakT = 0.5;

  // ---------------------------------------------------------------------------
  // Bounce state (end-of-rally)
  // ---------------------------------------------------------------------------

  bool _bouncing = false;
  final Vector2 _bouncePos = Vector2.zero();
  double _bounceT = 0.0;
  double _bounceDur = 2.0;
  double _bounceInitialH = 1.0;

  // ---------------------------------------------------------------------------
  // Rendering
  // ---------------------------------------------------------------------------

  @override
  void render(Canvas canvas) {
    final r = size.x / 2;
    final center = Offset(r, r);
    canvas.drawCircle(center, r, Paint()..color = fill);
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  // ---------------------------------------------------------------------------
  // Update
  // ---------------------------------------------------------------------------

  @override
  void update(double dt) {
    super.update(dt);

    if (_bouncing) {
      _updateBounce(dt);
      return;
    }

    if (!_animating) return;

    _t += dt;
    final u = (_t / _dur).clamp(0.0, 1.0);

    // Ease-out for horizontal travel
    final e = 1.0 - (1.0 - u) * (1.0 - u);

    final heightM = _heightAt(u);
    _applyHeight(heightM);

    position
      ..x = _from.x + (_to.x - _from.x) * e
      ..y = (_from.y + (_to.y - _from.y) * e) - heightM * _kLiftPx;

    if (u >= 1.0) {
      _animating = false;
      _applyHeight(_toHeightM);
      position
        ..x = _to.x
        ..y = _to.y - _toHeightM * _kLiftPx;
      final cb = _onComplete;
      _onComplete = null;
      cb?.call();
    }
  }

  void _updateBounce(double dt) {
    _bounceT += dt;
    final u = (_bounceT / _bounceDur).clamp(0.0, 1.0);

    // Decaying amplitude × rectified sine gives natural bounce shape.
    // 3.5 half-periods ≈ 3 visible bounces before the ball settles.
    final decay = math.pow(1.0 - u, 1.5) as double;
    final heightM = _bounceInitialH * decay * math.sin(u * 3.5 * math.pi).abs();

    _applyHeight(heightM);
    position
      ..x = _bouncePos.x
      ..y = _bouncePos.y - heightM * _kLiftPx;

    if (u >= 1.0) {
      _bouncing = false;
      final cb = _onComplete;
      _onComplete = null;
      cb?.call();
    }
  }

  // ---------------------------------------------------------------------------
  // Height arc helpers
  // ---------------------------------------------------------------------------

  /// Smooth bell: 0 at u=0, 1 at u=peakT, 0 at u=1.
  static double _bell(double u, double peakT) {
    if (u <= peakT) {
      final t = peakT > 0 ? u / peakT : 0.0;
      return math.sin(t * math.pi / 2);
    } else {
      final t = peakT < 1.0 ? (u - peakT) / (1.0 - peakT) : 1.0;
      return math.cos(t * math.pi / 2);
    }
  }

  /// Height at normalised time [u] given the current arc parameters.
  double _heightAt(double u) {
    final baseH = _fromHeightM + (_toHeightM - _fromHeightM) * u;
    final baseAtPeak = _fromHeightM + (_toHeightM - _fromHeightM) * _peakT;
    final amplitude = (_peakHeightM - baseAtPeak).clamp(0.0, 100.0);
    return baseH + amplitude * _bell(u, _peakT);
  }

  void _applyHeight(double heightM) {
    final r = radius * (1.0 + heightM * _kScale);
    size.setAll(r * 2);
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Serve arc: ball descends from contact height (~3 m) to receiver (~1 m).
  void serve({
    required Offset from,
    required Offset to,
    double durationSec = 0.9,
    void Function()? onComplete,
  }) {
    _fromHeightM = 3.0;
    _toHeightM = 1.0;
    _peakHeightM = 3.0;
    _peakT = 0.0;
    _startFly(from: from, to: to, durationSec: durationSec, onComplete: onComplete);
  }

  /// Generic ball flight for passes, sets, and attacks.
  ///
  /// For a **set to attacker** use [peakT] = 1.0 so the ball is still rising
  /// when it reaches the attacker (they contact it at peak height).
  void fly({
    required Offset from,
    required Offset to,
    double durationSec = 0.6,
    double fromHeightM = 0.0,
    double toHeightM = 2.5,
    double peakHeightM = 3.5,
    double peakT = 0.8,
    void Function()? onComplete,
  }) {
    _fromHeightM = fromHeightM;
    _toHeightM = toHeightM;
    _peakHeightM = peakHeightM;
    _peakT = peakT;
    _startFly(from: from, to: to, durationSec: durationSec, onComplete: onComplete);
  }

  /// Damped-bounce animation at a fixed screen position (end-of-rally).
  void bounce({
    required Offset at,
    double fromHeightM = 0.5,
    double durationSec = 2.0,
    void Function()? onComplete,
  }) {
    _bouncePos.setValues(at.dx, at.dy);
    _bounceT = 0.0;
    _bounceDur = durationSec > 0 ? durationSec : 0.001;
    _bounceInitialH = fromHeightM.clamp(0.05, 10.0);
    _onComplete = onComplete;
    _animating = false;
    _bouncing = true;
    _applyHeight(_bounceInitialH);
    position.setValues(at.dx, at.dy - _bounceInitialH * _kLiftPx);
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  void _startFly({
    required Offset from,
    required Offset to,
    required double durationSec,
    void Function()? onComplete,
  }) {
    _from.setValues(from.dx, from.dy);
    _to.setValues(to.dx, to.dy);
    _dur = durationSec > 0 ? durationSec : 0.001;
    _t = 0.0;
    _onComplete = onComplete;
    _bouncing = false;
    _applyHeight(_fromHeightM);
    position.setValues(_from.x, _from.y - _fromHeightM * _kLiftPx);
    _animating = true;
  }
}
