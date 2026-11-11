// features/settings/presentation/widgets/language_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipp/core/locale/locale_service.dart';
import 'package:kipp/core/widgets/glass_segmented_bar.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  static const _locales = [Locale('lo'), Locale('en')];
  static const _labels = ['ລາວ', 'English'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeServiceProvider);
    final currentIndex = _locales.indexWhere(
      (l) => l.languageCode == current.languageCode,
    );

    return GlassSegmentedBar(
      labels: _labels,
      selectedIndex: currentIndex == -1 ? 0 : currentIndex,
      onSelected: (index) =>
          ref.read(localeServiceProvider.notifier).setLocale(_locales[index]),
    );
  }
}
