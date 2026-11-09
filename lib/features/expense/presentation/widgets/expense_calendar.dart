// features/expense/presentation/widgets/expense_calendar.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/widgets/month_year_picker.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart';
import 'package:table_calendar/table_calendar.dart';

/// Calendar themed to the app palette. Days with income get a green dot and
/// days with expenses a red dot. Tapping the month title opens a month/year
/// picker; a "Today" shortcut appears when another month is shown. A vertical
/// swipe toggles between month and two-week formats.
class ExpenseCalendar extends StatefulWidget {
  const ExpenseCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.firstMonth,
    required this.eventLoader,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onMonthPicked,
    required this.onJumpToToday,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;

  /// Earliest month with data; the calendar starts at January of its year.
  final DateTime firstMonth;
  final List<ExpenseEntity> Function(DateTime day) eventLoader;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

  /// Called with the first day of the month chosen in the header picker.
  final ValueChanged<DateTime> onMonthPicked;
  final VoidCallback onJumpToToday;

  @override
  State<ExpenseCalendar> createState() => _ExpenseCalendarState();
}

class _ExpenseCalendarState extends State<ExpenseCalendar> {
  static const _markerSize = 5.0;

  CalendarFormat _format = CalendarFormat.month;

  DateTime get _firstDay => DateTime(widget.firstMonth.year, 1, 1);
  DateTime get _lastDay => DateTime(DateTime.now().year, 12, 31);

  Future<void> _openMonthPicker(DateTime focusedMonth) async {
    final picked = await showMonthYearPicker(
      context,
      initial: focusedMonth,
      first: widget.firstMonth,
      last: DateTime(DateTime.now().year, 12),
    );
    if (picked != null && mounted) widget.onMonthPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final captionStyle = context.typo.caption.copyWith(color: colors.subtext);
    final dayStyle = context.typo.body.copyWith(color: colors.text);
    final localeTag = Localizations.localeOf(context).toLanguageTag();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colors.inactiveContainer),
      ),
      child: TableCalendar<ExpenseEntity>(
        locale: localeTag,
        firstDay: _firstDay,
        lastDay: _lastDay,
        focusedDay: widget.focusedDay,
        currentDay: DateTime.now(),
        selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
        eventLoader: widget.eventLoader,
        calendarFormat: _format,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
          CalendarFormat.twoWeeks: '2 weeks',
        },
        onFormatChanged: (format) => setState(() => _format = format),
        onDaySelected: widget.onDaySelected,
        onPageChanged: widget.onPageChanged,
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
          selectedTextStyle: context.typo.body.copyWith(
            color: colors.onPrimary,
          ),
          markerSize: _markerSize,
          markerMargin: const EdgeInsets.only(top: 4),
        ),
        calendarBuilders: CalendarBuilders<ExpenseEntity>(
          headerTitleBuilder: (context, focusedMonth) =>
              _buildHeaderTitle(context, focusedMonth, localeTag),
          markerBuilder: _buildMarkers,
        ),
      ),
    );
  }

  Widget _buildHeaderTitle(
    BuildContext context,
    DateTime focusedMonth,
    String localeTag,
  ) {
    final colors = context.colors;
    final now = DateTime.now();
    final showJump =
        focusedMonth.year != now.year || focusedMonth.month != now.month;

    return Stack(
      alignment: Alignment.center,
      children: [
        Semantics(
          button: true,
          hint: context.text.selectMonth,
          child: GestureDetector(
            onTap: () => _openMonthPicker(focusedMonth),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              // Leave room for the "Today" button on either side.
              padding: const EdgeInsets.symmetric(horizontal: 56),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      DateFormat.yMMMM(localeTag).format(focusedMonth),
                      style: context.typo.title.copyWith(color: colors.text),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.expand_more, size: 18, color: colors.subtext),
                ],
              ),
            ),
          ),
        ),
        if (showJump)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: widget.onJumpToToday,
              style: TextButton.styleFrom(
                foregroundColor: colors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                context.text.jumpToToday,
                style: context.typo.caption.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Up to two dots under the day: green for income, red for expense.
  /// Positioned like table_calendar's default auto-aligned markers.
  Widget? _buildMarkers(
    BuildContext context,
    DateTime day,
    List<ExpenseEntity> events,
  ) {
    if (events.isEmpty) return null;
    final colors = context.colors;
    final hasIncome = events.any((e) => e.isIncome);
    final hasExpense = events.any((e) => !e.isIncome);

    Widget dot(Color color, Key key) => Container(
      key: key,
      width: _markerSize,
      height: _markerSize,
      margin: const EdgeInsets.only(top: 4, left: 1, right: 1),
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );

    return Positioned.fill(
      child: IgnorePointer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const cellMarginVertical = 12.0; // CalendarStyle default (6 * 2)
            const markersAnchor = 0.7; // CalendarStyle default
            final shorterSide = math.min(
              constraints.maxWidth,
              constraints.maxHeight,
            );
            final top =
                constraints.maxHeight / 2 +
                (shorterSide - cellMarginVertical) / 2 -
                _markerSize * markersAnchor;
            return Stack(
              children: [
                Positioned(
                  top: top,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hasIncome)
                        dot(colors.ok, const ValueKey('income-marker')),
                      if (hasExpense)
                        dot(colors.danger, const ValueKey('expense-marker')),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
