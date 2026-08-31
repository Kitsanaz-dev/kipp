// features/expense/presentation/widgets/expense_detail_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/widgets/app_snackbar.dart';
import 'package:kipp/core/utils/currency_formatter.dart';
import 'package:kipp/core/utils/category_icon_mapper.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';

Future<void> showExpenseDetailBottomSheet(
  BuildContext context,
  ExpenseEntity expense,
) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => ExpenseDetailBottomSheet(expense: expense),
  );
}

class ExpenseDetailBottomSheet extends ConsumerWidget {
  const ExpenseDetailBottomSheet({super.key, required this.expense});

  final ExpenseEntity expense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final accentColor = expense.isIncome ? colors.ok : colors.danger;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---- Drag handle ----
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: colors.inactiveContainer,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ---- ຫົວຂໍ້ + icon ----
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.12),
                ),
                child: Icon(
                  CategoryIconMapper.iconFor(expense.category),
                  color: accentColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: context.typo.title.copyWith(color: colors.text),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      expense.category,
                      style: context.typo.bodySmall.copyWith(
                        color: colors.subtext,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ---- ຈຳນວນເງິນ (ໂດດເດັ່ນ) ----
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: AppRadius.lgAll,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.isIncome
                      ? context.text.income
                      : context.text.expenses,
                  style: context.typo.caption.copyWith(color: colors.subtext),
                ),
                const SizedBox(height: 4),
                Text(
                  '${expense.isIncome ? '+' : '-'} ${CurrencyFormatter.formatKip(expense.amount)}',
                  style: context.typo.h2.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ---- ລາຍລະອຽດ ----
          _DetailRow(
            label: context.text.description,
            value: expense.description.isEmpty ? '-' : expense.description,
          ),
          const SizedBox(height: 12),
          _DetailRow(label: 'Date', value: _formatDate(expense.date)),
          const SizedBox(height: 24),

          // ---- ປຸ່ມ Delete ----
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                await ref.read(expenseListProvider.notifier).delete(expense.id);
                if (context.mounted) {
                  AppSnackbar.showSuccess(context, context.text.deleteSuccess);
                  Navigator.pop(context);
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.danger),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: colors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '${date.day}/${date.month}/${date.year}  $h:$m';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.typo.bodySmall.copyWith(color: context.colors.subtext),
        ),
        Flexible(
          child: Text(
            value,
            style: context.typo.bodySmall.copyWith(color: context.colors.text),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
