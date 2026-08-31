// features/expense/presentation/widgets/transaction_tile.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/utils/category_icon_mapper.dart';
import 'package:kipp/core/utils/currency_formatter.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart'; // ✅ ປ່ຽນ import

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.onTap});

  final ExpenseEntity transaction; // ✅ ປ່ຽນ type
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accentColor = transaction.isIncome ? colors.ok : colors.danger;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.12),
              ),
              child: Icon(
                CategoryIconMapper.iconFor(transaction.category),
                color: accentColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: context.typo.subtitle.copyWith(color: colors.text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.description,
                    style: context.typo.caption.copyWith(color: colors.subtext),
                  ),
                ],
              ),
            ),
            Text(
              '${transaction.isIncome ? '+' : '-'} ${CurrencyFormatter.formatKip(transaction.amount)}',
              style: context.typo.subtitle.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
