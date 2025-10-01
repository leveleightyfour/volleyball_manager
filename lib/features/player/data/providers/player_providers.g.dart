// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dbHash() => r'5513ff4d66f46002bfe5f533df2ee292511caa22';

/// See also [db].
@ProviderFor(db)
final dbProvider = Provider<AppDatabase>.internal(
  db,
  name: r'dbProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dbHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DbRef = ProviderRef<AppDatabase>;
String _$playerDaoHash() => r'c9f12e021c828af54b451edb86f6b9060dfaae11';

/// See also [playerDao].
@ProviderFor(playerDao)
final playerDaoProvider = Provider<PlayerDao>.internal(
  playerDao,
  name: r'playerDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playerDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlayerDaoRef = ProviderRef<PlayerDao>;
String _$playerRepositoryHash() => r'42626e6d1b9e4a7e12ebcb5da1653455a727e983';

/// See also [playerRepository].
@ProviderFor(playerRepository)
final playerRepositoryProvider = Provider<PlayerRepository>.internal(
  playerRepository,
  name: r'playerRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playerRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlayerRepositoryRef = ProviderRef<PlayerRepository>;
String _$playersStreamHash() => r'4154147f7b19060ea56cba992ba7ee9e9b8824ad';

/// See also [playersStream].
@ProviderFor(playersStream)
final playersStreamProvider = AutoDisposeStreamProvider<List<Player>>.internal(
  playersStream,
  name: r'playersStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playersStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlayersStreamRef = AutoDisposeStreamProviderRef<List<Player>>;
String _$playersOnceHash() => r'f5646dc51d22b5fcb242d65d50214caad23a7c7f';

/// See also [playersOnce].
@ProviderFor(playersOnce)
final playersOnceProvider = AutoDisposeFutureProvider<List<Player>>.internal(
  playersOnce,
  name: r'playersOnceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playersOnceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlayersOnceRef = AutoDisposeFutureProviderRef<List<Player>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
