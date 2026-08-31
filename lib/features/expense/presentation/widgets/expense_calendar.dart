// features/expense/presentation/widgets/expense_calendar.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart';
import 'package:table_calendar/table_calendar.dart';

/// Month calendar themed to the app palette, with a marker dot on days that
/// have transactions.
class ExpenseCalendar extends StatelessWidget {
  const ExpenseCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.eventLoader,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<ExpenseEntity> Function(DateTime day) eventLoader;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final captionStyle = context.typo.caption.copyWith(color: colors.subtext);
    final dayStyle = context.typo.body.copyWith(color: colors.text);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colors.inactiveContainer),
      ),
      child: TableCalendar<ExpenseEntity>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: focusedDay,
        currentDay: DateTime.now(),
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        eventLoader: eventLoader,
        calendarFormat: CalendarFormat.month,
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: context.typo.title.copyWith(color: colors.text),
          leftChevronIcon: Icon(Icons.chevron_left, color: colors.primary),
          rightChevronIcon: Icon(Icons.chevron_right, color: colors.primary),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: captionStyle,
          weekendStyle: captionStyle,
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          defaultTextStyle: dayStyle,
          weekendTextStyle: dayStyle,
          todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.primary, width: 1.5),
          ),
          todayTextStyle: context.typo.body.copyWith(color: colors.primary),
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.primary,
          ),
          selectedTextStyle: context.typo.body.copyWith(color: colors.onPrimary),
          markerDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.danger,
          ),
          markersMaxCount: 1,
          markerSize: 5,
          markerMargin: const EdgeInsets.only(top: 4),
        ),
      ),
    );
  }
}
