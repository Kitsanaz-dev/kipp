import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/features/expense/domain/services/expense_stats.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';

import 'expense_test_helpers.dart';

void main() {
  final feb2026 = DateRange.month(DateTime(2026, 2)); // 28 days
  final feb2028 = DateRange.month(DateTime(2028, 2)); // 29 days
  final dec2026 = DateRange.month(DateTime(2026, 12)); // 31 days

  group('inRange', () {
    test('empty input', () {
      expect(ExpenseStats.inRange(const [], feb2026), isEmpty);
    });

    test('keeps only in-range items in source order', () {
      final items = [
        tx('lastDay', DateTime(2026, 2, 28, 23, 59), 1),
        tx('march', DateTime(2026, 3, 1), 2),
        tx('first', DateTime(2026, 2, 1), 3),
        tx('jan', DateTime(2026, 1, 31, 23, 59), 4),
      ];
      expect(
        ExpenseStats.inRange(items, feb2026).map((e) => e.id),
        ['lastDay', 'first'],
      );
    });

    test('leap day is inside Feb 2028', () {
      final items = [tx('leap', DateTime(2028, 2, 29, 12), 1)];
      expect(ExpenseStats.inRange(items, feb2028), hasLength(1));
    });
  });

  group('totals', () {
    test('empty input', () {
      final t = ExpenseStats.totals(const []);
      expect(t.income, 0);
      expect(t.expense, 0);
    });

    test('splits income and expense', () {
      final t = ExpenseStats.totals([
        tx('a', DateTime(2026), 100, income: true),
        tx('b', DateTime(2026), 30),
        tx('c', DateTime(2026), 20),
      ]);
      expect(t.income, 100);
      expect(t.expense, 50);
    });
  });

  group('expenseByCategory', () {
    test('empty input', () {
      expect(ExpenseStats.expenseByCategory(const []), isEmpty);
    });

    test('income-only input yields no categories', () {
      expect(
        ExpenseStats.expenseByCategory([
          tx('a', DateTime(2026), 10, income: true, category: 'Salary'),
        ]),
        isEmpty,
      );
    });

    test('groups expenses, sorts desc, computes share and count', () {
      final result = ExpenseStats.expenseByCategory([
        tx('a', DateTime(2026), 30, category: 'Food'),
        tx('b', DateTime(2026), 50, category: 'Travel'),
        tx('c', DateTime(2026), 20, category: 'Food'),
        tx('d', DateTime(2026), 25, category: 'Shopping'),
        tx('e', DateTime(2026), 999, income: true, category: 'Salary'),
      ]);

      // Food 50 and Travel 50 tie → alphabetical.
      expect(result.map((c) => c.category), ['Food', 'Travel', 'Shopping']);
      expect(result.map((c) => c.amount), [50, 50, 25]);
      expect(result.map((c) => c.count), [2, 1, 1]);
      expect(result.map((c) => c.share), [0.4, 0.4, 0.2]);
      expect(result.fold<double>(0, (s, c) => s + c.share), closeTo(1, 1e-9));
    });
  });

  group('dailyTotals', () {
    test('empty input is zero-filled for a 28-day February', () {
      final data = ExpenseStats.dailyTotals(const [], feb2026);
      expect(data, hasLength(28));
      expect(data.first.date, DateTime(2026, 2, 1));
      expect(data.last.date, DateTime(2026, 2, 28));
      expect(data.every((d) => d.income == 0 && d.expense == 0), isTrue);
    });

    test('29-day February 2028 includes the leap day', () {
      final data = ExpenseStats.dailyTotals([
        tx('leap', DateTime(2028, 2, 29, 18), 7),
      ], feb2028);
      expect(data, hasLength(29));
      expect(data.last.date, DateTime(2028, 2, 29));
      expect(data.last.expense, 7);
    });

    test('31-day month aggregates per day and ignores out-of-range', () {
      final data = ExpenseStats.dailyTotals([
        tx('a', DateTime(2026, 12, 1), 10),
        tx('b', DateTime(2026, 12, 1, 22), 5),
        tx('c', DateTime(2026, 12, 1, 8), 3, income: true),
        tx('d', DateTime(2026, 12, 31, 23, 59), 4),
        tx('e', DateTime(2027, 1, 1), 1000),
        tx('f', DateTime(2026, 11, 30, 23, 59), 1000),
      ], dec2026);

      expect(data, hasLength(31));
      expect(data.first.expense, 15);
      expect(data.first.income, 3);
      expect(data.last.expense, 4);
      expect(data.fold<double>(0, (s, d) => s + d.expense), 19);
    });

    test('works for a week range across a month boundary', () {
      final data = ExpenseStats.dailyTotals(
        const [],
        DateRange.week(DateTime(2026, 12, 2)),
      );
      expect(data.map((d) => d.date.day), [30, 1, 2, 3, 4, 5, 6]);
    });
  });

  group('topExpenses', () {
    test('empty input', () {
      expect(ExpenseStats.topExpenses(const []), isEmpty);
    });

    test('largest expenses first, income ignored, default limit 3', () {
      final result = ExpenseStats.topExpenses([
        tx('small', DateTime(2026), 1),
        tx('big', DateTime(2026), 100),
        tx('income', DateTime(2026), 5000, income: true),
        tx('mid', DateTime(2026), 50),
        tx('mid2', DateTime(2026), 50),
      ]);
      expect(result.map((e) => e.id), ['big', 'mid', 'mid2']);
    });

    test('respects custom limit and short input', () {
      final items = [tx('a', DateTime(2026), 1), tx('b', DateTime(2026), 2)];
      expect(ExpenseStats.topExpenses(items, limit: 1).map((e) => e.id), ['b']);
      expect(ExpenseStats.topExpenses(items, limit: 5), hasLength(2));
    });
  });
}
