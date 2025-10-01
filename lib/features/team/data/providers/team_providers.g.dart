// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamDaoHash() => r'f315d64a120b76c3ca05732cd9db261f826b6629';

/// See also [teamDao].
@ProviderFor(teamDao)
final teamDaoProvider = Provider<TeamDao>.internal(
  teamDao,
  name: r'teamDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$teamDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TeamDaoRef = ProviderRef<TeamDao>;
String _$teamRepositoryHash() => r'b361fc244a0eb2bb0a4119d050dce2751087a86a';

/// See also [teamRepository].
@ProviderFor(teamRepository)
final teamRepositoryProvider = Provider<TeamRepository>.internal(
  teamRepository,
  name: r'teamRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$teamRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TeamRepositoryRef = ProviderRef<TeamRepository>;
String _$teamsStreamHash() => r'a6028dc8bdc90ae9f58a1545bdcd4c7ead3b5ae2';

/// See also [teamsStream].
@ProviderFor(teamsStream)
final teamsStreamProvider = AutoDisposeStreamProvider<List<Team>>.internal(
  teamsStream,
  name: r'teamsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$teamsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TeamsStreamRef = AutoDisposeStreamProviderRef<List<Team>>;
String _$teamsOnceHash() => r'2a4c81cf65e40e42078652d1f148602cf51692ee';

/// See also [teamsOnce].
@ProviderFor(teamsOnce)
final teamsOnceProvider = AutoDisposeFutureProvider<List<Team>>.internal(
  teamsOnce,
  name: r'teamsOnceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$teamsOnceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TeamsOnceRef = AutoDisposeFutureProviderRef<List<Team>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
