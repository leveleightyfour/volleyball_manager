import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class LogLine {
  final DateTime at;
  final String text;
  final Color color;
  LogLine(this.text, {Color? color})
    : at = DateTime.now(),
      color = color ?? Colors.white;
}

/// ChangeNotifier store
class LiveLog extends ChangeNotifier {
  LiveLog._internal({this.maxLines = 200});
  static final LiveLog I = LiveLog._internal(); // 👈 singleton

  final int maxLines;
  final List<LogLine> _lines = [];
  List<LogLine> get lines => List.unmodifiable(_lines);

  void add(LogLine line) {
    _lines.add(line);
    if (_lines.length > maxLines) _lines.removeAt(0);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}

/// Riverpod provider (widgets can watch/refresh this)
final liveLogProvider = ChangeNotifierProvider<LiveLog>((_) => LiveLog.I);

/// Convenience logging helpers — usable with or without `ref`.
class log {
  // ---- With a ref (works for Ref and WidgetRef)
  static void i(Ref ref, String msg) {
    debugPrint(msg);
    ref.read(liveLogProvider).add(LogLine(msg, color: Colors.white));
  }

  static void w(Ref ref, String msg) {
    debugPrint(msg);
    ref.read(liveLogProvider).add(LogLine(msg, color: Colors.amber));
  }

  static void e(Ref ref, String msg) {
    debugPrint(msg);
    ref.read(liveLogProvider).add(LogLine(msg, color: Colors.redAccent));
  }

  // ---- Without a ref (plain Dart classes)
  static void i0(String msg) {
    debugPrint(msg);
    LiveLog.I.add(LogLine(msg, color: Colors.white));
  }

  static void w0(String msg) {
    debugPrint(msg);
    LiveLog.I.add(LogLine(msg, color: Colors.amber));
  }

  static void e0(String msg) {
    debugPrint(msg);
    LiveLog.I.add(LogLine(msg, color: Colors.redAccent));
  }
}
