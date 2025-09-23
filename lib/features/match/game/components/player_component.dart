import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/painting.dart';
import 'package:volleyball_manager/shared/models/team_style.dart';

class PlayerComponent extends PositionComponent {
  PlayerComponent.fromTeamStyle({
    required this.number,
    required TeamStyle teamStyle,
    required bool isLibero,
    required double radius,
    this.displayName = '',
    this.roleLabel = '',
    Anchor anchor = Anchor.center,
    Vector2? position,
    int? priority,
  }) : kit = isLibero ? teamStyle.libero : teamStyle.regular,
       _radius = radius,
       super(
         size: Vector2(radius * 2, radius * 2 + 24),
         anchor: anchor,
         position: position ?? Vector2.zero(),
         priority: priority ?? 2,
       ) {
    _rebuildTextPaints();
  }

  PlayerComponent.manual({
    required this.number,
    required KitStyle kit,
    required double radius,
    this.displayName = '',
    this.roleLabel = '',
    Anchor anchor = Anchor.center,
    Vector2? position,
    int? priority,
  }) : kit = kit,
       _radius = radius,
       super(
         size: Vector2(radius * 2, radius * 2 + 24),
         anchor: anchor,
         position: position ?? Vector2.zero(),
         priority: priority ?? 2,
       ) {
    _rebuildTextPaints();
  }

  // --------- public API ----------
  int number;
  KitStyle kit;

  String displayName; // e.g., "Smith"
  String roleLabel; // e.g., "OH", "S", "MB", "OPP", "L"

  void setHidden(bool v) => _hidden = v;
  void setNumber(int n) => number = n;
  void setDisplayName(String name) => displayName = name;
  void setRoleLabel(String label) => roleLabel = label;

  // --------- internals ----------
  final double _radius;
  bool _hidden = false;

  late TextPaint _numPaint;
  late TextPaint _labelPaint;

  void _rebuildTextPaints() {
    _numPaint = TextPaint(
      style: TextStyle(
        fontFamily: kit.numberFontFamily,
        fontSize: kit.numberFontSize,
        fontWeight: kit.numberFontWeight,
        color: kit.text,
      ),
    );
    _labelPaint = TextPaint(
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    if (_hidden) return;

    // circle area (top)
    final circleDiameter = _radius * 2;
    final circleCenter = Offset(_radius, _radius);

    // soft drop shadow
    final shadow = Paint()
      ..color = const Color(0xFF000000).withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(circleCenter + const Offset(0, 2), _radius, shadow);

    // jersey fill (solid)
    final fill = Paint()
      ..color = kit.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(circleCenter, _radius, fill);

    // border
    if (kit.borderWidth > 0) {
      final border = Paint()
        ..color = kit.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = kit.borderWidth;
      canvas.drawCircle(circleCenter, _radius - kit.borderWidth / 2, border);
    }

    // number (centered)
    final numTp = _numPaint.toTextPainter(number.toString());
    numTp.paint(
      canvas,
      circleCenter - Offset(numTp.width / 2, numTp.height / 2),
    );

    // ------- dynamic label pill under the circle -------
    final hasName = displayName.trim().isNotEmpty;
    final hasRole = roleLabel.trim().isNotEmpty;
    if (hasName || hasRole) {
      final rawText = hasName && hasRole
          ? '$displayName • $roleLabel'
          : (hasName ? displayName : roleLabel);

      // Measure text at base size
      const baseFontSize = 11.0;
      const minFontSize = 9.0; // tiny fallback if super long
      const padH = 6.0;
      const labelH = 16.0;

      // Allow pill to extend past the circle a bit if needed
      final maxPillWidth = size.x + 44.0; // circle width + some slack

      // Try base size; shrink if needed to keep within max
      double useFontSize = baseFontSize;
      TextPaint measurePaint(double fs) => TextPaint(
        style: TextStyle(
          fontSize: fs,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFFFFFFF),
        ),
      );

      var tp = measurePaint(useFontSize).toTextPainter(rawText);
      var pillW = tp.width + padH * 2;

      if (pillW > maxPillWidth && useFontSize > minFontSize) {
        // Simple scale down to fit
        final targetTextW = maxPillWidth - padH * 2;
        final scale = (targetTextW / tp.width).clamp(
          minFontSize / baseFontSize,
          1.0,
        );
        useFontSize = (baseFontSize * scale).clamp(minFontSize, baseFontSize);
        tp = measurePaint(useFontSize).toTextPainter(rawText);
        pillW = tp.width + padH * 2;
      }

      // Position & draw pill
      final labelTop = circleDiameter + 4.0;
      final pillX = (size.x - pillW) / 2; // center under circle

      final pillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(pillX, labelTop, pillW, labelH),
        const Radius.circular(7),
      );

      final pillBg = Paint()..color = const Color(0xAA000000);
      final pillSt = Paint()
        ..color = const Color(0x33000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRRect(pillRect, pillBg);
      canvas.drawRRect(pillRect, pillSt);

      // Draw text centered within pill
      final labelPaint = TextPaint(
        style: TextStyle(
          fontSize: useFontSize,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFFFFFFF),
        ),
      );
      final textOffset = Offset(
        pillX + (pillW - tp.width) / 2,
        labelTop + (labelH - tp.height) / 2,
      );
      labelPaint.render(canvas, rawText, Vector2(textOffset.dx, textOffset.dy));
    }
  }

  void applyTeamStyle(TeamStyle style, {required bool isLibero}) {
    kit = isLibero ? style.libero : style.regular;
    _rebuildTextPaints();
  }
}
