// features/expense/domain/repositories/expense_repository.dart
import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseEntity>> getAllExpenses();
  Future<void> addExpense(ExpenseEntity expense);
  Future<void> deleteExpense(String id);
  Future<void> updateExpense(ExpenseEntity expense);
}