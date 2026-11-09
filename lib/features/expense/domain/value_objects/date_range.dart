// features/expense/domain/value_objects/date_range.dart

/// A half-open span of local calendar days: [start] is inclusive, [end] is
/// exclusive, and both sit on local midnight.
///
/// Implements value equality so it can be used as a Riverpod family argument.
class DateRange {
  const DateRange(this.start, this.end);

  /// The single day containing [d].
  factory DateRange.day(DateTime d) =>
      DateRange(DateTime(d.year, d.month, d.day), DateTime(d.year, d.month, d.day + 1));

  /// The Monday-to-Sunday week containing [d].
  factory DateRange.week(DateTime d) {
    final monday = DateTime(d.year, d.month, d.day - (d.weekday - DateTime.monday));
    return DateRange(monday, DateTime(monday.year, monday.month, monday.day + 7));
  }

  /// The calendar month containing [d].
  factory DateRange.month(DateTime d) =>
      DateRange(DateTime(d.year, d.month), DateTime(d.year, d.month + 1));

  final DateTime start;
  final DateTime end;

  bool contains(DateTime t) => !t.isBefore(start) && t.isBefore(end);

  /// Every local midnight in the range, oldest first. Steps by calendar day
  /// (not 24h) so DST transitions never skip or repeat a day.
  List<DateTime> get days => [
    for (var d = start; d.isBefore(end); d = DateTime(d.year, d.month, d.day + 1)) d,
  ];

  /// Whether this range spans exactly one calendar month.
  bool get isMonth =>
      start.day == 1 &&
      start.hour == 0 &&
      end == DateTime(start.year, start.month + 1);

  /// The month before this one. Only valid for month ranges.
  DateRange previousMonth() {
    assert(isMonth, 'previousMonth() requires a month range');
    return DateRange.month(DateTime(start.year, start.month - 1));
  }

  /// The month after this one. Only valid for month ranges.
  DateRange nextMonth() {
    assert(isMonth, 'nextMonth() requires a month range');
    return DateRange.month(DateTime(start.year, start.month + 1));
  }

  @override
  bool operator ==(Object other) =>
      other is DateRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'DateRange($start – $end)';
}

/// The home screen's period filter.
enum PeriodFilter {
  today,
  thisWeek,
  thisMonth;

  DateRange toRange(DateTime now) => switch (this) {
    PeriodFilter.today => DateRange.day(now),
    PeriodFilter.thisWeek => DateRange.week(now),
    PeriodFilter.thisMonth => DateRange.month(now),
  };
}
