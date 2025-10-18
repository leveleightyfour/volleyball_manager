// lib/features/match/presentation/debug/live_log_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volleyball_manager/shared/log/live_log.dart';

class LiveLogOverlay extends ConsumerStatefulWidget {
  const LiveLogOverlay({super.key});
  @override
  ConsumerState<LiveLogOverlay> createState() => _LiveLogOverlayState();
}

class _LiveLogOverlayState extends ConsumerState<LiveLogOverlay> {
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lines = ref.watch(liveLogProvider.select((l) => l.lines));

    // Auto-scroll to bottom on new content (only if already at or near bottom)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      final max = _scrollCtrl.position.maxScrollExtent;
      final off = _scrollCtrl.offset;
      final nearBottom = (max - off) < 60;
      if (nearBottom) {
        _scrollCtrl.jumpTo(max);
      }
    });

    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 520,
            maxHeight: 150,
            minWidth: 260,
            minHeight: 120,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.70),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Scrollbar(
                controller: _scrollCtrl, // <-- same controller
                thumbVisibility: true,
                interactive: true,
                child: ListView.builder(
                  // <-- the attached scrollable
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  itemCount: lines.length,
                  itemBuilder: (context, i) {
                    final line = lines[i];
                    return Text(
                      line.text,
                      style: TextStyle(
                        color: line.color,
                        fontSize: 12.0,
                        height: 1.2,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
