import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';

import 'expense_test_helpers.dart';

void main() {
  final nov = DateRange.month(DateTime(2026, 11));

  final fixtures = [
    tx('a', DateTime(2026, 11, 20), 100, income: true, category: 'Salary'),
    tx('b', DateTime(2026, 11, 15), 40, category: 'Food'),
    tx('c', DateTime(2026, 11, 1), 60, category: 'Travel'),
    tx('d', DateTime(2026, 10, 31, 23, 59), 500, category: 'Food'),
    tx('e', DateTime(2025, 3, 4), 1, category: 'Food'),
  ];

  test('expensesInRange keeps only the range, in source order', () async {
    final c = await containerWith(fixtures);
    expect(c.read(expensesInRangeProvider(nov)).map((e) => e.id), [
      'a',
      'b',
      'c',
    ]);
  });

  test('expensesInRange treats equal ranges as the same family key', () async {
    final c = await containerWith(fixtures);
    final p1 = expensesInRangeProvider(DateRange.month(DateTime(2026, 11, 3)));
    final p2 = expensesInRangeProvider(DateRange.month(DateTime(2026, 11, 27)));
    expect(p1, p2);
    expect(identical(c.read(p1), c.read(p1)), isTrue);
  });

  test(
    'periodSummary aggregates totals, categories and top expenses',
    () async {
      final c = await containerWith(fixtures);
      final s = c.read(periodSummaryProvider(nov));
      expect(s.income, 100);
      expect(s.expense, 100);
      expect(s.balance, 0);
      expect(s.count, 3);
      expect(s.isEmpty, isFalse);
      expect(s.byCategory.map((x) => x.category), ['Travel', 'Food']);
      expect(s.topExpenses.map((e) => e.id), ['c', 'b']);
    },
  );

  test('periodSummary for an empty range', () async {
    final c = await containerWith(fixtures);
    final s = c.read(periodSummaryProvider(DateRange.month(DateTime(2026, 2))));
    expect(s.isEmpty, isTrue);
    expect(s.byCategory, isEmpty);
    expect(s.topExpenses, isEmpty);
  });

  test('periodChartData has one entry per day of the month', () async {
    final c = await containerWith(fixtures);
    final data = c.read(periodChartDataProvider(nov));
    expect(data, hasLength(30));
    expect(data[0].expense, 60);
    expect(data[14].expense, 40);
    expect(data[19].income, 100);
  });

  test('periodChartData buckets a year by month', () async {
    final c = await containerWith(fixtures);
    final data = c.read(
      periodChartDataProvider(DateRange.year(DateTime(2026))),
    );
    expect(data, hasLength(12));
    expect(data[10].expense, 100);
    expect(data[10].income, 100);
    expect(data[9].expense, 500);
  });

  group('earliestExpenseMonth', () {
    test('first of the month of the oldest transaction', () async {
      final c = await containerWith(fixtures);
      expect(c.read(earliestExpenseMonthProvider), DateTime(2025, 3));
    });

    test('current month when there are no transactions', () async {
      final now = DateTime.now();
      final c = await containerWith(const []);
      expect(
        c.read(earliestExpenseMonthProvider),
        DateTime(now.year, now.month),
      );
    });

    test('never later than the current month', () async {
      final now = DateTime.now();
      final c = await containerWith([
        tx('future', DateTime(now.year + 1, 1, 1), 1),
      ]);
      expect(
        c.read(earliestExpenseMonthProvider),
        DateTime(now.year, now.month),
      );
    });
  });
}
