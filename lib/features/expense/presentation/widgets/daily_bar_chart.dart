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

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colors.inactiveContainer),
      ),
      child: BarChart(
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
                reservedSize: 44,
                interval: step,
                getTitlesWidget: (value, _) => Text(
                  CurrencyFormatter.compact(value),
                  style: context.typo.caption.copyWith(color: colors.subtext),
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
                interval: 3,
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox();
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
                barsSpace: 3,
                barRods: [
                  BarChartRodData(
                    toY: data[i].income,
                    color: colors.ok,
                    width: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  BarChartRodData(
                    toY: data[i].expense,
                    color: colors.danger,
                    width: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
