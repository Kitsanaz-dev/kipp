// features/expense/presentation/screens/expense_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/utils/currency_formatter.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';
import 'package:kipp/features/expense/presentation/widgets/daily_bar_chart.dart';
import 'package:kipp/features/expense/presentation/widgets/grouped_transaction_list.dart';

class ExpensePage extends ConsumerStatefulWidget {
  const ExpensePage({super.key});

  @override
  ConsumerState<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends ConsumerState<ExpensePage> {
  bool _showIncome = false;

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
            DailyBarChart(data: chartData),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _TotalCard(
                    label: context.text.totalIncome,
                    amount: totals.totalIncome,
                    color: colors.ok,
                    icon: Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TotalCard(
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

class _TotalCard extends StatelessWidget {
  const _TotalCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: context.typo.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.formatKip(amount),
            style: context.typo.title.copyWith(color: context.colors.text),
          ),
        ],
      ),
    );
  }
}
