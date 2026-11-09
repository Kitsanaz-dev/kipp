// features/expense/presentation/widgets/day_type_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/widgets/glass_segmented_bar.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';

class DayTypeNavBar extends StatelessWidget {
  const DayTypeNavBar({
    super.key,
    required this.current,
    required this.onTap,
  });

  final PeriodFilter current;
  final ValueChanged<PeriodFilter> onTap;

  @override
  Widget build(BuildContext context) {
    return GlassSegmentedBar(
      labels: [
        context.text.today,
        context.text.thisWeek,
        context.text.thisMonth,
      ],
      selectedIndex: current.index,
      onSelected: (index) => onTap(PeriodFilter.values[index]),
    );
  }
}
