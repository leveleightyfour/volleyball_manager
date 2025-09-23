import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

/// Debug overlay: zone labels + rotation/server HUD.
/// Controlled with [isEnabled]. Defaults to false.
class ZoneOverlayComponent extends Component with HasGameRef {
  ZoneOverlayComponent({bool isEnabled = false}) : _isEnabled = isEnabled;

  bool _isEnabled;

  bool get isEnabled => _isEnabled;
  set isEnabled(bool value) => _isEnabled = value;

  Rect? courtRect;
  Map<int, Offset>? homeCenters;
  Map<int, Offset>? awayCenters;
  int rotationTick = 0;
  String servingLabel = 'HOME';

  final _labelPaint = TextPaint(
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFFFFFF),
      shadows: [Shadow(blurRadius: 2, offset: Offset(0, 1))],
    ),
  );

  final _hudPaint = TextPaint(
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFFFFFF),
      shadows: [Shadow(blurRadius: 4, offset: Offset(0, 2))],
    ),
  );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (!_isEnabled || courtRect == null) return;

    _hudPaint.render(
      canvas,
      'Rotation: $rotationTick   Serving: $servingLabel',
      Vector2(12, 12),
    );

    void drawCenters(Map<int, Offset>? centers) {
      if (centers == null) return;
      for (final entry in centers.entries) {
        final c = entry.value;
        final bg = Paint()
          ..color = const Color(0x99000000)
          ..style = PaintingStyle.fill;
        final r = Rect.fromCircle(center: c, radius: 12);
        canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(12)),
          bg,
        );
        _labelPaint.render(
          canvas,
          entry.key.toString(),
          Vector2(c.dx - 4.5, c.dy - 8.5),
        );
      }
    }

    drawCenters(homeCenters);
    drawCenters(awayCenters);
  }
}
