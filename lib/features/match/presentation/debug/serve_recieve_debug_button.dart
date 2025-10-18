import 'package:flutter/material.dart';

class ServeReceiveDebugButton extends StatelessWidget {
  const ServeReceiveDebugButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Material(
            color: Colors.black54,
            shape: const StadiumBorder(),
            child: IconButton(
              icon: const Icon(Icons.tune, size: 20, color: Colors.white),
              tooltip: 'Serve Receive Debug',
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
