// lib/features/match/presentation/sim_result_page.dart
import 'package:flutter/material.dart';
import 'package:volleyball_manager/features/match/engine/sim/match_sim_runner.dart';
import 'package:volleyball_manager/features/match/state/match_state.dart' show TeamSide;
import 'package:volleyball_manager/features/match/state/match_stats_state.dart';

// ── Column descriptor (mirrors stats_overlay.dart) ──────────────────────────

class _Col {
  const _Col(this.header, this.color, this.extractor);
  final String header;
  final Color color;
  final int Function(PlayerMatchStats) extractor;
}

const _kStatW = 28.0;

final _serveCols = <_Col>[
  _Col('att', Colors.white70, (p) => p.serve.attempts),
  _Col('ace', Colors.greenAccent, (p) => p.serve.count('ace')),
  _Col('flt', Colors.redAccent, (p) => p.serve.count('error')),
  _Col('in', Colors.white54,
      (p) => p.serve.attempts - p.serve.count('ace') - p.serve.count('error')),
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

// ── Page ────────────────────────────────────────────────────────────────────

class SimResultPage extends StatefulWidget {
  const SimResultPage({super.key, required this.result});
  final MatchSimResult result;

  @override
  State<SimResultPage> createState() => _SimResultPageState();
}

class _SimResultPageState extends State<SimResultPage> {
  bool _showPlayers = false;

  MatchSimResult get r => widget.result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101820),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('MATCH RESULT',
            style: TextStyle(
                color: Colors.cyanAccent,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2)),
        iconTheme: const IconThemeData(color: Colors.white54),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMatchScore(),
            const SizedBox(height: 12),
            _buildSetScores(),
            const SizedBox(height: 16),
            _buildToggleHeader(),
            const Divider(color: Colors.white12, height: 16),
            _showPlayers
                ? _buildPlayerView()
                : _buildTeamView(),
          ],
        ),
      ),
    );
  }

  // ── Match score ────────────────────────────────────────────────────────────

  Widget _buildMatchScore() {
    final homeWon = r.winner == TeamSide.home;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(children: [
            Text('HOME',
                style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 11,
                    fontWeight: homeWon ? FontWeight.bold : FontWeight.normal)),
            if (homeWon)
              const Text('WINNER',
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 9,
                      fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(width: 24),
          Text('${r.setsHome}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('–',
                style: TextStyle(color: Colors.white38, fontSize: 40)),
          ),
          Text('${r.setsAway}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 24),
          Column(children: [
            Text('AWAY',
                style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 11,
                    fontWeight: !homeWon ? FontWeight.bold : FontWeight.normal)),
            if (!homeWon)
              const Text('WINNER',
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 9,
                      fontWeight: FontWeight.bold)),
          ]),
        ],
      ),
    );
  }

  // ── Set-by-set scores ──────────────────────────────────────────────────────

  Widget _buildSetScores() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('SETS',
            style: TextStyle(
                color: Colors.cyanAccent,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8)),
        const SizedBox(height: 6),
        Row(
          children: [
            for (var i = 0; i < r.setScores.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _SetScoreChip(
                  setNumber: i + 1,
                  scoreHome: r.setScores[i].home,
                  scoreAway: r.setScores[i].away,
                ),
              ),
            Text('${r.rallyCount} rallies',
                style: const TextStyle(color: Colors.white24, fontSize: 9)),
          ],
        ),
      ],
    );
  }

  // ── Toggle ─────────────────────────────────────────────────────────────────

  Widget _buildToggleHeader() => Row(
        children: [
          const Text('STATISTICS',
              style: TextStyle(
                  color: Colors.white54,
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
      );

  // ── Team view ──────────────────────────────────────────────────────────────

  Widget _buildTeamView() {
    final s = r.stats;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _teamColumnHeader(),
        const SizedBox(height: 4),
        _sectionLabel('SERVE'),
        _teamRow('att', s.home.serve.attempts, s.away.serve.attempts),
        _teamRow('ace', s.home.serve.count('ace'), s.away.serve.count('ace'),
            color: Colors.greenAccent),
        _teamRow('fault', s.home.serve.count('error'),
            s.away.serve.count('error'),
            color: Colors.redAccent),
        const SizedBox(height: 6),
        _sectionLabel('PASS'),
        _teamRow('att', s.home.pass.attempts, s.away.pass.attempts),
        _teamRow('perfect', s.home.pass.count('perfect'),
            s.away.pass.count('perfect'),
            color: const Color(0xFF80FF80)),
        _teamRow('average', s.home.pass.count('average'),
            s.away.pass.count('average')),
        _teamRow('shank', s.home.pass.count('shank'), s.away.pass.count('shank'),
            color: Colors.redAccent),
        const SizedBox(height: 6),
        _sectionLabel('ATTACK'),
        _teamRow('att', s.home.attack.attempts, s.away.attack.attempts),
        _teamRow('kill', s.home.attack.count('kill'),
            s.away.attack.count('kill'),
            color: Colors.greenAccent),
        _teamRow('blocked', s.home.attack.count('blocked'),
            s.away.attack.count('blocked'),
            color: Colors.redAccent),
        _teamRow('dug', s.home.attack.count('dug'), s.away.attack.count('dug'),
            color: Colors.amber),
        _teamRow('error', s.home.attack.count('error'),
            s.away.attack.count('error'),
            color: Colors.redAccent),
      ],
    );
  }

  Widget _teamColumnHeader() => Row(children: [
        const SizedBox(width: 80),
        _headerCell('HOME', color: Colors.lightBlueAccent),
        const SizedBox(width: 6),
        _headerCell('AWAY', color: Colors.orangeAccent),
      ]);

  Widget _teamRow(String label, int home, int away, {Color? color}) {
    final c = color ?? Colors.white70;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(children: [
        SizedBox(
            width: 72,
            child: Text('  $label',
                style:
                    const TextStyle(color: Colors.white54, fontSize: 10))),
        _valCell(home, c),
        const SizedBox(width: 6),
        _valCell(away, c),
      ]),
    );
  }

  // ── Player view ────────────────────────────────────────────────────────────

  Widget _buildPlayerView() {
    final home = r.stats.playersFor(TeamSide.home);
    final away = r.stats.playersFor(TeamSide.away);

    if (home.isEmpty && away.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text('No player data.',
            style: TextStyle(color: Colors.white38, fontSize: 11)),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkillTable(title: 'SERVING', cols: _serveCols, home: home, away: away),
        _SkillTable(title: 'PASSING', cols: _passCols, home: home, away: away),
        _SkillTable(
            title: 'ATTACKING', cols: _attackCols, home: home, away: away),
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
        width: 44,
        child: Text(text,
            textAlign: TextAlign.right,
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      );

  Widget _valCell(int v, Color color) => SizedBox(
        width: 44,
        child: Text('$v',
            textAlign: TextAlign.right,
            style: TextStyle(
                color: v > 0 ? color : Colors.white24,
                fontSize: 11,
                fontFeatures: const [FontFeature.tabularFigures()])),
      );
}

// ── Set score chip ────────────────────────────────────────────────────────

class _SetScoreChip extends StatelessWidget {
  const _SetScoreChip({
    required this.setNumber,
    required this.scoreHome,
    required this.scoreAway,
  });
  final int setNumber;
  final int scoreHome;
  final int scoreAway;

  @override
  Widget build(BuildContext context) {
    final homeWon = scoreHome > scoreAway;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text('Set $setNumber',
              style:
                  const TextStyle(color: Colors.white38, fontSize: 8)),
          const SizedBox(height: 2),
          Text(
            '$scoreHome – $scoreAway',
            style: TextStyle(
                color: homeWon ? Colors.lightBlueAccent : Colors.orangeAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFeatures: const [FontFeature.tabularFigures()]),
          ),
        ],
      ),
    );
  }
}

