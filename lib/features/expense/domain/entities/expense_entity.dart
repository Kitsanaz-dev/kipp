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

  /// map JSON shape ຈາກ backend (snake_case) ເປັນ entity.
  factory ExpenseEntity.fromJson(Map<String, dynamic> json) => ExpenseEntity(
        id: json['id'].toString(),
        title: (json['title'] ?? '') as String,
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
        category: (json['category'] ?? '') as String,
        isIncome: (json['is_income'] as bool?) ?? false,
        description: (json['description'] ?? '') as String,
        date: DateTime.parse(json['date'] as String).toLocal(),
      );

  /// body ສຳລັບ POST/PATCH - camelCase -> snake_case. ບໍ່ສົ່ງ id (backend ຈັດການ).
  Map<String, dynamic> toJson() => {
        'title': title,
        'amount': amount,
        'category': category,
        'is_income': isIncome,
        'description': description,
        'date': date.toUtc().toIso8601String(),
      };
}
