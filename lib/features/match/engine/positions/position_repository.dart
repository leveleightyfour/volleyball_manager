import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'position_models.dart';

class PositionRepository {
  PositionBook? _cache;

  Future<PositionBook> loadFromAssets({
    String path = 'assets/config/positions.json',
  }) async {
    if (_cache != null) return _cache!;

    final txt = await rootBundle.loadString(path);
    final root = jsonDecode(txt) as Map<String, dynamic>;
    final layouts = _flattenToLayouts(root);

    _cache = PositionBook(layouts: layouts);
    return _cache!;
  }
}

/// Flattens hierarchical JSON into "<phase>/<team>/<rotation>/<tactic>" keys.
///
/// Supported rotation node shapes:
///  A) { "roles": { ... } }                      -> stored as tactic "default"
///  B) { "2passers": {roles:{...}}, ... }        -> each key becomes a tactic
///
/// Your current file is shape A, so it becomes '.../default'.
Map<String, PositionLayout> _flattenToLayouts(Map<String, dynamic> root) {
  final out = <String, PositionLayout>{};

  final dataDyn = root['data'] ?? root;
  final data = (dataDyn as Map).cast<String, dynamic>();

  PositionLayout _toLayout(Map<String, dynamic> node) {
    final rolesDyn = (node['roles'] ?? node) as Map;
    final rolesMap = rolesDyn.cast<String, dynamic>();

    final roles = <String, RolePoint>{};
    rolesMap.forEach((role, val) {
      final vm = (val as Map).cast<String, dynamic>();
      roles[role] = RolePoint.fromJson(vm);
    });
    return PositionLayout(roles: roles);
  }

  data.forEach((phase, teamsDyn) {
    final teams = (teamsDyn as Map).cast<String, dynamic>();
    teams.forEach((team, rotsDyn) {
      final rots = (rotsDyn as Map).cast<String, dynamic>();
      rots.forEach((rot, nodeDyn) {
        final node = (nodeDyn as Map).cast<String, dynamic>();

        final hasRolesDirect =
            node.containsKey('roles') ||
            node.values.any((v) => v is Map && (v as Map).containsKey('x'));

        if (hasRolesDirect) {
          out[positionKey(phase, team, rot, tactic: 'default')] = _toLayout(
            node,
          );
          return;
        }

        // Case B: multiple tactics under the rotation
        node.forEach((tactic, tacticNodeDyn) {
          final tacticNode = (tacticNodeDyn as Map).cast<String, dynamic>();
          out[positionKey(phase, team, rot, tactic: tactic)] = _toLayout(
            tacticNode,
          );
        });
      });
    });
  });

  return out;
}