// ── Skill table (mirrors stats_overlay.dart _SkillTable) ──────────────────

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
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(title,
                style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8)),
          ),
          _headerRow(),
          const SizedBox(height: 2),
          if (home.isNotEmpty) ...[
            _teamLabel('HOME', Colors.lightBlueAccent),
            ...home.map(_dataRow),
          ],
          if (away.isNotEmpty) ...[
            const SizedBox(height: 3),
            _teamLabel('AWAY', Colors.orangeAccent),
            ...away.map(_dataRow),
          ],
        ],
      ),
    );
  }

  Widget _headerRow() => Table(
        columnWidths: _columnWidths(),
        children: [
          TableRow(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white12))),
            children: [
              const SizedBox(),
              ...cols.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(c.header,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: c.color.withValues(alpha: 0.65),
                            fontSize: 9,
                            fontWeight: FontWeight.bold)),
                  )),
            ],
          ),
        ],
      );

  Widget _teamLabel(String label, Color color) => Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 1),
        child: Text(label,
            style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5)),
      );

  Widget _dataRow(PlayerMatchStats p) => Table(
        columnWidths: _columnWidths(),
        children: [
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(p.playerName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ),
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
          ]),
        ],
      );

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
            border:
                Border.all(color: active ? Colors.cyanAccent : Colors.white24),
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
