// features/expense/domain/value_objects/period_summary.dart
import '../entities/expense_entity.dart';
import '../services/expense_stats.dart';

/// Aggregated figures for the transactions of one period.
class PeriodSummary {
  const PeriodSummary({
    required this.income,
    required this.expense,
    required this.count,
    required this.byCategory,
    required this.topExpenses,
  });

  factory PeriodSummary.from(List<ExpenseEntity> items) {
    final t = ExpenseStats.totals(items);
    return PeriodSummary(
      income: t.income,
      expense: t.expense,
      count: items.length,
      byCategory: ExpenseStats.expenseByCategory(items),
      topExpenses: ExpenseStats.topExpenses(items),
    );
  }

  final double income;
  final double expense;

  /// Number of transactions (income and expense).
  final int count;
  final List<CategoryTotal> byCategory;
  final List<ExpenseEntity> topExpenses;

  double get balance => income - expense;
  bool get isEmpty => count == 0;
}
