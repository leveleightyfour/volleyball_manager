// lib/features/match/game/services/camera_controller.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

/// Manages camera positioning, zoom levels, and gesture interactions for the match view.
///
/// Responsibilities:
/// - Camera positioning (center, top-left, custom positions)
/// - Zoom management with constraints
/// - Pan and pinch gesture handling
/// - View mode switching (full court, tactical quarter view, etc.)
class CameraController {
  CameraController({
    required this.getCamera,
    required this.getCanvasSize,
    required this.getCourtBounds,
    this.minZoom = 0.5,
    this.maxZoom = 3.0,
    this.courtPadding = 16.0,
  });

  /// Callback to get the current camera component
  final CameraComponent? Function() getCamera;

  /// Callback to get the current canvas size
  final Vector2 Function() getCanvasSize;

  /// Callback to get the court bounds
  final Rect Function() getCourtBounds;

  /// Minimum zoom level
  final double minZoom;

  /// Maximum zoom level
  final double maxZoom;

  /// Padding around court
  final double courtPadding;

  // Gesture state
  double _zoomAtGestureStart = 1.0;
  Vector2? _lastFingerPosition;
  bool _gesturesEnabled = false;

  // Saved positions for view modes
  Vector2? _smallCourtPosition;
  double? _smallCourtZoom;

  /// Enable or disable gesture controls
  void setGesturesEnabled(bool enabled) {
    _gesturesEnabled = enabled;
  }

  /// Get current gesture enabled state
  bool get gesturesEnabled => _gesturesEnabled;

  // ------------- Camera Positioning Methods -------------

  /// Snap camera to center of current canvas with optional zoom.
  void centerCourt({double? zoom}) {
    final cam = getCamera();
    if (cam == null) return;

    final size = getCanvasSize();
    cam.viewfinder
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, size.y / 2);

