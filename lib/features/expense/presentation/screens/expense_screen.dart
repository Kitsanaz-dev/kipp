// features/expense/presentation/screens/expense_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final chartData = ref.watch(dailyChartDataProvider);
    final totals = ref.watch(expenseTotalsProvider);
    final allExpenses = ref.watch(expenseListProvider).valueOrNull ?? const [];
    final transactions = allExpenses
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
            DailyBarChart(data: chartData),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TotalCard(
                    label: context.text.totalIncome,
                    amount: totals.totalIncome,
                    color: colors.ok,
                    icon: Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TotalCard(
                    label: context.text.totalExpense,
                    amount: totals.totalExpense,
                    color: colors.danger,
                    icon: Icons.arrow_upward,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildToggle(context),
            const SizedBox(height: 12),
            GroupedTransactionList(transactions: transactions),
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
