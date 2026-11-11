// core/widgets/glass_segmented_bar.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// Equal-width segmented control with a liquid glass indicator (a
/// [GlassSegmentedControl]). Used by the Home day-type filter, the Expenses
/// period-unit selector and the Profile theme / language selectors.
///
/// At rest the indicator is a flat brand-primary pill; it only turns into a
/// refractive glass lens while pressed or dragged, so it is safe on plain
/// pages and inside `solid` grouped sections.
class GlassSegmentedBar extends StatelessWidget {
  const GlassSegmentedBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.icons,
    this.height = 52,
  }) : assert(icons == null || icons.length == labels.length);

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Optional icon per segment, shown above its label.
  final List<IconData>? icons;

  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icons = this.icons;

    return SizedBox(
      width: double.infinity,
      child: GlassSegmentedControl(
        // Standalone on the page, not inside another glass layer.
        useOwnLayer: true,
        height: height,
        segments: [
          for (var i = 0; i < labels.length; i++)
            GlassSegment(
              label: labels[i],
              icon: icons == null ? null : Icon(icons[i]),
            ),
        ],
        selectedIndex: selectedIndex,
        onSegmentSelected: onSelected,
        backgroundColor: colors.hintContainer,
        indicatorColor: colors.primary,
        selectedTextStyle: context.typo.subtitle.copyWith(
          color: colors.onPrimary,
          fontWeight: FontWeight.w600,
        ),
        unselectedTextStyle: context.typo.subtitle.copyWith(
          color: colors.subtext,
          fontWeight: FontWeight.normal,
        ),
        selectedIconColor: colors.onPrimary,
        unselectedIconColor: colors.subtext,
        iconSize: 18,
      ),
    );
  }
}
