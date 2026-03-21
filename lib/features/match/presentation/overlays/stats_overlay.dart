// lib/features/match/presentation/overlays/stats_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volleyball_manager/features/match/state/match_stats_state.dart';
import 'package:volleyball_manager/features/match/state/match_state.dart' show TeamSide;

// ── Column descriptor ──────────────────────────────────────────────────────

class _Col {
  const _Col(this.header, this.color, this.extractor);
  final String header;
  final Color color;
  final int Function(PlayerMatchStats) extractor;
}

// ── Skill table definitions ────────────────────────────────────────────────

const _kStatW = 28.0; // width of each stat column

final _serveCols = <_Col>[
  _Col('att', Colors.white70, (p) => p.serve.attempts),
  _Col('ace', Colors.greenAccent, (p) => p.serve.count('ace')),
  _Col('flt', Colors.redAccent, (p) => p.serve.count('error')),
  _Col('in', Colors.white54, (p) =>
      p.serve.attempts - p.serve.count('ace') - p.serve.count('error')),
];

final _passCols = <_Col>[
  _Col('att', Colors.white70, (p) => p.pass.attempts),
  _Col('prf', const Color(0xFF80FF80), (p) => p.pass.count('perfect')),
  _Col('avg', Colors.white54, (p) => p.pass.count('average')),
  _Col('s/o', Colors.amber, (p) => p.pass.count('singleOption')),
  _Col('shk', Colors.redAccent, (p) => p.pass.count('shank')),
];


final _attackCols = <_Col>[
  _Col('att', Colors.white70, (p) => p.attack.attempts),
  _Col('kill', Colors.greenAccent, (p) => p.attack.count('kill')),
  _Col('blk', Colors.redAccent, (p) => p.attack.count('blocked')),
  _Col('dug', Colors.amber, (p) => p.attack.count('dug')),
  _Col('err', Colors.redAccent, (p) => p.attack.count('error')),
];

// ── Main overlay widget ────────────────────────────────────────────────────

class StatsOverlay extends ConsumerStatefulWidget {
  const StatsOverlay({super.key});

  @override
  ConsumerState<StatsOverlay> createState() => _StatsOverlayState();
}

class _StatsOverlayState extends ConsumerState<StatsOverlay> {
  bool _showPlayers = false;

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(matchStatsProvider);

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 12, top: 52),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white24),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420, maxHeight: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildScoreRow(stats),
                const Divider(height: 1, color: Colors.white24),
                _buildToggleHeader(),
                const Divider(height: 1, color: Colors.white24),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                    child: _showPlayers
                        ? _buildPlayerView(stats)
                        : _buildTeamView(stats),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Score ──────────────────────────────────────────────────────────────────

  Widget _buildScoreRow(MatchStatsNotifier stats) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('HOME',
                style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            Text('${stats.homeScore}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [FontFeature.tabularFigures()])),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child:
                  Text('–', style: TextStyle(color: Colors.white38, fontSize: 22)),
            ),
            Text('${stats.awayScore}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [FontFeature.tabularFigures()])),
            const SizedBox(width: 12),
            const Text('AWAY',
                style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );

  // ── Toggle header ──────────────────────────────────────────────────────────

  Widget _buildToggleHeader() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            const Text('MATCH STATS',
                style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8)),
            const Spacer(),
            _ToggleChip(
                label: 'TEAM',
                active: !_showPlayers,
                onTap: () => setState(() => _showPlayers = false)),
            const SizedBox(width: 6),
            _ToggleChip(
                label: 'PLAYER',
                active: _showPlayers,
                onTap: () => setState(() => _showPlayers = true)),
          ],
        ),
      );

  // ── Team view ──────────────────────────────────────────────────────────────

  Widget _buildTeamView(MatchStatsNotifier stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _teamColumnHeader(),
        const SizedBox(height: 4),
        _sectionLabel('SERVE'),
        _teamRow('att', stats.home.serve.attempts, stats.away.serve.attempts),
        _teamRow('ace', stats.home.serve.count('ace'),
            stats.away.serve.count('ace'),
            color: Colors.greenAccent),
        _teamRow('fault', stats.home.serve.count('error'),
            stats.away.serve.count('error'),
            color: Colors.redAccent),
        const SizedBox(height: 6),
        _sectionLabel('PASS'),
        _teamRow('att', stats.home.pass.attempts, stats.away.pass.attempts),
        _teamRow('perfect', stats.home.pass.count('perfect'),
            stats.away.pass.count('perfect'),
            color: const Color(0xFF80FF80)),
        _teamRow('average', stats.home.pass.count('average'),
            stats.away.pass.count('average')),
        _teamRow('shank', stats.home.pass.count('shank'),
            stats.away.pass.count('shank'),
            color: Colors.redAccent),
        const SizedBox(height: 6),
        _sectionLabel('ATTACK'),
        _teamRow('att', stats.home.attack.attempts, stats.away.attack.attempts),
        _teamRow('kill', stats.home.attack.count('kill'),
            stats.away.attack.count('kill'),
            color: Colors.greenAccent),
        _teamRow('blocked', stats.home.attack.count('blocked'),
            stats.away.attack.count('blocked'),
            color: Colors.redAccent),
        _teamRow('dug', stats.home.attack.count('dug'),
            stats.away.attack.count('dug'),
            color: Colors.amber),
        _teamRow('error', stats.home.attack.count('error'),
            stats.away.attack.count('error'),
            color: Colors.redAccent),
      ],
    );
  }

  Widget _teamColumnHeader() => Row(
        children: [
          const SizedBox(width: 72),
          _headerCell('HOME', color: Colors.lightBlueAccent),
          const SizedBox(width: 6),
          _headerCell('AWAY', color: Colors.orangeAccent),
        ],
      );

  Widget _teamRow(String label, int home, int away, {Color? color}) {
    final c = color ?? Colors.white70;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          SizedBox(
              width: 64,
              child: Text('  $label',
                  style:
                      const TextStyle(color: Colors.white54, fontSize: 10))),
          _valCell(home, c),
          const SizedBox(width: 6),
          _valCell(away, c),
        ],
      ),
    );
  }

  // ── Player view ────────────────────────────────────────────────────────────

  Widget _buildPlayerView(MatchStatsNotifier stats) {
    final home = stats.playersFor(TeamSide.home);
    final away = stats.playersFor(TeamSide.away);

    if (home.isEmpty && away.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text('No player data yet.',
            style: TextStyle(color: Colors.white38, fontSize: 11)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkillTable(title: 'SERVING', cols: _serveCols, home: home, away: away),
        _SkillTable(title: 'PASSING', cols: _passCols, home: home, away: away),
        _SkillTable(title: 'ATTACKING', cols: _attackCols, home: home, away: away),
      ],
    );
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 1),
        child: Text(text,
            style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8)),
      );

  Widget _headerCell(String text, {required Color color}) => SizedBox(
        width: 40,
        child: Text(text,
            textAlign: TextAlign.right,
            style:
                TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      );

  Widget _valCell(int v, Color color) => SizedBox(
        width: 40,
        child: Text('$v',
            textAlign: TextAlign.right,
            style: TextStyle(
                color: v > 0 ? color : Colors.white24,
                fontSize: 11,
                fontFeatures: const [FontFeature.tabularFigures()])),
      );
}

