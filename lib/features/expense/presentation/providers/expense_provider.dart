// features/expense/presentation/providers/expense_provider.dart
import 'package:kipp/features/expense/presentation/models/chart_ui_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/expense_local_datasource.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';

part 'expense_provider.g.dart';

@riverpod
ExpenseRepository expenseRepository(ExpenseRepositoryRef ref) {
  return ExpenseRepositoryImpl(ExpenseLocalDatasource());
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
  final all = ref.watch(expenseListProvider).valueOrNull ?? [];
  final now = DateTime.now();

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  return all.where((e) {
    switch (dayType) {
      case 0:
        return isSameDay(e.date, now);
      case 1:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return !e.date.isBefore(DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day));
      case 2:
        return e.date.year == now.year && e.date.month == now.month;
      default:
        return true;
    }
  }).toList();
}

/// ຄິດໄລ່ income/expense sum ຈາກ list ທີ່ filter ແລ້ວ
@riverpod
({double income, double expense}) expenseSummary(ExpenseSummaryRef ref, int dayType) {
  final list = ref.watch(expensesByDayTypeProvider(dayType));
  final income = list.where((e) => e.isIncome).fold(0.0, (sum, e) => sum + e.amount);
  final expense = list.where((e) => !e.isIncome).fold(0.0, (sum, e) => sum + e.amount);
  return (income: income, expense: expense);
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

/// ຍອດລວມ income/expense ທັງໝົດ (all-time) - ໃຊ້ໃນ ExpensePage
@riverpod
({double totalIncome, double totalExpense}) expenseTotals(ExpenseTotalsRef ref) {
  final all = ref.watch(expenseListProvider).valueOrNull ?? [];
  final income = all.where((e) => e.isIncome).fold(0.0, (sum, e) => sum + e.amount);
  final expense = all.where((e) => !e.isIncome).fold(0.0, (sum, e) => sum + e.amount);
  return (totalIncome: income, totalExpense: expense);
}