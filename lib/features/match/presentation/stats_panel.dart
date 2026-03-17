import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../stats/models/match_stats.dart';
import '../stats/stats_provider.dart';

class StatsPanel extends ConsumerWidget {
  const StatsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsNotifierProvider);

    return Container(
      color: const Color(0xFF1A1A2E),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(stats),
          const SizedBox(height: 6),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 6),
          _statRow('Kills', stats.home.kills, stats.away.kills),
          _statRow('Attack Errors', stats.home.attackErrors, stats.away.attackErrors),
          _statRow('Blocks Won', stats.home.blocksWon, stats.away.blocksWon),
          _statRow('Digs', stats.home.digs, stats.away.digs),
          _statRow('Serve Aces', stats.home.serveAces, stats.away.serveAces),
          _statRow('Serve Faults', stats.home.serveFaults, stats.away.serveFaults),
          _statRow(
            'Pass %',
            _passPercent(stats.home),
            _passPercent(stats.away),
            isPercent: true,
          ),
          _statRow(
            'Sideout %',
            _sideoutPercent(stats.home),
            _sideoutPercent(stats.away),
            isPercent: true,
          ),
        ],
      ),
    );
  }

  Widget _header(MatchStats stats) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${stats.home.points}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Text(
          'STATS',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        Expanded(
          child: Text(
            '${stats.away.points}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statRow(String label, dynamic homeVal, dynamic awayVal,
      {bool isPercent = false}) {
    final homeStr = isPercent ? '${(homeVal as int)}%' : '$homeVal';
    final awayStr = isPercent ? '${(awayVal as int)}%' : '$awayVal';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              homeStr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              awayStr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  int _passPercent(TeamStats s) =>
      s.totalPasses > 0 ? (s.perfectPasses * 100 ~/ s.totalPasses) : 0;

  int _sideoutPercent(TeamStats s) =>
      s.sideoutAttempts > 0 ? (s.sideouts * 100 ~/ s.sideoutAttempts) : 0;
}
