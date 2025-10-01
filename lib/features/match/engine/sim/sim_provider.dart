import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../sim/sim_controller.dart';

part 'sim_provider.g.dart';

@riverpod
SimController simController(Ref ref) {
  return SimController();
}
