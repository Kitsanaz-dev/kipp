// features/expense/presentation/widgets/grouped_transaction_list.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/utils/date_group_formatter.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart';
import 'package:kipp/features/expense/presentation/widgets/data_section_header.dart';
import 'package:kipp/features/expense/presentation/widgets/expense_detail_bottom_sheet.dart';
import 'package:kipp/features/expense/presentation/widgets/transaction_tile.dart';

/// Renders [transactions] as tappable [TransactionTile]s (tapping opens the
/// expense detail sheet). When [byDay] is true they are split into day groups
/// ("Today", "Yesterday", …) each headed by a [DateSectionHeader]; otherwise
/// they are shown as a flat list. Falls back to [emptyText] (or
/// `context.text.noTransactions`) when there is nothing to show.
class GroupedTransactionList extends StatelessWidget {
  const GroupedTransactionList({
    super.key,
    required this.transactions,
    this.byDay = true,
    this.emptyText,
  });

  final List<ExpenseEntity> transactions;
  final bool byDay;
  final String? emptyText;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            emptyText ?? context.text.noTransactions,
            style: context.typo.body.copyWith(color: context.colors.subtext),
          ),
        ),
      );
    }

    if (!byDay) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [for (final tx in transactions) _tile(context, tx)],
      );
    }

    final groups = <String, List<ExpenseEntity>>{};
    for (final tx in transactions) {
      groups.putIfAbsent(DateGroupFormatter.label(tx.date), () => []).add(tx);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in groups.entries) ...[
          DateSectionHeader(label: entry.key),
          for (final tx in entry.value) _tile(context, tx),
        ],
      ],
    );
  }

  Widget _tile(BuildContext context, ExpenseEntity tx) => TransactionTile(
    transaction: tx,
    onTap: () => showExpenseDetailBottomSheet(context, tx),
  );
}
