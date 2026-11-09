import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';

void main() {
  group('DateRange.day', () {
    test('spans local midnight to next midnight', () {
      final r = DateRange.day(DateTime(2026, 11, 9, 13, 45));
      expect(r.start, DateTime(2026, 11, 9));
      expect(r.end, DateTime(2026, 11, 10));
      expect(r.days, [DateTime(2026, 11, 9)]);
    });

    test('crosses month/year end', () {
      final r = DateRange.day(DateTime(2026, 12, 31, 23, 59));
      expect(r.end, DateTime(2027, 1, 1));
    });
  });

  group('DateRange.week', () {
    test('starts on Monday for a mid-week date', () {
      final r = DateRange.week(DateTime(2026, 11, 12)); // Thursday
      expect(r.start, DateTime(2026, 11, 9));
      expect(r.start.weekday, DateTime.monday);
      expect(r.end, DateTime(2026, 11, 16));
      expect(r.days, hasLength(7));
    });

    test('Sunday belongs to the week that started the previous Monday', () {
      final r = DateRange.week(DateTime(2026, 11, 15, 23, 59)); // Sunday
      expect(r.start, DateTime(2026, 11, 9));
    });

    test('Monday starts its own week', () {
      final r = DateRange.week(DateTime(2026, 11, 16));
      expect(r.start, DateTime(2026, 11, 16));
    });

    test('spans a month boundary', () {
      final r = DateRange.week(DateTime(2026, 12, 2)); // Wednesday
      expect(r.start, DateTime(2026, 11, 30));
      expect(r.end, DateTime(2026, 12, 7));
    });
  });

  group('DateRange.month', () {
    test('28-day February', () {
      final r = DateRange.month(DateTime(2026, 2, 14));
      expect(r.start, DateTime(2026, 2, 1));
      expect(r.end, DateTime(2026, 3, 1));
      expect(r.days, hasLength(28));
    });

    test('29-day February in a leap year', () {
      expect(DateRange.month(DateTime(2028, 2, 1)).days, hasLength(29));
    });

    test('31-day month and December rollover', () {
      final r = DateRange.month(DateTime(2026, 12, 31));
      expect(r.days, hasLength(31));
      expect(r.end, DateTime(2027, 1, 1));
      expect(r.days.last, DateTime(2026, 12, 31));
    });

    test('previousMonth / nextMonth cross the year boundary', () {
      final jan = DateRange.month(DateTime(2027, 1, 10));
      expect(jan.previousMonth(), DateRange.month(DateTime(2026, 12)));
      expect(jan.previousMonth().nextMonth(), jan);
      expect(jan.isMonth, isTrue);
      expect(DateRange.week(DateTime(2027, 1, 10)).isMonth, isFalse);
    });
  });

  group('contains', () {
    final r = DateRange.month(DateTime(2026, 11));

    test('start is inclusive, end is exclusive', () {
      expect(r.contains(DateTime(2026, 11, 1)), isTrue);
      expect(r.contains(DateTime(2026, 11, 30, 23, 59, 59)), isTrue);
      expect(r.contains(DateTime(2026, 12, 1)), isFalse);
      expect(r.contains(DateTime(2026, 10, 31, 23, 59, 59)), isFalse);
    });
  });

  group('equality', () {
    test('value equality and hashCode', () {
      final a = DateRange.month(DateTime(2026, 11, 3));
      final b = DateRange.month(DateTime(2026, 11, 28, 22));
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(DateRange.month(DateTime(2026, 10))));
    });
  });

  group('PeriodFilter.toRange', () {
    final now = DateTime(2026, 11, 12, 9); // Thursday

    test('maps each filter to its range', () {
      expect(PeriodFilter.today.toRange(now), DateRange.day(now));
      expect(PeriodFilter.thisWeek.toRange(now), DateRange.week(now));
      expect(PeriodFilter.thisMonth.toRange(now), DateRange.month(now));
    });

    test('enum order matches the legacy 0/1/2 day-type indices', () {
      expect(PeriodFilter.values.map((f) => f.index), [0, 1, 2]);
      expect(PeriodFilter.values, [
        PeriodFilter.today,
        PeriodFilter.thisWeek,
        PeriodFilter.thisMonth,
      ]);
    });
  });

  group('DateRange.year', () {
    test('spans Jan 1 to next Jan 1', () {
      final r = DateRange.year(DateTime(2028, 7, 4));
      expect(r.start, DateTime(2028));
      expect(r.end, DateTime(2029));
      expect(r.days, hasLength(366)); // leap year
      expect(DateRange.year(DateTime(2026)).days, hasLength(365));
    });
  });

  group('PeriodUnit', () {
    final d = DateTime(2026, 11, 12, 9); // Thursday

    test('rangeOf matches the named constructors', () {
      expect(PeriodUnit.day.rangeOf(d), DateRange.day(d));
      expect(PeriodUnit.week.rangeOf(d), DateRange.week(d));
      expect(PeriodUnit.month.rangeOf(d), DateRange.month(d));
      expect(PeriodUnit.year.rangeOf(d), DateRange.year(d));
    });

    test('shift steps one unit across boundaries', () {
      expect(
        PeriodUnit.day.shift(DateRange.day(DateTime(2026, 12, 31)), 1),
        DateRange.day(DateTime(2027, 1, 1)),
      );
      expect(
        PeriodUnit.week.shift(DateRange.week(DateTime(2026, 12, 30)), 1),
        DateRange.week(DateTime(2027, 1, 4)),
      );
      expect(
        PeriodUnit.month.shift(DateRange.month(DateTime(2026, 1)), -1),
        DateRange.month(DateTime(2025, 12)),
      );
      expect(
        PeriodUnit.year.shift(DateRange.year(DateTime(2026)), -2),
        DateRange.year(DateTime(2024)),
      );
      expect(
        PeriodUnit.day.shift(DateRange.day(DateTime(2028, 3, 1)), -1),
        DateRange.day(DateTime(2028, 2, 29)),
      );
    });
  });
}
