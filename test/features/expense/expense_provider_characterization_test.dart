// Characterization tests: pin the CURRENT behavior of the derived expense
// providers so later refactors can be checked against it.
import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';

import 'expense_test_helpers.dart';

// Day-type filter indices as used by the home screen.
const _today = 0;
const _thisWeek = 1;
const _thisMonth = 2;

void main() {
  group('expensesByDayType', () {
    test('empty list yields empty results for every filter', () async {
      final c = await containerWith(const []);
      for (final type in [_today, _thisWeek, _thisMonth]) {
        expect(c.read(expensesByDayTypeProvider(type)), isEmpty);
      }
    });

    test('today: includes from local midnight, excludes yesterday', () async {
      final now = DateTime.now();
      final today0 = midnight(now);
      final c = await containerWith([
        tx('a', today0, 10),
        tx('b', now, 20),
        tx('c', today0.subtract(const Duration(seconds: 1)), 30),
      ]);

      final ids = c.read(expensesByDayTypeProvider(_today)).map((e) => e.id);
      expect(ids, ['a', 'b']);
    });

    test('this week starts Monday 00:00 (Sunday→Monday boundary)', () async {
      final now = DateTime.now();
      final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
      final sundayLate = monday.subtract(const Duration(seconds: 1));
      final c = await containerWith([
        tx('monday', monday, 10),
        tx('now', now, 20),
        tx('sunday', sundayLate, 30),
      ]);

      expect(monday.weekday, DateTime.monday);
      expect(sundayLate.weekday, DateTime.sunday);
      final ids = c.read(expensesByDayTypeProvider(_thisWeek)).map((e) => e.id);
      expect(ids, ['monday', 'now']);
    });

    test('this month: month boundary and same month of another year', () async {
      final now = DateTime.now();
      final first = DateTime(now.year, now.month, 1);
      final c = await containerWith([
        tx('first', first, 10),
        tx('now', now, 20),
        tx('prevMonthEnd', first.subtract(const Duration(seconds: 1)), 30),
        tx('lastYear', DateTime(now.year - 1, now.month, 1), 40),
      ]);

      final ids = c.read(expensesByDayTypeProvider(_thisMonth)).map((e) => e.id);
      expect(ids, ['first', 'now']);
    });

    test('preserves source order', () async {
      final now = DateTime.now();
      final c = await containerWith([
        tx('newer', now, 1),
        tx('older', midnight(now), 2),
      ]);
      final ids = c.read(expensesByDayTypeProvider(_today)).map((e) => e.id);
      expect(ids, ['newer', 'older']);
    });
  });

  group('expenseSummary', () {
    test('empty list sums to zero', () async {
      final c = await containerWith(const []);
      final s = c.read(expenseSummaryProvider(_today));
      expect(s.income, 0);
      expect(s.expense, 0);
    });

    test('income-only list has zero expense', () async {
      final now = DateTime.now();
      final c = await containerWith([
        tx('a', now, 100, income: true, category: 'Salary'),
        tx('b', now, 50, income: true, category: 'Bonus'),
      ]);
      final s = c.read(expenseSummaryProvider(_thisMonth));
      expect(s.income, 150);
      expect(s.expense, 0);
    });

    test('sums only transactions inside the filter', () async {
      final now = DateTime.now();
      final first = DateTime(now.year, now.month, 1);
      final c = await containerWith([
        tx('a', now, 100, income: true),
        tx('b', now, 30),
        tx('c', first.subtract(const Duration(days: 1)), 999),
        tx('d', first.subtract(const Duration(days: 1)), 999, income: true),
      ]);
      final s = c.read(expenseSummaryProvider(_thisMonth));
      expect(s.income, 100);
      expect(s.expense, 30);
    });
  });

  group('dailyChartData', () {
    test('14 zero-filled days, oldest first, ending today', () async {
      final now = DateTime.now();
      final c = await containerWith(const []);
      final data = c.read(dailyChartDataProvider);

      expect(data, hasLength(14));
      final first = DateTime(now.year, now.month, now.day - 13);
      expect(
        (data.first.date.year, data.first.date.month, data.first.date.day),
        (first.year, first.month, first.day),
      );
      expect(
        (data.last.date.year, data.last.date.month, data.last.date.day),
        (now.year, now.month, now.day),
      );
      for (var i = 1; i < data.length; i++) {
        expect(data[i].date.isAfter(data[i - 1].date), isTrue);
      }
      expect(data.every((d) => d.income == 0 && d.expense == 0), isTrue);
    });

    test('aggregates per day and ignores days outside the window', () async {
      final now = DateTime.now();
      final today0 = midnight(now);
      final c = await containerWith([
        tx('a', today0, 10),
        tx('b', now, 5),
        tx('c', now, 7, income: true),
        tx('d', DateTime(now.year, now.month, now.day - 13, 12), 3),
        tx('e', DateTime(now.year, now.month, now.day - 14, 12), 1000),
      ]);
      final data = c.read(dailyChartDataProvider);

      expect(data.last.expense, 15);
      expect(data.last.income, 7);
      expect(data.first.expense, 3);
      final total = data.fold<double>(0, (s, d) => s + d.expense);
      expect(total, 18);
    });
  });

  group('expenseTotals', () {
    test('empty list sums to zero', () async {
      final c = await containerWith(const []);
      final t = c.read(expenseTotalsProvider);
      expect(t.totalIncome, 0);
      expect(t.totalExpense, 0);
    });

    test('sums all-time regardless of date', () async {
      final now = DateTime.now();
      final c = await containerWith([
        tx('a', now, 100, income: true),
        tx('b', DateTime(2001, 1, 1), 40),
        tx('c', DateTime(2001, 1, 1), 10, income: true),
        tx('d', now, 2),
      ]);
      final t = c.read(expenseTotalsProvider);
      expect(t.totalIncome, 110);
      expect(t.totalExpense, 42);
    });

    test('income-only list has zero expense', () async {
      final c = await containerWith([
        tx('a', DateTime.now(), 5, income: true),
      ]);
      expect(c.read(expenseTotalsProvider).totalExpense, 0);
    });
  });
}