    if (zoom != null) {
      cam.viewfinder.zoom = zoom.clamp(minZoom, maxZoom);
    }
  }

  /// Fit full court width to viewport, then center.
  void fitCourtToWidth() {
    final cam = getCamera();
    if (cam == null) return;

    cam.viewfinder.zoom = _computeZoomToFitWidth();
    centerCourt();
  }

  /// Pin world origin to top-left of the screen (tactical view), optional zoom.
  void pinCourtTopLeft({double? zoom}) {
    final cam = getCamera();
    if (cam == null) return;

    cam.viewfinder
      ..anchor = Anchor.topLeft
      ..position = Vector2.zero();

    if (zoom != null) {
      cam.viewfinder.zoom = zoom.clamp(minZoom, maxZoom);
    }
  }

  /// Set explicit zoom level.
  void setCourtZoom(double z) {
    final cam = getCamera();
    if (cam == null) return;

    cam.viewfinder.zoom = z.clamp(minZoom, maxZoom);
  }

  /// Position court in top-left quarter with padding
  void positionCourtTopLeftQuarter({
    double padding = 50.0,
    bool restorePrevious = true,
  }) {
    final cam = getCamera();
    if (cam == null) return;

    // If we have a previous position saved and should restore it, use that
    if (restorePrevious && _smallCourtPosition != null && _smallCourtZoom != null) {
      cam.viewfinder.zoom = _smallCourtZoom!;
      cam.viewfinder.position = _smallCourtPosition!.clone();
      return;
    }

    final size = getCanvasSize();
    final courtBounds = getCourtBounds();

    // Court should fit in top-left quadrant (half screen width, half screen height)
    final quadrantWidth = size.x / 2;
    final quadrantHeight = size.y / 2;
    final courtWidth = courtBounds.width;
    final courtHeight = courtBounds.height;

    // Calculate zoom to fit court in quadrant with padding
    final zoomX = (quadrantWidth - padding * 2) / courtWidth;
    final zoomY = (quadrantHeight - padding * 2) / courtHeight;
    final zoom = zoomX < zoomY ? zoomX : zoomY;

    cam.viewfinder.zoom = zoom.clamp(minZoom, maxZoom);

    // Calculate where court should appear on screen
    final courtWidthOnScreen = courtWidth * zoom;
    final courtHeightOnScreen = courtHeight * zoom;

    // We want court edges at 'padding' pixels from screen edges
    final targetScreenX = padding + courtWidthOnScreen / 2;
    final targetScreenY = padding + courtHeightOnScreen / 2;

    // Camera looks at center of viewport, convert target screen pos to world pos
    final worldOffsetX = (targetScreenX - size.x / 2) / zoom;
    final worldOffsetY = (targetScreenY - size.y / 2) / zoom;

    final position = Vector2(
      courtBounds.left + courtBounds.width / 2 - worldOffsetX,
      courtBounds.top + courtBounds.height / 2 - worldOffsetY,
    );

    cam.viewfinder.position = position;
    _smallCourtPosition = position.clone();
    _smallCourtZoom = cam.viewfinder.zoom;
  }

  /// Position court in top 2/3 of screen with padding
  void positionCourtTopTwoThirds({double padding = 96.0}) {
    final cam = getCamera();
    if (cam == null) return;

    final size = getCanvasSize();
    final courtBounds = getCourtBounds();

    // Calculate zoom to fit court width with padding
    final availableWidth = size.x;
    final courtWidth = courtBounds.width;

    // Make court slightly thinner by increasing effective padding
    final effectivePadding = padding * 1.2;
    final zoom = (availableWidth - effectivePadding * 2) / courtWidth;

    cam.viewfinder.zoom = zoom.clamp(minZoom, maxZoom);

    // Calculate court dimensions on screen
    final courtWidthOnScreen = courtWidth * zoom;
    final courtHeightOnScreen = courtBounds.height * zoom;

    // Calculate actual horizontal padding (space left after court fits on screen)
    final actualHorizontalPadding = (availableWidth - courtWidthOnScreen) / 2;

    // Use same padding for top
    final courtCenterScreenY = actualHorizontalPadding + courtHeightOnScreen / 2;

    // Convert screen offset to world offset
    final screenCenterY = size.y / 2;
    final offsetFromScreenCenter = courtCenterScreenY - screenCenterY;
    final worldYOffset = offsetFromScreenCenter / zoom;

    cam.viewfinder.position = Vector2(
      courtBounds.left + courtBounds.width / 2, // horizontally centered
      courtBounds.top + courtBounds.height / 2 - worldYOffset,
    );
  }

  // ------------- Gesture Handling -------------

  /// Handle gesture start event
  void onScaleStart(ScaleStartInfo info) {
    if (!_gesturesEnabled) return;

    final cam = getCamera();
    if (cam == null) return;

    _zoomAtGestureStart = cam.viewfinder.zoom;

    // Get the focal point in screen coordinates
    try {
      final focalPoint = (info.eventPosition as dynamic).global;
      if (focalPoint is Offset) {
        _lastFingerPosition = Vector2(focalPoint.dx, focalPoint.dy);
      } else if (focalPoint is Vector2) {
        _lastFingerPosition = focalPoint.clone();
      }
    } catch (_) {
      _lastFingerPosition = null;
    }
  }

  /// Handle gesture update event
  void onScaleUpdate(ScaleUpdateInfo info) {
    if (!_gesturesEnabled) return;

    final cam = getCamera();
    if (cam == null) return;

    final size = getCanvasSize();
    final courtBounds = getCourtBounds();
    final double scaleFactor = _asScaleFromInfo(info.scale);

    // Compute minimum zoom to ensure court width is at least 1/2 screen width
    final courtWidth = courtBounds.width;
    final screenWidth = size.x;
    final minZoomForCourtSize = courtWidth > 0 ? (screenWidth / 2) / courtWidth : minZoom;
    final effectiveMinZoom = minZoomForCourtSize.clamp(minZoom, maxZoom);

    // Update zoom
    final newZoom = (_zoomAtGestureStart * scaleFactor).clamp(effectiveMinZoom, maxZoom);
    cam.viewfinder.zoom = newZoom;

    // Get current finger position in screen coordinates
    Vector2? currentFingerPos;
    try {
      final focalPoint = (info.eventPosition as dynamic).global;
      if (focalPoint is Offset) {
        currentFingerPos = Vector2(focalPoint.dx, focalPoint.dy);
      } else if (focalPoint is Vector2) {
        currentFingerPos = focalPoint.clone();
      }
    } catch (_) {}

    // If we have both positions, move camera based on finger movement
    if (_lastFingerPosition != null && currentFingerPos != null) {
      final fingerDelta = currentFingerPos - _lastFingerPosition!;

      // Move camera opposite to finger movement (pan feels natural this way)
      final currentPos = cam.viewfinder.position;
      final newPos = currentPos - fingerDelta;

      // Constrain panning based on zoom level
      final viewportWidth = size.x / cam.viewfinder.zoom;
      final viewportHeight = size.y / cam.viewfinder.zoom;

      // Use court bounds with some extra margin for panning
      final paddedLeft = courtBounds.left - courtPadding;
      final paddedRight = courtBounds.right + courtPadding;
      final paddedTop = courtBounds.top - courtPadding;
      final paddedBottom = courtBounds.bottom + courtPadding;

      final paddedWidth = paddedRight - paddedLeft;
      final paddedHeight = paddedBottom - paddedTop;

      // Only apply bounds if zoomed in enough
      Vector2 finalPos;
      if (viewportWidth < paddedWidth && viewportHeight < paddedHeight) {
        // Zoomed in - apply bounds to keep court in view
        final minX = paddedLeft + viewportWidth / 2;
        final maxX = paddedRight - viewportWidth / 2;
        final minY = paddedTop + viewportHeight / 2;
        final maxY = paddedBottom - viewportHeight / 2;

        finalPos = Vector2(
          newPos.x.clamp(minX, maxX),
          newPos.y.clamp(minY, maxY),
        );
      } else {
        // Zoomed out - no bounds, allow free panning
        finalPos = newPos;
      }

      cam.viewfinder.position = finalPos;
      _lastFingerPosition = currentFingerPos;
    }
  }

  /// Handle gesture end event
  void onScaleEnd(ScaleEndInfo info) {
    if (!_gesturesEnabled) return;
    _lastFingerPosition = null;
  }

  // ------------- Private Helpers -------------

  double _computeZoomToFitWidth() {
    final cam = getCamera();
    final vpSize = cam?.viewport.size ?? getCanvasSize();
    if (vpSize.x == 0) return 1.0;
    return 1.0.clamp(minZoom, maxZoom);
  }

  double _asScaleFromInfo(dynamic scale) {
    // Try accessing global property (EventDelta with Vector2)
    try {
      final s = scale as dynamic;
      if (s.global != null) {
        // Handle Vector2 scale - use the x component
        if (s.global is Vector2) {
          final Vector2 v = s.global as Vector2;
          return v.x.toDouble();
        } else if (s.global is num) {
          return (s.global as num).toDouble();
        }
      }
    } catch (_) {}

    // Already num/double
    try {
      return (scale as num).toDouble();
    } catch (_) {}

    return 1.0;
  }
}
