// features/expense/presentation/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/utils/currency_formatter.dart';
import 'package:kipp/core/utils/date_group_formatter.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart';
import 'package:kipp/features/expense/domain/services/expense_stats.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';
import 'package:kipp/features/expense/presentation/widgets/expense_calendar.dart';
import 'package:kipp/features/expense/presentation/widgets/grouped_transaction_list.dart';
import 'package:table_calendar/table_calendar.dart' show isSameDay;

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<ExpenseEntity> _transactionsForDay(
    List<ExpenseEntity> all,
    DateTime day,
  ) => all.where((tx) => isSameDay(tx.date, day)).toList();

  @override
  Widget build(BuildContext context) {
    final allExpenses = ref.watch(expenseListProvider).valueOrNull ?? const [];
    final selectedList = _transactionsForDay(allExpenses, _selectedDay);
    final dayTotals = ExpenseStats.totals(selectedList);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExpenseCalendar(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              firstMonth: ref.watch(earliestExpenseMonthProvider),
              eventLoader: (day) => _transactionsForDay(allExpenses, day),
              onDaySelected: (selectedDay, focusedDay) => setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              }),
              onPageChanged: (focusedDay) => _focusedDay = focusedDay,
              onMonthPicked: (month) => setState(() => _focusedDay = month),
              onJumpToToday: () => setState(() {
                final now = DateTime.now();
                _focusedDay = now;
                _selectedDay = now;
              }),
            ),
            const SizedBox(height: 20),
            Text(
              DateGroupFormatter.label(_selectedDay),
              style: context.typo.title.copyWith(color: context.colors.text),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _DayTotal(
                    label: context.text.dayIncome,
                    amount: dayTotals.income,
                    color: context.colors.ok,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DayTotal(
                    label: context.text.dayExpense,
                    amount: dayTotals.expense,
                    color: context.colors.danger,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GroupedTransactionList(
              transactions: selectedList,
              byDay: false,
              emptyText: context.text.noTransactionsOnThisDay,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact "label / amount" pair for the selected day's totals.
class _DayTotal extends StatelessWidget {
  const _DayTotal({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.mdAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.typo.caption.copyWith(color: context.colors.subtext),
          ),
          const SizedBox(height: 2),
          Text(
            CurrencyFormatter.formatKip(amount),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.typo.subtitle.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
