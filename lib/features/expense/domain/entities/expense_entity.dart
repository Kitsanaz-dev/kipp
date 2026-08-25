// features/expense/domain/entities/expense_entity.dart
class ExpenseEntity {
  final String id;
  final String title;
  final double amount;
  final String category;
  final bool isIncome;
  final String description;
  final DateTime date;

  const ExpenseEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.isIncome,
    required this.description,
    required this.date,
  });
}