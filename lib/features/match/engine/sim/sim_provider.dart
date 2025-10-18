import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volleyball_manager/features/match/engine/sim/outcome_strategy.dart';
import 'sim_controller.dart';

final simControllerProvider = Provider<SimController>((ref) {
  final strategy = EngineOutcomeStrategy(ref);
  return SimController(ref, strategy: strategy);
});
