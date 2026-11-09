// features/expense/presentation/widgets/day_type_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';

class DayTypeNavBar extends StatelessWidget {
  const DayTypeNavBar({
    super.key,
    required this.current,
    required this.onTap,
  });

  final PeriodFilter current;
  final ValueChanged<PeriodFilter> onTap;

  List<String> _labels(BuildContext context) => [
    context.text.today,
    context.text.thisWeek,
    context.text.thisMonth,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final labels = _labels(context);
    final itemCount = labels.length;

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
                      : -1 + (2 * current.index) / (itemCount - 1),
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
                  final isSelected = current.index == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(PeriodFilter.values[index]),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        alignment: Alignment.center,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: context.typo.subtitle.copyWith(
                            color: isSelected ? colors.primary : colors.inactive,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                          child: Text(labels[index]),
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