// features/expense/data/datasources/expense_local_datasource.dart
import 'package:hive/hive.dart';
import '../models/expense_model.dart';

class ExpenseLocalDatasource {
  static const _boxName = 'expenses_box';

  Future<Box<ExpenseModel>> _openBox() => Hive.openBox<ExpenseModel>(_boxName);

  Future<List<ExpenseModel>> getAll() async {
    final box = await _openBox();
    return box.values.toList()..sort((a, b) => b.date.compareTo(a.date)); // ໃໝ່ສຸດຢູ່ເທິງ
  }

  Future<void> add(ExpenseModel model) async {
    final box = await _openBox();
    await box.put(model.id, model);
  }

  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> update(ExpenseModel model) async {
    final box = await _openBox();
    await box.put(model.id, model); // put ດ້ວຍ key ດຽວກັນ = update
  }
}