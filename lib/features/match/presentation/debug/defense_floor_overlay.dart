// lib/features/match/presentation/debug/defense_floor_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:volleyball_manager/features/match/engine/outcomes/outcomes.dart';
import 'package:volleyball_manager/features/match/state/match_state.dart';
import 'package:volleyball_manager/features/match/state/defense_floor_state.dart';

/// Overlay for configuring floor-defence coverage per (team, rotation,
/// attack direction, blocker count).
///
/// Mirrors the structure of ServeReceiveDebugOverlay:
///   - Team picker (Home / Away)
///   - Rotation picker (1–6)
///   - Attack direction picker (SetOutcome)
///   - Blocker count selector (1 / 2 / 3)
///   - Per-role zone assignment (Zone 1 · Zone 5 · Zone 6)
///   - Reset button to restore engine defaults
class DefenseFloorOverlay extends ConsumerStatefulWidget {
  const DefenseFloorOverlay({
    super.key,
    required this.getCurrentRotationIndex,
    this.onClose,
  });

  final int Function(TeamSide side) getCurrentRotationIndex;
  final VoidCallback? onClose;

  @override
  ConsumerState<DefenseFloorOverlay> createState() =>
      _DefenseFloorOverlayState();
}

class _DefenseFloorOverlayState extends ConsumerState<DefenseFloorOverlay> {
  TeamSide side = TeamSide.home;
  int? pickedRot;
  SetOutcome pickedSet = SetOutcome.leftSideHigh;
  int blockerCount = 2;

  int _effectiveRot() =>
      (pickedRot ?? widget.getCurrentRotationIndex(side)).clamp(1, 6);

  static const _zoneLabels = <int, String>{
    1: '1  (Right-Back)',
    5: '5  (Left-Back)',
    6: '6  (Mid-Back)',
  };

  static const _setLabels = <SetOutcome, String>{
    SetOutcome.leftSideHigh:    'Left  High',
    SetOutcome.leftSideTempo:   'Left  Tempo',
    SetOutcome.rightSideHigh:   'Right High',
    SetOutcome.rightSideTempo:  'Right Tempo',
    SetOutcome.middle:          'Middle',
    SetOutcome.pipe:            'Pipe',
    SetOutcome.backrow:         'Back Row',
    SetOutcome.tip:             'Tip',
  };

  @override
  Widget build(BuildContext context) {
    final rot = _effectiveRot();

    final floor = ref.watch(
      defenseFloorProvider.select(
        (m) => m[(side, rot)]?.forAttack(pickedSet, blockerCount) ?? const {},
      ),
    );

    return Material(
      color: Colors.black.withValues(alpha: 0.6),
      child: Align(
        alignment: Alignment.topLeft,
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
                // ── Header ──────────────────────────────────────────────
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Defense Floor Tactics',
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

                // ── Team + Rotation ──────────────────────────────────────
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
                      onPressed: (i) => setState(() {
                        side = i == 0 ? TeamSide.home : TeamSide.away;
                      }),
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
                        if (v != null) setState(() => pickedRot = v);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ── Attack direction ─────────────────────────────────────
                Row(
                  children: [
                    const Text(
                      'Attack:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<SetOutcome>(
                        isExpanded: true,
                        value: pickedSet,
                        items: SetOutcome.values
                            .where((s) => s != SetOutcome.tip)
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(_setLabels[s] ?? s.name),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => pickedSet = v);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ── Blocker count ────────────────────────────────────────
                Row(
                  children: [
                    const Text(
                      'Blockers:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    ToggleButtons(
                      isSelected: [1, 2, 3].map((n) => n == blockerCount).toList(),
                      onPressed: (i) => setState(() => blockerCount = i + 1),
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('1'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('2'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('3'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ── Floor role zone pickers ──────────────────────────────
                if (floor.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'No floor defenders for this configuration.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                else
                  ...floor.entries.map((entry) {
                    final role = entry.key;
                    final currentZone =
                        nearestFloorZone(side, entry.value);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: Text(
                              role,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButton<int>(
                              isExpanded: true,
                              value: currentZone,
                              items: _zoneLabels.entries
                                  .map(
                                    (z) => DropdownMenuItem(
                                      value: z.key,
                                      child: Text(z.value),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (z) {
                                if (z == null) return;
                                ref
                                    .read(defenseFloorProvider.notifier)
                                    .setRoleZone(
                                      side: side,
                                      rotation: rot,
                                      set: pickedSet,
                                      blockerCount: blockerCount,
                                      role: role,
                                      zone: z,
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                const SizedBox(height: 8),

                // ── Reset button ─────────────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.restart_alt, size: 18),
                    label: const Text('Reset rotation to default'),
                    onPressed: () {
                      ref
                          .read(defenseFloorProvider.notifier)
                          .resetToDefault(side, rot);
                    },
                  ),
                ),

                // ── Legend ───────────────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Legend: L = Libero, OH1/2 = Outside Hitters, '
                    'OPP = Opposite, S = Setter',
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
