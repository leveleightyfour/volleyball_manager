import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../engine/events/events.dart';
import '../engine/state/match_state.dart';
import '../engine/sim/sim_controller.dart';
import 'models/match_stats.dart';
import 'stats_collector.dart';

part 'stats_provider.g.dart';

@riverpod
class StatsNotifier extends _$StatsNotifier {
  late final StatsCollector _collector;

  @override
  MatchStats build() {
    _collector = StatsCollector();
    return _collector.stats;
  }

  void record({
    required MatchState stateBefore,
    required ManualInputs inputs,
    required MatchState stateAfter,
    required List<EngineEvent> events,
  }) {
    _collector.record(
      stateBefore: stateBefore,
      inputs: inputs,
      stateAfter: stateAfter,
      events: events,
    );
    state = _collector.stats;
  }
}
