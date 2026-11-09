// features/expense/domain/value_objects/daily_totals.dart

/// Income and expense sums for a single local day.
class DailyChartData {
  final DateTime date;
  final double income;
  final double expense;

  const DailyChartData({
    required this.date,
    required this.income,
    required this.expense,
  });
}
