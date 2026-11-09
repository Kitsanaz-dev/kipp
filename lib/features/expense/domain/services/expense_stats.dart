// features/expense/domain/services/expense_stats.dart
import '../entities/expense_entity.dart';
import '../value_objects/daily_totals.dart';
import '../value_objects/date_range.dart';

/// Expense total for one category within a set of transactions.
class CategoryTotal {
  const CategoryTotal({
    required this.category,
    required this.amount,
    required this.share,
    required this.count,
  });

  final String category;
  final double amount;

  /// Fraction of the total expense, 0..1.
  final double share;
  final int count;
}

/// Pure, side-effect-free statistics over expense lists.
/// No Flutter, no Riverpod, no clock: callers pass every input explicitly.
abstract final class ExpenseStats {
  /// Transactions whose date falls inside [range], in source order.
  static List<ExpenseEntity> inRange(
    List<ExpenseEntity> all,
    DateRange range,
  ) => all.where((e) => range.contains(e.date)).toList();

  static ({double income, double expense}) totals(
    Iterable<ExpenseEntity> items,
  ) {
    var income = 0.0;
    var expense = 0.0;
    for (final e in items) {
      if (e.isIncome) {
        income += e.amount;
      } else {
        expense += e.amount;
      }
    }
    return (income: income, expense: expense);
  }

  /// Expenses only (income ignored), grouped by category and sorted by amount
  /// descending; ties are broken by category name for a stable order.
  static List<CategoryTotal> expenseByCategory(Iterable<ExpenseEntity> items) {
    final amounts = <String, double>{};
    final counts = <String, int>{};
    var total = 0.0;
    for (final e in items) {
      if (e.isIncome) continue;
      amounts[e.category] = (amounts[e.category] ?? 0) + e.amount;
      counts[e.category] = (counts[e.category] ?? 0) + 1;
      total += e.amount;
    }

    final result = [
      for (final entry in amounts.entries)
        CategoryTotal(
          category: entry.key,
          amount: entry.value,
          share: total > 0 ? entry.value / total : 0,
          count: counts[entry.key]!,
        ),
    ];
    result.sort((a, b) {
      final byAmount = b.amount.compareTo(a.amount);
      return byAmount != 0 ? byAmount : a.category.compareTo(b.category);
    });
    return result;
  }

  /// One entry per day of [range] (oldest first), zero-filled for days with no
  /// transactions. Transactions outside [range] are ignored.
  static List<DailyChartData> dailyTotals(
    Iterable<ExpenseEntity> items,
    DateRange range,
  ) {
    final income = <DateTime, double>{};
    final expense = <DateTime, double>{};
    for (final e in items) {
      if (!range.contains(e.date)) continue;
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      final bucket = e.isIncome ? income : expense;
      bucket[day] = (bucket[day] ?? 0) + e.amount;
    }
    return [
      for (final day in range.days)
        DailyChartData(
          date: day,
          income: income[day] ?? 0,
          expense: expense[day] ?? 0,
        ),
    ];
  }

  /// The [limit] largest expenses (income ignored), largest first. Equal
  /// amounts keep their source order.
  static List<ExpenseEntity> topExpenses(
    Iterable<ExpenseEntity> items, {
    int limit = 3,
  }) {
    final indexed = items.where((e) => !e.isIncome).indexed.toList()
      ..sort((a, b) {
        final byAmount = b.$2.amount.compareTo(a.$2.amount);
        return byAmount != 0 ? byAmount : a.$1.compareTo(b.$1);
      });
    return [for (final (_, e) in indexed.take(limit)) e];
  }
}
