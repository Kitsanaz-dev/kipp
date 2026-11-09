// features/expense/presentation/screens/expense_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/utils/currency_formatter.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';
import 'package:kipp/features/expense/presentation/widgets/daily_bar_chart.dart';
import 'package:kipp/features/expense/presentation/widgets/grouped_transaction_list.dart';
import 'package:kipp/features/expense/presentation/widgets/month_switcher.dart';
import 'package:kipp/features/expense/presentation/widgets/total_card.dart';

class ExpenseScreen extends ConsumerStatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends ConsumerState<ExpenseScreen> {
  bool _showIncome = false;
  DateRange _month = DateRange.month(DateTime.now());

  /// Minimum fling speed (logical px/s) for a chart swipe to change month.
  static const _swipeVelocity = 300.0;

  /// Moves to [target] if it lies within [earliest month, current month].
  void _goToMonth(DateRange target) {
    final first = ref.read(earliestExpenseMonthProvider);
    final last = DateRange.month(DateTime.now()).start;
    if (target.start.isBefore(first) || target.start.isAfter(last)) return;
    setState(() => _month = target);
  }

  void _onChartSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < _swipeVelocity) return;
    // Swipe left → later month, swipe right → earlier month.
    _goToMonth(velocity < 0 ? _month.nextMonth() : _month.previousMonth());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final chartData = ref.watch(monthlyChartDataProvider(_month));
    final summary = ref.watch(periodSummaryProvider(_month));
    final transactions = ref
        .watch(expensesInRangeProvider(_month))
        .where((e) => e.isIncome == _showIncome)
        .toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MonthSwitcher(
              month: _month,
              first: ref.watch(earliestExpenseMonthProvider),
              last: DateTime.now(),
              onChanged: (month) => setState(() => _month = month),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onHorizontalDragEnd: _onChartSwipe,
              child: DailyBarChart(data: chartData),
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
              emptyText: context.text.noTransactionsThisMonth,
            ),
          ],
        ),
      ),
    );
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
