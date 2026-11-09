// features/expense/presentation/screens/expense_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/utils/currency_formatter.dart';
import 'package:kipp/core/widgets/glass_segmented_bar.dart';
import 'package:kipp/features/expense/domain/value_objects/daily_totals.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';
import 'package:kipp/features/expense/presentation/widgets/daily_bar_chart.dart';
import 'package:kipp/features/expense/presentation/widgets/grouped_transaction_list.dart';
import 'package:kipp/features/expense/presentation/widgets/period_switcher.dart';
import 'package:kipp/features/expense/presentation/widgets/total_card.dart';

class ExpenseScreen extends ConsumerStatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends ConsumerState<ExpenseScreen> {
  bool _showIncome = false;
  PeriodUnit _unit = PeriodUnit.month;
  DateRange _range = DateRange.month(DateTime.now());

  /// Minimum fling speed (logical px/s) for a chart swipe to change period.
  static const _swipeVelocity = 300.0;

  /// Moves to [target] if it overlaps [earliest data month, now].
  void _goTo(DateRange target) {
    final first = ref.read(earliestExpenseMonthProvider);
    if (!target.end.isAfter(first) || target.start.isAfter(DateTime.now())) {
      return;
    }
    setState(() => _range = target);
  }

  /// Switches granularity, staying on today when the current period contains
  /// it, otherwise on the start of the period being viewed.
  void _setUnit(PeriodUnit unit) {
    if (unit == _unit) return;
    final now = DateTime.now();
    final anchor = _range.contains(now) ? now : _range.start;
    setState(() {
      _unit = unit;
      _range = unit.rangeOf(anchor);
    });
  }

  void _onChartSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < _swipeVelocity) return;
    // Swipe left → later period, swipe right → earlier period.
    _goTo(_unit.shift(_range, velocity < 0 ? 1 : -1));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final chartData = ref.watch(periodChartDataProvider(_range));
    final summary = ref.watch(periodSummaryProvider(_range));
    final transactions = ref
        .watch(expensesInRangeProvider(_range))
        .where((e) => e.isIncome == _showIncome)
        .toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassSegmentedBar(
              labels: [
                context.text.periodDay,
                context.text.periodWeek,
                context.text.periodMonth,
                context.text.periodYear,
              ],
              selectedIndex: _unit.index,
              onSelected: (i) => _setUnit(PeriodUnit.values[i]),
            ),
            const SizedBox(height: 8),
            PeriodSwitcher(
              unit: _unit,
              range: _range,
              first: ref.watch(earliestExpenseMonthProvider),
              last: DateTime.now(),
              onChanged: (range) => setState(() => _range = range),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onHorizontalDragEnd: _onChartSwipe,
              child: _buildChart(context, chartData),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TotalCard(
                    label: context.text.totalIncome,
                    amount: summary.income,
                    color: colors.ok,
                    icon: Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TotalCard(
                    label: context.text.totalExpense,
                    amount: summary.expense,
                    color: colors.danger,
                    icon: Icons.arrow_upward,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _NetBalanceRow(balance: summary.balance),
            const SizedBox(height: 20),
            _buildToggle(context),
            const SizedBox(height: 12),
            GroupedTransactionList(
              transactions: transactions,
              emptyText: context.text.noTransactionsInPeriod,
            ),
          ],
        ),
      ),
    );
  }

  /// Bucket labels per unit: hours for a day, weekday names for a week, day
  /// numbers for a month, month names for a year.
  Widget _buildChart(BuildContext context, List<DailyChartData> data) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return switch (_unit) {
      PeriodUnit.day => DailyBarChart(data: data, labelOf: (d) => '${d.hour}'),
      PeriodUnit.week => DailyBarChart(
        data: data,
        labelOf: (d) => DateFormat.E(locale).format(d),
        labelEvery: 1,
      ),
      PeriodUnit.month => DailyBarChart(data: data),
      PeriodUnit.year => DailyBarChart(
        data: data,
        labelOf: (d) => DateFormat.MMM(locale).format(d),
      ),
    };
  }

  Widget _buildToggle(BuildContext context) {
    final colors = context.colors;
    return SegmentedButton<bool>(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (!states.contains(WidgetState.selected)) return Colors.transparent;
          return _showIncome ? colors.ok : colors.danger;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colors.onPrimary
              : colors.text;
        }),
        elevation: const WidgetStatePropertyAll(0),
      ),
      segments: [
        ButtonSegment(value: true, label: Text(context.text.income)),
        ButtonSegment(value: false, label: Text(context.text.expenses)),
      ],
      selected: {_showIncome},
      onSelectionChanged: (newSelection) =>
          setState(() => _showIncome = newSelection.first),
    );
  }
}

/// Compact "Net balance  ₭ …" line under the total cards.
class _NetBalanceRow extends StatelessWidget {
  const _NetBalanceRow({required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Text(
            context.text.netBalance,
            style: context.typo.bodySmall.copyWith(color: colors.subtext),
          ),
          const Spacer(),
          Text(
            CurrencyFormatter.formatKip(balance),
            style: context.typo.subtitle.copyWith(
              color: balance < 0 ? colors.danger : colors.ok,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
