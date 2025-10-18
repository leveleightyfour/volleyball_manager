// features/match/engine/positions/position_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'position_models.dart';

class PositionRepository {
  final String assetPath;
  PositionRepository({this.assetPath = 'assets/config/positions.json'});

  Future<PositionBook> loadFromAssets() async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      if (raw.trim().isEmpty) return PositionBook.empty();

      final Map<String, dynamic> json = jsonDecode(raw);
      // Expecting FLAT structure: { "<phase>|<team>|rX|<tactic>": {roles:{}, anchors:{}}, ... }
      final map = <String, PositionLayout>{};
      for (final entry in json.entries) {
        final key = entry.key;
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          map[key] = PositionLayout.fromJson(value);
        }
      }
      print('Loaded ${map.length} position layouts');
      for (final key in map.keys.take(20)) {
        print(' → $key');
      }
      return PositionBook(layouts: map);
    } catch (e) {
      // Safe fallback so app boots without the asset.
      return PositionBook.empty();
    }
  }
}
