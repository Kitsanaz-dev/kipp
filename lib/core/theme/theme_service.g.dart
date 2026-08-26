// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$themeServiceHash() => r'081176ca5ea3dd6eee07dc243bef3a2af4018f77';

/// ຄວບຄຸມ ThemeMode ຂອງແອັບ (light / dark / system)
/// ບັນທຶກຄ່າໄວ້ໃນ Hive ເພື່ອຈື່ຄ່າຫຼັງປິດ-ເປີດແອັບໃໝ່
///
/// Copied from [ThemeService].
@ProviderFor(ThemeService)
final themeServiceProvider =
    AutoDisposeNotifierProvider<ThemeService, ThemeMode>.internal(
  ThemeService.new,
  name: r'themeServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$themeServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeService = AutoDisposeNotifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
