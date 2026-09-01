// features/expense/presentation/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/utils/date_group_formatter.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart';
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

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExpenseCalendar(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              eventLoader: (day) => _transactionsForDay(allExpenses, day),
              onDaySelected: (selectedDay, focusedDay) => setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              }),
              onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            ),
            const SizedBox(height: 20),
            Text(
              DateGroupFormatter.label(_selectedDay),
              style: context.typo.title.copyWith(color: context.colors.text),
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
