import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../engine/positions/position_repository.dart';
import '../../engine/positions/position_models.dart';
import '../../engine/positions/position_resolver.dart';

final positionRepositoryProvider = Provider((ref) => PositionRepository());

final positionBookProvider = FutureProvider<PositionBook>((ref) async {
  final repo = ref.read(positionRepositoryProvider);
  return repo.loadFromAssets();
});

final positionResolverProvider = FutureProvider<PositionResolver>((ref) async {
  final book = await ref.read(positionBookProvider.future);
  return PositionResolver(book);
});
