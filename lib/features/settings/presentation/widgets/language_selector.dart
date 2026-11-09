// features/settings/presentation/widgets/language_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:kipp/core/constant/durations.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/locale/locale_service.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  static const _locales = [Locale('lo'), Locale('en')];
  static const _labels = ['ລາວ', 'English'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeServiceProvider);
    final colors = context.colors;
    final itemCount = _locales.length;
    final currentIndex = _locales.indexWhere(
      (l) => l.languageCode == current.languageCode,
    );
    final selectedIndex = currentIndex == -1 ? 0 : currentIndex;

    return Container(
      height: 52,
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
                duration: AppDurations.slide,
                curve: Curves.easeOutCubic,
                alignment: Alignment(
                  itemCount == 1
                      ? 0
                      : -1 + (2 * selectedIndex) / (itemCount - 1),
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

              // ---- ຊັ້ນ 2: Label ວາງທັບ ----
              Row(
                children: List.generate(itemCount, (index) {
                  final isSelected = selectedIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => ref
                          .read(localeServiceProvider.notifier)
                          .setLocale(_locales[index]),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        alignment: Alignment.center,
                        child: AnimatedDefaultTextStyle(
                          duration: AppDurations.fast,
                          style: context.typo.bodySmall.copyWith(
                            color: isSelected
                                ? colors.onPrimary
                                : colors.subtext,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          child: Text(_labels[index]),
                        ),
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
}
