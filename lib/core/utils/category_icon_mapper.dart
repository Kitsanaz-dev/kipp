// core/utils/category_icon_mapper.dart
import 'package:flutter/material.dart';

class CategoryIconMapper {
  CategoryIconMapper._();

  static IconData iconFor(String category) {
    switch (category) {
      case 'Shopping': return Icons.shopping_bag_outlined;
      case 'Food': return Icons.local_cafe_outlined;
      case 'Travel': return Icons.flight_outlined;
      case 'Salary': return Icons.work_outline;
      case 'Electric/Water bills': return Icons.bolt_outlined;
      default: return Icons.receipt_long_outlined;
    }
  }
}