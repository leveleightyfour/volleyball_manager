import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

enum CourtOrientation { horizontalNetVertical }

/// Renders arena background + 18:9 court with correct attack line ratios.
/// The court is scaled by [courtScale] inside its given size.
class CourtComponent extends PositionComponent {
  CourtComponent({
    required Vector2 size,
    required Vector2 position,
    required this.orientation,
    this.arenaColor = const Color(0xFF1FB4DB),
    this.floorColor = const Color(0xFFE28E6C),
    this.lineColor = const Color(0xFFFFFFFF),
    this.lineWidth = 3.0,
    this.courtScale = 0.70,
    Anchor anchor = Anchor.topLeft,
  }) : super(size: size, position: position, anchor: anchor);

  final CourtOrientation orientation;
  final Color arenaColor;
  final Color floorColor;
  final Color lineColor;
  final double lineWidth;
  final double courtScale;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Arena background
    final arenaR = RRect.fromRectAndRadius(
      Offset.zero & Size(size.x, size.y),
      const Radius.circular(12),
    );
    canvas.drawRRect(arenaR, Paint()..color = arenaColor);

    // Fit an 18:9 court inside
    const aspect = 18 / 9;
    late double w, h;
    if (size.x / size.y >= aspect) {
      h = size.y;
      w = h * aspect;
    } else {
      w = size.x;
      h = w / aspect;
    }
    final fitted = Rect.fromLTWH((size.x - w) / 2, (size.y - h) / 2, w, h);
    final court = Rect.fromLTWH(
      fitted.left + fitted.width * (1 - courtScale) / 2,
      fitted.top + fitted.height * (1 - courtScale) / 2,
      fitted.width * courtScale,
      fitted.height * courtScale,
    );

    // Court floor
    final floorPaint = Paint()..color = floorColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(court, const Radius.circular(6)),
      floorPaint,
    );

    // Lines
    final lp = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    // Outer border
    canvas.drawRRect(
      RRect.fromRectAndRadius(court, const Radius.circular(6)),
      lp,
    );

    // Net (vertical center line splitting 18m → 9m / 9m)
    final netX = court.left + court.width / 2;
    canvas.drawLine(Offset(netX, court.top), Offset(netX, court.bottom), lp);

    // Attack lines: 3m from net on each side → 3/9 = 1/3 of half-court width
    final half = Rect.fromLTWH(
      court.left,
      court.top,
      court.width / 2,
      court.height,
    );
    final attackOffset = half.width / 3;

    // Left half attack line (home)
    final leftAttack = netX - attackOffset;
    canvas.drawLine(
      Offset(leftAttack, court.top),
      Offset(leftAttack, court.bottom),
      lp,
    );

    // Right half attack line (away)
    final rightAttack = netX + attackOffset;
    canvas.drawLine(
      Offset(rightAttack, court.top),
      Offset(rightAttack, court.bottom),
      lp,
    );
  }
}