// ── Skill table widget ─────────────────────────────────────────────────────

class _SkillTable extends StatelessWidget {
  const _SkillTable({
    required this.title,
    required this.cols,
    required this.home,
    required this.away,
  });

  final String title;
  final List<_Col> cols;
  final List<PlayerMatchStats> home;
  final List<PlayerMatchStats> away;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(title,
                style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8)),
          ),
          // Column header row
          _headerRow(),
          const SizedBox(height: 2),
          // HOME players
          if (home.isNotEmpty) ...[
            _teamLabel('HOME', Colors.lightBlueAccent),
            ...home.map(_dataRow),
          ],
          // AWAY players
          if (away.isNotEmpty) ...[
            const SizedBox(height: 3),
            _teamLabel('AWAY', Colors.orangeAccent),
            ...away.map(_dataRow),
          ],
        ],
      ),
    );
  }

  Widget _headerRow() {
    return Table(
      columnWidths: _columnWidths(),
      children: [
        TableRow(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white12)),
          ),
          children: [
            const SizedBox(), // name column — no header text
            ...cols.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(c.header,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: c.color.withValues(alpha: 0.65),
                        fontSize: 9,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _teamLabel(String label, Color color) => Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 1),
        child: Text(label,
            style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5)),
      );

  Widget _dataRow(PlayerMatchStats p) {
    return Table(
      columnWidths: _columnWidths(),
      children: [
        TableRow(
          children: [
            // Player name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(p.playerName,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: Colors.white70, fontSize: 10)),
            ),
            // Stat values
            ...cols.map((c) {
              final v = c.extractor(p);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('$v',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: v > 0 ? c.color : Colors.white24,
                        fontSize: 10,
                        fontFeatures: const [FontFeature.tabularFigures()])),
              );
            }),
          ],
        ),
      ],
    );
  }

  Map<int, TableColumnWidth> _columnWidths() => {
        0: const FlexColumnWidth(),
        for (var i = 0; i < cols.length; i++)
          i + 1: const FixedColumnWidth(_kStatW),
      };
}

// ── Toggle chip ────────────────────────────────────────────────────────────

class _ToggleChip extends StatelessWidget {
  const _ToggleChip(
      {required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: active
                ? Colors.cyanAccent.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color: active ? Colors.cyanAccent : Colors.white24),
          ),
          child: Text(label,
              style: TextStyle(
                  color: active ? Colors.cyanAccent : Colors.white38,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5)),
        ),
      );
}
