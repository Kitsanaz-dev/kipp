// features/expense/presentation/providers/expense_provider.dart
import 'package:kipp/features/expense/presentation/models/chart_ui_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/datasources/expense_remote_datasource.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/services/expense_stats.dart';
import '../../domain/value_objects/date_range.dart';
import '../../domain/value_objects/period_summary.dart';

part 'expense_provider.g.dart';

@riverpod
ExpenseRepository expenseRepository(ExpenseRepositoryRef ref) {
  return ExpenseRepositoryImpl(
    ExpenseRemoteDatasource(ref.watch(apiClientProvider)),
  );
}

/// List ຂອງ transaction ທັງໝົດ - single source of truth
@riverpod
class ExpenseList extends _$ExpenseList {
  @override
  Future<List<ExpenseEntity>> build() async {
    return ref.watch(expenseRepositoryProvider).getAllExpenses();
  }

  Future<void> add(ExpenseEntity expense) async {
    await ref.read(expenseRepositoryProvider).addExpense(expense);
    ref.invalidateSelf();
    await future; // ລໍໃຫ້ rebuild ສຳເລັດກ່ອນ return
  }

  Future<void> delete(String id) async {
    await ref.read(expenseRepositoryProvider).deleteExpense(id);
    ref.invalidateSelf();
    await future;
  }
}

/// Filter ຕາມ dayType (0=Today, 1=Week, 2=Month) - derived ຈາກ expenseListProvider
@riverpod
List<ExpenseEntity> expensesByDayType(ExpensesByDayTypeRef ref, int dayType) {
  final range = PeriodFilter.values[dayType].toRange(DateTime.now());
  return ref.watch(expensesInRangeProvider(range));
}

/// ຄິດໄລ່ income/expense sum ຈາກ list ທີ່ filter ແລ້ວ
@riverpod
({double income, double expense}) expenseSummary(ExpenseSummaryRef ref, int dayType) {
  final range = PeriodFilter.values[dayType].toRange(DateTime.now());
  final summary = ref.watch(periodSummaryProvider(range));
  return (income: summary.income, expense: summary.expense);
}

/// ຄິດໄລ່ chart data 14 ວັນລ່າສຸດ ຈາກ transaction ຈິງ
@riverpod
List<DailyChartData> dailyChartData(DailyChartDataRef ref) {
  final all = ref.watch(expenseListProvider).valueOrNull ?? [];
  final today = DateTime.now();
  final startDay = DateTime(today.year, today.month, today.day);

  return List.generate(14, (i) {
    final day = startDay.subtract(Duration(days: 13 - i));
    final dayItems = all.where(
      (e) => e.date.year == day.year && e.date.month == day.month && e.date.day == day.day,
    );
    final income = dayItems.where((e) => e.isIncome).fold(0.0, (sum, e) => sum + e.amount);
    final expense = dayItems.where((e) => !e.isIncome).fold(0.0, (sum, e) => sum + e.amount);
    return DailyChartData(date: day, income: income, expense: expense);
  });
}

/// ຍອດລວມ income/expense ທັງໝົດ (all-time) - ໃຊ້ໃນ ExpenseScreen
@riverpod
({double totalIncome, double totalExpense}) expenseTotals(ExpenseTotalsRef ref) {
  final all = ref.watch(expenseListProvider).valueOrNull ?? [];
  final income = all.where((e) => e.isIncome).fold(0.0, (sum, e) => sum + e.amount);
  final expense = all.where((e) => !e.isIncome).fold(0.0, (sum, e) => sum + e.amount);
  return (totalIncome: income, totalExpense: expense);
}

// ---------------------------------------------------------------------------
// Range-based providers (DateRange / ExpenseStats)
// ---------------------------------------------------------------------------

/// Transactions inside [range], in source order (newest first).
@riverpod
List<ExpenseEntity> expensesInRange(ExpensesInRangeRef ref, DateRange range) {
  final all = ref.watch(expenseListProvider).valueOrNull ?? const [];
  return ExpenseStats.inRange(all, range);
}

/// Totals, category breakdown and top expenses for [range].
@riverpod
PeriodSummary periodSummary(PeriodSummaryRef ref, DateRange range) {
  return PeriodSummary.from(ref.watch(expensesInRangeProvider(range)));
}

/// One zero-filled [DailyChartData] per day of [month], oldest first.
@riverpod
List<DailyChartData> monthlyChartData(MonthlyChartDataRef ref, DateRange month) {
  return ExpenseStats.dailyTotals(ref.watch(expensesInRangeProvider(month)), month);
}

/// First day of the month of the oldest transaction, or of the current month
/// when there are none (never later than the current month). Used to bound
/// month pickers.
@riverpod
DateTime earliestExpenseMonth(EarliestExpenseMonthRef ref) {
  final all = ref.watch(expenseListProvider).valueOrNull ?? const [];
  var earliest = DateTime.now();
  for (final e in all) {
    if (e.date.isBefore(earliest)) earliest = e.date;
  }
  return DateTime(earliest.year, earliest.month);
}
