// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRepositoryHash() => r'b46f88de1fbb7a5cac25f4bd4038eac8b8c0b2c3';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$authHash() => r'5f8e7702d203c71e81048c5c643f4008fc5eab91';

/// Current signed-in user - single source of truth ສຳລັບ auth state.
/// build() ອ່ານ session ຈາກ Hive ຕອນເປີດແອັບ.
///
/// Copied from [Auth].
@ProviderFor(Auth)
final authProvider =
    AutoDisposeAsyncNotifierProvider<Auth, UserEntity?>.internal(
      Auth.new,
      name: r'authProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Auth = AutoDisposeAsyncNotifier<UserEntity?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
