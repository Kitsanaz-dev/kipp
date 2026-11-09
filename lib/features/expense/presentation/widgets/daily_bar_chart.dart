// features/expense/presentation/widgets/daily_bar_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/utils/currency_formatter.dart';
import 'package:kipp/features/expense/presentation/models/chart_ui_model.dart';

/// Grouped bar chart of daily income (green) vs. expense (red).
class DailyBarChart extends StatelessWidget {
  const DailyBarChart({super.key, required this.data});

  final List<DailyChartData> data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxValue = data.fold<double>(
      0,
      (max, d) => [max, d.income, d.expense].reduce((a, b) => a > b ? a : b),
    );
    final safeMax = maxValue <= 0 ? 100.0 : maxValue;
    final step = safeMax / 4;
    // ~6 bottom labels whatever the length: 14 days → every 3rd,
    // 28–30 days → every 5th, 31 days → every 6th.
    final labelEvery = (data.length / 6).ceil().clamp(1, 31);

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colors.inactiveContainer),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Shrink rods so 28–31 day groups never overlap. At 14 days on a
          // phone this still resolves to the original 4px rods / 3px gap.
          const leftReserved = 44.0;
          final groupWidth = data.isEmpty
              ? 0.0
              : (constraints.maxWidth - leftReserved) / data.length;
          final barsSpace = groupWidth >= 14 ? 3.0 : 1.0;
          final rodWidth = ((groupWidth * 0.6 - barsSpace) / 2).clamp(1.5, 4.0);

          return BarChart(
            BarChartData(
              maxY: safeMax * 1.2,
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: step,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: colors.inactiveContainer, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: leftReserved,
                    interval: step,
                    getTitlesWidget: (value, _) => Text(
                      CurrencyFormatter.compact(value),
                      style: context.typo.caption.copyWith(
                        color: colors.subtext,
                      ),
                    ),
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    // Bar charts call this for every group and ignore
                    // `interval`, so thin the labels out here.
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < 0 ||
                          index >= data.length ||
                          index % labelEvery != 0) {
                        return const SizedBox();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          '${data[index].date.day}',
                          style: context.typo.caption.copyWith(
                            color: colors.subtext,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i < data.length; i++)
                  BarChartGroupData(
                    x: i,
                    barsSpace: barsSpace,
                    barRods: [
                      BarChartRodData(
                        toY: data[i].income,
                        color: colors.ok,
                        width: rodWidth,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      BarChartRodData(
                        toY: data[i].expense,
                        color: colors.danger,
                        width: rodWidth,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
