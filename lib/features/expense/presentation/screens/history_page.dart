// features/expense/presentation/screens/history_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/theme/app_theme.dart';
import 'package:kipp/core/utils/date_group_formatter.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';
import 'package:kipp/features/expense/presentation/widgets/transaction_tile.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  List<ExpenseEntity> _transactionsForDay(List<ExpenseEntity> all, DateTime day) {
    return all.where((tx) => isSameDay(tx.date, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final allExpenses = ref.watch(expenseListProvider).valueOrNull ?? [];
    final selectedList = _selectedDay == null
        ? <ExpenseEntity>[]
        : _transactionsForDay(allExpenses, _selectedDay!);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.lgAll,
                border: Border.all(color: colors.inactiveContainer),
              ),
              child: TableCalendar<ExpenseEntity>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                currentDay: DateTime.now(),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (day) => _transactionsForDay(allExpenses, day),
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: context.typo.title.copyWith(color: colors.text),
                  leftChevronIcon: Icon(Icons.chevron_left, color: colors.primary),
                  rightChevronIcon: Icon(Icons.chevron_right, color: colors.primary),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: context.typo.caption.copyWith(color: colors.subtext),
                  weekendStyle: context.typo.caption.copyWith(color: colors.subtext),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  defaultTextStyle: context.typo.body.copyWith(color: colors.text),
                  weekendTextStyle: context.typo.body.copyWith(color: colors.text),
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.primary, width: 1.5),
                  ),
                  todayTextStyle: context.typo.body.copyWith(color: colors.primary),
                  selectedDecoration: BoxDecoration(shape: BoxShape.circle, color: colors.primary),
                  selectedTextStyle: context.typo.body.copyWith(color: colors.onPrimary),
                  markerDecoration: BoxDecoration(shape: BoxShape.circle, color: colors.danger),
                  markersMaxCount: 1,
                  markerSize: 5,
                  markerMargin: const EdgeInsets.only(top: 4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _selectedDay == null ? 'History' : DateGroupFormatter.label(_selectedDay!),
              style: context.typo.title.copyWith(color: colors.text),
            ),
            const SizedBox(height: 8),
            if (selectedList.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'ບໍ່ມີລາຍການໃນວັນນີ້',
                    style: context.typo.body.copyWith(color: colors.subtext),
                  ),
                ),
              )
            else
              ...selectedList.map((tx) => TransactionTile(transaction: tx)),
          ],
        ),
      ),
    );
  }
}