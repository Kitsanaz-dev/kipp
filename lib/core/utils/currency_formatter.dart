// core/utils/currency_formatter.dart
import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _formatter = NumberFormat('#,##0.00', 'en_US');

  /// 300000    → "300,000.00"
  /// 1234567.5 → "1,234,567.50"
  static String format(double value) => _formatter.format(value);

  /// ພ້ອມສັນຍາລັກເງິນກີບ: "₭ 300,000.00"
  static String formatKip(double value) => '₭ ${_formatter.format(value)}';

  static String compact(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
    return value.toStringAsFixed(0);
  }
}
