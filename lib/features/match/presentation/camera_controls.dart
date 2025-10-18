import 'package:flutter/material.dart';

enum CameraView { large, small }

class CameraControls extends StatelessWidget {
  const CameraControls({
    super.key,
    required this.currentView,
    required this.onToggle,
  });

  final CameraView currentView;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        heroTag: 'toggleCamera',
        onPressed: onToggle,
        tooltip: currentView == CameraView.large
            ? 'Switch to small court view'
            : 'Switch to large court view',
        child: Icon(
          currentView == CameraView.large
              ? Icons.crop_square
              : Icons.fullscreen,
        ),
      ),
    );
  }
}
