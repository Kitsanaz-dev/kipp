// features/expense/data/models/expense_model.dart
import 'package:hive_ce/hive.dart';
import '../../domain/entities/expense_entity.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 2) // typeId: 1 ໃຊ້ໂດຍ UserModel ໄປແລ້ວ (ຖ້າມີ)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final bool isIncome;
  @HiveField(5)
  final String description;
  @HiveField(6)
  final DateTime date;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.isIncome,
    required this.description,
    required this.date,
  });

  ExpenseEntity toEntity() => ExpenseEntity(
        id: id,
        title: title,
        amount: amount,
        category: category,
        isIncome: isIncome,
        description: description,
        date: date,
      );

  factory ExpenseModel.fromEntity(ExpenseEntity e) => ExpenseModel(
        id: e.id,
        title: e.title,
        amount: e.amount,
        category: e.category,
        isIncome: e.isIncome,
        description: e.description,
        date: e.date,
      );
}