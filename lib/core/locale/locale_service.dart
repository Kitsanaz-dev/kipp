// core/locale/locale_service.dart
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_service.g.dart';

const _settingsBoxName = 'settings_box'; // ✅ box ດຽວກັບ theme (settings ລວມ)
const _localeKey = 'locale_code';

@riverpod
class LocaleService extends _$LocaleService {
  @override
  Locale build() {
    _loadSavedLocale();
    return const Locale('lo'); // ✅ default ເປັນລາວ
  }

  Future<void> _loadSavedLocale() async {
    final box = await Hive.openBox(_settingsBoxName);
    final saved = box.get(_localeKey) as String?;
    if (saved != null) state = Locale(saved);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final box = await Hive.openBox(_settingsBoxName);
    await box.put(_localeKey, locale.languageCode);
  }
}