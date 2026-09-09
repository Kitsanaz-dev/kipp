// features/expense/data/repositories/expense_repository_impl.dart
import 'package:dio/dio.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_remote_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDatasource datasource;

  ExpenseRepositoryImpl(this.datasource);

  Never _rethrowDio(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw const NetworkException();
    }
    throw const ApiException();
  }

  @override
  Future<List<ExpenseEntity>> getAllExpenses() async {
    try {
      final json = await datasource.getAll();
      final list = json.map(ExpenseEntity.fromJson).toList()
        ..sort((a, b) => b.date.compareTo(a.date)); // ໃໝ່ສຸດຢູ່ເທິງ
      return list;
    } on DioException catch (e) {
      _rethrowDio(e);
    }
  }

  @override
  Future<void> addExpense(ExpenseEntity expense) async {
    try {
      await datasource.add(expense.toJson());
    } on DioException catch (e) {
      _rethrowDio(e);
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await datasource.delete(id);
    } on DioException catch (e) {
      _rethrowDio(e);
    }
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    try {
      await datasource.update(expense.id, expense.toJson());
    } on DioException catch (e) {
      _rethrowDio(e);
    }
  }
}
