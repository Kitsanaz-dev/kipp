// features/settings/presentation/widgets/theme_mode_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/theme/theme_service.dart';

class ThemeModeSelector extends ConsumerWidget {
  const ThemeModeSelector({super.key});

  static const _modes = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeServiceProvider);
    final colors = context.colors;
    final itemCount = _modes.length;
    final currentIndex = _modes.indexOf(currentMode);

    return Container(
      height: 64,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.hintContainer,
        borderRadius: AppRadius.lgAll,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = constraints.maxWidth / itemCount;

          return Stack(
            children: [
              // ---- ຊັ້ນ 1: Glass indicator ທີ່ slide ໄດ້ ----
              AnimatedAlign(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                alignment: Alignment(
                  itemCount == 1
                      ? 0
                      : -1 + (2 * currentIndex) / (itemCount - 1),
                  0,
                ),
                child: FakeGlass(
                  shape: LiquidRoundedSuperellipse(borderRadius: AppRadius.md),
                  settings: LiquidGlassSettings(
                    blur: 6,
                    glassColor: colors.primary.withValues(alpha: 0.65),
                  ),
                  child: SizedBox(width: segmentWidth, height: double.infinity),
                ),
              ),

              // ---- ຊັ້ນ 2: Icon + label ວາງທັບ ----
              Row(
                children: List.generate(itemCount, (index) {
                  final mode = _modes[index];
                  final isSelected = currentIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          ref.read(themeServiceProvider.notifier).setMode(mode),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: isSelected
                                  ? colors.onPrimary
                                  : colors.subtext,
                            ),
                            child: Icon(
                              _iconFor(mode),
                              size: 18,
                              color: isSelected
                                  ? colors.onPrimary
                                  : colors.subtext,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? colors.onPrimary
                                  : colors.subtext,
                            ),
                            child: Text(
                              _labelFor(context, mode),
                              style: context.typo.bodySmall.copyWith(
                                color: isSelected
                                    ? colors.onPrimary
                                    : colors.subtext,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
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
