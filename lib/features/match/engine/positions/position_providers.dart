import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'position_repository.dart';
import 'position_models.dart';
import 'position_resolver.dart';

final positionRepositoryProvider = Provider((ref) => PositionRepository());

final positionBookProvider = FutureProvider<PositionBook>((ref) async {
  final repo = ref.read(positionRepositoryProvider);
  final book = await repo.loadFromAssets();
  return book;
});

/// Synchronous resolver: uses the loaded book if present, otherwise an empty book.
/// Lets your UI/game build immediately and still benefit when the real book arrives.
final positionResolverProviderSync = Provider<PositionResolver>((ref) {
  final asyncBook = ref.watch(positionBookProvider);
  return asyncBook.when(
    data: (b) => PositionResolver(b.isEmpty ? PositionBook.empty() : b),
    loading: () => PositionResolver(PositionBook.empty()),
    error: (_, __) => PositionResolver(PositionBook.empty()),
  );
});

enum PositionsStatus { loading, readyEmpty, ready }

final positionsStatusProvider = Provider<PositionsStatus>((ref) {
  final asyncBook = ref.watch(positionBookProvider);
  return asyncBook.when(
    data: (b) => b.isEmpty ? PositionsStatus.readyEmpty : PositionsStatus.ready,
    loading: () => PositionsStatus.loading,
    error: (_, __) => PositionsStatus.readyEmpty,
  );
});
