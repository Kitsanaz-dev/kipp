// features/settings/presentation/widgets/theme_mode_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/theme/app_theme.dart';
import 'package:kipp/core/theme/theme_service.dart';

class ThemeModeSelector extends ConsumerWidget {
  const ThemeModeSelector({super.key});

  @override

  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeServiceProvider);
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.hintContainer,
        borderRadius: AppRadius.lgAll,
      ),
      child: Row(
        children: ThemeMode.values.map((mode) {
          final isSelected = currentMode == mode;
          return Expanded(
            child: GestureDetector(
              onTap: () => ref.read(themeServiceProvider.notifier).setMode(mode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : Colors.transparent,
                  borderRadius: AppRadius.mdAll,
                ),
                child: Column(
                  children: [
                    Icon(
                      _iconFor(mode),
                      size: 18,
                      color: isSelected ? colors.onPrimary : colors.subtext,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _labelFor(mode),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? colors.onPrimary : colors.subtext,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _iconFor(ThemeMode mode) => switch (mode) {
        ThemeMode.light => Icons.light_mode_outlined,
        ThemeMode.dark => Icons.dark_mode_outlined,
        ThemeMode.system => Icons.smartphone_outlined,
      };

  String _labelFor(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
        ThemeMode.system => 'System',
      };
}