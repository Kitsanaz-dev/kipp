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

// TODO: ລົບ mock ນີ້ອອກຕອນຕໍ່ chartDataProvider ຈິງ (aggregate ຈາກ ExpenseRepository ຕາມວັນ)
final mockChartData = List.generate(14, (i) {
  final date = DateTime.now().subtract(Duration(days: 13 - i));
  return DailyChartData(
    date: date,
    income: (i % 4 == 0) ? 300000.0 + (i * 10000) : 0.0,
    expense: 50000.0 + (i * 15000) % 200000,
  );
});