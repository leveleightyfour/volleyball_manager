// lib/features/match/presentation/debug/serve_recieve_debug_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:volleyball_manager/features/match/state/match_state.dart';
import 'package:volleyball_manager/features/match/state/tactics_state.dart'
    show buildComboKey, comboKey, tacticsProvider;

/// Debug overlay for configuring Serve–Receive tactics per rotation.
/// Includes:
/// - Team picker (Home/Away)
/// - Rotation picker (1..6)
/// - Passers count (2/3/4)
/// - Exact combo selector for that count (e.g., "L + OH1 + OPP")
///
/// Notes:
/// • This only edits the tactic book for the chosen (team, rotation).
/// • It does NOT affect the engine rotation; MatchGame will read these
///   when it lays out the receive formation for the *current* rotation.
class ServeReceiveDebugOverlay extends ConsumerStatefulWidget {
  const ServeReceiveDebugOverlay({
    super.key,
    required this.getCurrentRotationIndex, // (TeamSide) -> 1..6 (for initial hint)
    this.onClose,
  });

  final int Function(TeamSide side) getCurrentRotationIndex;
  final VoidCallback? onClose;

  @override
  ConsumerState<ServeReceiveDebugOverlay> createState() =>
      _ServeReceiveDebugOverlayState();
}

class _ServeReceiveDebugOverlayState
    extends ConsumerState<ServeReceiveDebugOverlay> {
  TeamSide side = TeamSide.home;
  int? pickedRot; // user-picked rotation; null means "use engine hint once"

  int _effectiveRot() {
    // If the user hasn’t picked yet, default to the engine-provided current rotation
    return (pickedRot ?? widget.getCurrentRotationIndex(side)).clamp(1, 6);
  }

  String _prettyCombo(String k) => k.replaceAll('+', ' + ');

  @override
  Widget build(BuildContext context) {
    final rot = _effectiveRot();

    // Read current spec for (team, rot). If null, getSpec initializes it.
    final spec =
        ref.watch(tacticsProvider.select((t) => t.byRot[(side, rot)])) ??
        ref.read(tacticsProvider.notifier).getSpec(side, rot);

    final numPassers = spec.numPassers.clamp(2, 4);
    final currentComboKey = buildComboKey(spec.passingRoles);

    final allowedKeys = ref
        .read(tacticsProvider.notifier)
        .allowedComboKeys(numPassers);

    // If current combo isn’t allowed (e.g., just switched passers count), pick first allowed
    final safeComboKey =
        allowedKeys.contains(currentComboKey) && allowedKeys.isNotEmpty
        ? currentComboKey
        : (allowedKeys.isNotEmpty ? allowedKeys.first : 'L+OH1');

    return Material(
      color: Colors.black.withOpacity(0.6),
      child: Align(
        alignment: Alignment.topRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 6),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Serve–Receive Tactics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      icon: const Icon(Icons.close),
                      onPressed: widget.onClose,
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Team + Rotation row
                Row(
                  children: [
                    const Text(
                      'Team:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    ToggleButtons(
                      isSelected: [
                        side == TeamSide.home,
                        side == TeamSide.away,
                      ],
                      onPressed: (i) {
                        setState(() {
                          side = i == 0 ? TeamSide.home : TeamSide.away;
                          // keep current pickedRot; it edits that team’s chosen rot
                        });
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Home'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Away'),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Text(
                      'Rotation:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: rot,
                      items: List.generate(
                        6,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text('r${i + 1}'),
                        ),
                      ),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => pickedRot = v);
                        // no write needed; we only change which (team, rot) we’re editing
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Passers count
                Row(
                  children: [
                    const Text(
                      'Passers:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: numPassers,
                      items: const [2, 3, 4]
                          .map(
                            (n) =>
                                DropdownMenuItem(value: n, child: Text('$n')),
                          )
                          .toList(),
                      onChanged: (n) {
                        if (n == null) return;
                        ref
                            .read(tacticsProvider.notifier)
                            .setNumPassers(side, rot, n);
                        // combo may become invalid; we don’t set here—UI below will snap
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Exact combo for this count
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Combo:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: safeComboKey,
                        items: allowedKeys
                            .map(
                              (k) => DropdownMenuItem(
                                value: k,
                                child: Text(_prettyCombo(k)),
                              ),
                            )
                            .toList(),
                        onChanged: (k) {
                          if (k == null) return;
                          ref
                              .read(tacticsProvider.notifier)
                              .setPassingComboKey(side, rot, k);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Legend
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Legend: L = Libero, OH1/2 = Outside Hitters, OPP = Opposite',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
