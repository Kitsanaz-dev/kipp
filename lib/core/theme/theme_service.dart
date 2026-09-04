// core/theme/theme_service.dart
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; // ✅ ໃຊ້ hive_ce ຕາມທີ່ປ່ຽນໄປແລ້ວ

part 'theme_service.g.dart';

const _settingsBoxName = 'settings_box';
const _themeModeKey = 'theme_mode';

/// ຄວບຄຸມ ThemeMode ຂອງແອັບ (light / dark / system)
/// ບັນທຶກຄ່າໄວ້ໃນ Hive ເພື່ອຈື່ຄ່າຫຼັງປິດ-ເປີດແອັບໃໝ່
@riverpod
class ThemeService extends _$ThemeService {
  @override
  ThemeMode build() {
    _loadSavedMode();
    return ThemeMode.system; // ຄ່າເລີ່ມຕົ້ນ - ຕາມການຕັ້ງຄ່າໂທລະສັບ
  }

  Future<void> _loadSavedMode() async {
    final box = await Hive.openBox(_settingsBoxName);
    final savedIndex = box.get(_themeModeKey) as int?;

    if (savedIndex != null && savedIndex < ThemeMode.values.length) {
      state = ThemeMode.values[savedIndex];
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final box = await Hive.openBox(_settingsBoxName);
    await box.put(_themeModeKey, mode.index);
  }

  Future<void> setLight() => setMode(ThemeMode.light);
  Future<void> setDark() => setMode(ThemeMode.dark);
  Future<void> setSystem() => setMode(ThemeMode.system);

  Future<void> toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    return setMode(next);
  }
}