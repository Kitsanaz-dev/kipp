// features/expense/data/repositories/expense_repository_impl.dart
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDatasource datasource;

  ExpenseRepositoryImpl(this.datasource);

  @override
  Future<List<ExpenseEntity>> getAllExpenses() async {
    final models = await datasource.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addExpense(ExpenseEntity expense) =>
      datasource.add(ExpenseModel.fromEntity(expense));

  @override
  Future<void> deleteExpense(String id) => datasource.delete(id);

  @override
  Future<void> updateExpense(ExpenseEntity expense) =>
      datasource.update(ExpenseModel.fromEntity(expense));
}