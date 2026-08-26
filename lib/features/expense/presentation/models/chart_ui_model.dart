// features/expense/presentation/models/chart_ui_model.dart
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