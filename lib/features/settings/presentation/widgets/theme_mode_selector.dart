// features/settings/presentation/widgets/theme_mode_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/theme/theme_service.dart';
import 'package:kipp/core/widgets/glass_segmented_bar.dart';

class ThemeModeSelector extends ConsumerWidget {
  const ThemeModeSelector({super.key});

  static const _modes = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeServiceProvider);

    return GlassSegmentedBar(
      height: 64,
      labels: [for (final mode in _modes) _labelFor(context, mode)],
      icons: [for (final mode in _modes) _iconFor(mode)],
      selectedIndex: _modes.indexOf(currentMode),
      onSelected: (index) =>
          ref.read(themeServiceProvider.notifier).setMode(_modes[index]),
    );
  }

  IconData _iconFor(ThemeMode mode) => switch (mode) {
    ThemeMode.light => Icons.light_mode_outlined,
    ThemeMode.dark => Icons.dark_mode_outlined,
    ThemeMode.system => Icons.smartphone_outlined,
  };

  String _labelFor(BuildContext context, ThemeMode mode) => switch (mode) {
    ThemeMode.light => context.text.themeLight,
    ThemeMode.dark => context.text.themeDark,
    ThemeMode.system => context.text.themeSystem,
  };
}
