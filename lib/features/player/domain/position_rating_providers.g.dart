// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_rating_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$positionWeightsHash() => r'647d76c8ce31c02cd79ca45ad6c3da22eb394db0';

/// Provider for position weight configurations
///
/// Copied from [positionWeights].
@ProviderFor(positionWeights)
final positionWeightsProvider =
    AutoDisposeFutureProvider<Map<String, PositionWeightConfig>>.internal(
      positionWeights,
      name: r'positionWeightsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$positionWeightsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PositionWeightsRef =
    AutoDisposeFutureProviderRef<Map<String, PositionWeightConfig>>;
String _$skillCalculatorHash() => r'479b316f7638446408e784b0f81530660d681b10';

/// Provider for SkillCalculator
///
/// Copied from [skillCalculator].
@ProviderFor(skillCalculator)
final skillCalculatorProvider =
    AutoDisposeFutureProvider<SkillCalculator>.internal(
      skillCalculator,
      name: r'skillCalculatorProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$skillCalculatorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SkillCalculatorRef = AutoDisposeFutureProviderRef<SkillCalculator>;
String _$positionRatingCalculatorHash() =>
    r'd82007dbe1405213ee4750fc9ac7c8a2e958db20';

/// Provider for PositionRatingCalculator
///
/// Copied from [positionRatingCalculator].
@ProviderFor(positionRatingCalculator)
final positionRatingCalculatorProvider =
    AutoDisposeFutureProvider<PositionRatingCalculator>.internal(
      positionRatingCalculator,
      name: r'positionRatingCalculatorProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$positionRatingCalculatorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PositionRatingCalculatorRef =
    AutoDisposeFutureProviderRef<PositionRatingCalculator>;
String _$positionRatingServiceHash() =>
    r'b24dda8c1cd9443477aeac8644a2a70a54540bee';

/// Provider for PositionRatingService
///
/// Copied from [positionRatingService].
@ProviderFor(positionRatingService)
final positionRatingServiceProvider =
    AutoDisposeFutureProvider<PositionRatingService>.internal(
      positionRatingService,
      name: r'positionRatingServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$positionRatingServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PositionRatingServiceRef =
    AutoDisposeFutureProviderRef<PositionRatingService>;
String _$playerPositionRatingsHash() =>
    r'af8751dca1e5b3d9a32232df974a6f1094cb81c0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider to get position ratings for a specific player
///
/// Copied from [playerPositionRatings].
@ProviderFor(playerPositionRatings)
const playerPositionRatingsProvider = PlayerPositionRatingsFamily();

/// Provider to get position ratings for a specific player
///
/// Copied from [playerPositionRatings].
class PlayerPositionRatingsFamily
    extends Family<AsyncValue<Map<String, double>>> {
  /// Provider to get position ratings for a specific player
  ///
  /// Copied from [playerPositionRatings].
  const PlayerPositionRatingsFamily();

  /// Provider to get position ratings for a specific player
  ///
  /// Copied from [playerPositionRatings].
  PlayerPositionRatingsProvider call(int playerId) {
    return PlayerPositionRatingsProvider(playerId);
  }

  @override
  PlayerPositionRatingsProvider getProviderOverride(
    covariant PlayerPositionRatingsProvider provider,
  ) {
    return call(provider.playerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'playerPositionRatingsProvider';
}

/// Provider to get position ratings for a specific player
///
/// Copied from [playerPositionRatings].
class PlayerPositionRatingsProvider
    extends AutoDisposeFutureProvider<Map<String, double>> {
  /// Provider to get position ratings for a specific player
  ///
  /// Copied from [playerPositionRatings].
  PlayerPositionRatingsProvider(int playerId)
    : this._internal(
        (ref) =>
            playerPositionRatings(ref as PlayerPositionRatingsRef, playerId),
        from: playerPositionRatingsProvider,
        name: r'playerPositionRatingsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$playerPositionRatingsHash,
        dependencies: PlayerPositionRatingsFamily._dependencies,
        allTransitiveDependencies:
            PlayerPositionRatingsFamily._allTransitiveDependencies,
        playerId: playerId,
      );

  PlayerPositionRatingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.playerId,
  }) : super.internal();

  final int playerId;

  @override
  Override overrideWith(
    FutureOr<Map<String, double>> Function(PlayerPositionRatingsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlayerPositionRatingsProvider._internal(
        (ref) => create(ref as PlayerPositionRatingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        playerId: playerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, double>> createElement() {
    return _PlayerPositionRatingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerPositionRatingsProvider && other.playerId == playerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, playerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlayerPositionRatingsRef
    on AutoDisposeFutureProviderRef<Map<String, double>> {
  /// The parameter `playerId` of this provider.
  int get playerId;
}

class _PlayerPositionRatingsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, double>>
    with PlayerPositionRatingsRef {
  _PlayerPositionRatingsProviderElement(super.provider);

  @override
  int get playerId => (origin as PlayerPositionRatingsProvider).playerId;
}

String _$playerBestPositionHash() =>
    r'f5396f9e5f3f22c31b0c107df5cdcac0b9e8d96a';

/// Provider to get the best position for a specific player
///
/// Copied from [playerBestPosition].
@ProviderFor(playerBestPosition)
const playerBestPositionProvider = PlayerBestPositionFamily();

/// Provider to get the best position for a specific player
///
/// Copied from [playerBestPosition].
class PlayerBestPositionFamily
    extends Family<AsyncValue<MapEntry<String, double>>> {
  /// Provider to get the best position for a specific player
  ///
  /// Copied from [playerBestPosition].
  const PlayerBestPositionFamily();

  /// Provider to get the best position for a specific player
  ///
  /// Copied from [playerBestPosition].
  PlayerBestPositionProvider call(int playerId) {
    return PlayerBestPositionProvider(playerId);
  }

  @override
  PlayerBestPositionProvider getProviderOverride(
    covariant PlayerBestPositionProvider provider,
  ) {
    return call(provider.playerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'playerBestPositionProvider';
}

/// Provider to get the best position for a specific player
///
/// Copied from [playerBestPosition].
class PlayerBestPositionProvider
    extends AutoDisposeFutureProvider<MapEntry<String, double>> {
  /// Provider to get the best position for a specific player
  ///
  /// Copied from [playerBestPosition].
  PlayerBestPositionProvider(int playerId)
    : this._internal(
        (ref) => playerBestPosition(ref as PlayerBestPositionRef, playerId),
        from: playerBestPositionProvider,
        name: r'playerBestPositionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$playerBestPositionHash,
        dependencies: PlayerBestPositionFamily._dependencies,
        allTransitiveDependencies:
            PlayerBestPositionFamily._allTransitiveDependencies,
        playerId: playerId,
      );

  PlayerBestPositionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.playerId,
  }) : super.internal();

  final int playerId;

  @override
  Override overrideWith(
    FutureOr<MapEntry<String, double>> Function(PlayerBestPositionRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlayerBestPositionProvider._internal(
        (ref) => create(ref as PlayerBestPositionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        playerId: playerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MapEntry<String, double>> createElement() {
    return _PlayerBestPositionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerBestPositionProvider && other.playerId == playerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, playerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlayerBestPositionRef
    on AutoDisposeFutureProviderRef<MapEntry<String, double>> {
  /// The parameter `playerId` of this provider.
  int get playerId;
}

class _PlayerBestPositionProviderElement
    extends AutoDisposeFutureProviderElement<MapEntry<String, double>>
    with PlayerBestPositionRef {
  _PlayerBestPositionProviderElement(super.provider);

  @override
  int get playerId => (origin as PlayerBestPositionProvider).playerId;
}

String _$playerRankedPositionsHash() =>
    r'ea9fd07d6d50eb1ed544001abc09091edcc74a12';

/// Provider to get ranked positions for a specific player
///
/// Copied from [playerRankedPositions].
@ProviderFor(playerRankedPositions)
const playerRankedPositionsProvider = PlayerRankedPositionsFamily();

/// Provider to get ranked positions for a specific player
///
/// Copied from [playerRankedPositions].
class PlayerRankedPositionsFamily
    extends Family<AsyncValue<List<MapEntry<String, double>>>> {
  /// Provider to get ranked positions for a specific player
  ///
  /// Copied from [playerRankedPositions].
  const PlayerRankedPositionsFamily();

  /// Provider to get ranked positions for a specific player
  ///
  /// Copied from [playerRankedPositions].
  PlayerRankedPositionsProvider call(int playerId) {
    return PlayerRankedPositionsProvider(playerId);
  }

  @override
  PlayerRankedPositionsProvider getProviderOverride(
    covariant PlayerRankedPositionsProvider provider,
  ) {
    return call(provider.playerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'playerRankedPositionsProvider';
}

/// Provider to get ranked positions for a specific player
///
/// Copied from [playerRankedPositions].
class PlayerRankedPositionsProvider
    extends AutoDisposeFutureProvider<List<MapEntry<String, double>>> {
  /// Provider to get ranked positions for a specific player
  ///
  /// Copied from [playerRankedPositions].
  PlayerRankedPositionsProvider(int playerId)
    : this._internal(
        (ref) =>
            playerRankedPositions(ref as PlayerRankedPositionsRef, playerId),
        from: playerRankedPositionsProvider,
        name: r'playerRankedPositionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$playerRankedPositionsHash,
        dependencies: PlayerRankedPositionsFamily._dependencies,
        allTransitiveDependencies:
            PlayerRankedPositionsFamily._allTransitiveDependencies,
        playerId: playerId,
      );

  PlayerRankedPositionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.playerId,
  }) : super.internal();

  final int playerId;

  @override
  Override overrideWith(
    FutureOr<List<MapEntry<String, double>>> Function(
      PlayerRankedPositionsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlayerRankedPositionsProvider._internal(
        (ref) => create(ref as PlayerRankedPositionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        playerId: playerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MapEntry<String, double>>>
  createElement() {
    return _PlayerRankedPositionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerRankedPositionsProvider && other.playerId == playerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, playerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlayerRankedPositionsRef
    on AutoDisposeFutureProviderRef<List<MapEntry<String, double>>> {
  /// The parameter `playerId` of this provider.
  int get playerId;
}

class _PlayerRankedPositionsProviderElement
    extends AutoDisposeFutureProviderElement<List<MapEntry<String, double>>>
    with PlayerRankedPositionsRef {
  _PlayerRankedPositionsProviderElement(super.provider);

  @override
  int get playerId => (origin as PlayerRankedPositionsProvider).playerId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
