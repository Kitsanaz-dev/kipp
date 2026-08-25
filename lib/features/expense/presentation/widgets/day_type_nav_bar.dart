// features/expense/presentation/widgets/day_type_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/theme/app_theme.dart';

class DayTypeNavBar extends StatelessWidget {
  const DayTypeNavBar({
    super.key,
    required this.currentDayType,
    required this.onTap,
  });

  final int currentDayType;
  final ValueChanged<int> onTap;
  static const _labels = ['Today', 'This Week', 'This Month'];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final itemCount = _labels.length;

    return Container(
      height: 52,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colors.primary, width: 1),
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
                      : -1 + (2 * currentDayType) / (itemCount - 1),
                  0,
                ),
                child: FakeGlass(
                  shape: LiquidRoundedSuperellipse(
                    borderRadius: AppRadius.md,
                  ),
                  settings: LiquidGlassSettings(
                    blur: 6,
                    glassColor: colors.primary.withValues(alpha: 0.65),
                  ),
                  child: SizedBox(
                    width: segmentWidth,
                    height: double.infinity,
                  ),
                ),
              ),

              // ---- ຊັ້ນ 2: Label ວາງທັບ ----
              Row(
                children: List.generate(itemCount, (index) {
                  final isSelected = currentDayType == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(index),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        alignment: Alignment.center,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: context.typo.subtitle.copyWith(
                            color: isSelected ? colors.onPrimary : colors.inactive,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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