import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lightweight debug state for match diagnostics shown in the live log overlay.
class MatchDebugState extends ChangeNotifier {
  MatchDebugState._internal();
  static final MatchDebugState I = MatchDebugState._internal();

  int homeRotation = 1;
  int awayRotation = 1;

  void update({required int home, required int away}) {
    if (homeRotation == home && awayRotation == away) return;
    homeRotation = home;
    awayRotation = away;
    notifyListeners();
  }
}

final matchDebugStateProvider =
    ChangeNotifierProvider<MatchDebugState>((_) => MatchDebugState.I);
