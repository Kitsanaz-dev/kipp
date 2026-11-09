// core/widgets/glass_segmented_bar.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/constant/durations.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// Outlined segmented control with a sliding FakeGlass indicator (the
/// Home day-type look). Segments are equal width.
class GlassSegmentedBar extends StatelessWidget {
  const GlassSegmentedBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
                duration: AppDurations.slide,
                curve: Curves.easeOutCubic,
                alignment: Alignment(
                  itemCount == 1
                      ? 0
                      : -1 + (2 * selectedIndex) / (itemCount - 1),
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
                  final isSelected = selectedIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onSelected(index),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        alignment: Alignment.center,
                        child: AnimatedDefaultTextStyle(
                          duration: AppDurations.fast,
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