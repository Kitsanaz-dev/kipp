// features/expense/presentation/models/transaction_ui_model.dart
import 'package:flutter/material.dart';

/// Model ຊົ່ວຄາວສຳລັບ mock UI - ຈະປ່ຽນເປັນ ExpenseEntity ຈິງພາຍຫຼັງ
class TransactionUiModel {
  final String title;
  final String category;
  final double amount;
  final bool isIncome;
  final IconData icon;
  final DateTime date;

  const TransactionUiModel({
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.icon,
    required this.date,
  });
}

// TODO: ລົບ mock data ນີ້ອອກຕອນຕໍ່ homeSummaryProvider ຈິງ
final mockTransactions = [
  TransactionUiModel(
    title: 'Shopping',
    category: 'Shopping',
    amount: 100000,
    isIncome: false,
    icon: Icons.shopping_bag_outlined,
    date: DateTime.now(),
  ),
  TransactionUiModel(
    title: 'Salary',
    category: 'Salary',
    amount: 6000000,
    isIncome: true,
    icon: Icons.work_outline,
    date: DateTime.now(),
  ),
  TransactionUiModel(
    title: 'Coffee',
    category: 'Food',
    amount: 25000,
    isIncome: false,
    icon: Icons.local_cafe_outlined,
    date: DateTime.now().subtract(const Duration(days: 1)),
  ),
];

// TODO: ລົບ mock ນີ້ອອກຕອນຕໍ່ data ຈິງ
final mockMonthTransactions = List.generate(10, (i) {
  final now = DateTime.now();
  final day = now.subtract(Duration(days: i * 2));
  return TransactionUiModel(
    title: i.isEven ? 'Shopping' : 'Coffee',
    category: i.isEven ? 'Shopping' : 'Food',
    amount: i.isEven ? 100000.0 : 25000.0,
    isIncome: i == 4, // ໃສ່ income 1 ລາຍການປົນ
    icon: i.isEven ? Icons.shopping_bag_outlined : Icons.local_cafe_outlined,
    date: day,
  );
});