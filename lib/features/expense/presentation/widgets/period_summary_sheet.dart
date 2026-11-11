// features/expense/presentation/widgets/period_summary_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kipp/core/constant/durations.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/utils/category_icon_mapper.dart';
import 'package:kipp/core/utils/currency_formatter.dart';
import 'package:kipp/features/expense/domain/services/expense_stats.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';
import 'package:kipp/features/expense/presentation/widgets/expense_detail_bottom_sheet.dart';
import 'package:kipp/features/expense/presentation/widgets/total_card.dart';
import 'package:kipp/features/expense/presentation/widgets/transaction_tile.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// Opens a draggable sheet summarising the transactions in [range].
Future<void> showPeriodSummarySheet(
  BuildContext context,
  DateRange range,
  String title,
) {
  return GlassModalSheet.show<void>(
    context: context,
    // Was a DraggableScrollableSheet (initial 0.6, max 0.9): rests at 60%,
    // drags up to the full detent; scrolling the list up first expands it.
    halfSize: 0.6,
    detents: const {GlassSheetDetent.medium, GlassSheetDetent.large},
    builder: (_) =>
        PeriodSummarySheet(range: range, title: title, hostContext: context),
  );
}

class PeriodSummarySheet extends ConsumerWidget {
  const PeriodSummarySheet({
    super.key,
    required this.range,
    required this.title,
    required this.hostContext,
  });

  final DateRange range;
  final String title;

  /// Context that opened the sheet; used to open the expense detail sheet
  /// after this one has been closed.
  final BuildContext hostContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final summary = ref.watch(periodSummaryProvider(range));

    final sheetScroll = ScrollControllerProvider.of(context);

    // The glass sheet draws its own surface and drag indicator; its scroll
    // controller links the list to the sheet drag (expand first, then scroll).
    return Material(
      type: MaterialType.transparency,
      child: ListView(
        controller: sheetScroll?.controller,
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).padding.bottom + 24,
        ),
        children: [
          // ---- Header ----
          Text(
            context.text.periodDetails,
            style: context.typo.caption.copyWith(color: colors.subtext),
          ),
          const SizedBox(height: 2),
          Text(title, style: context.typo.title.copyWith(color: colors.text)),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.formatKip(summary.balance),
            style: context.typo.h2.copyWith(color: colors.text),
          ),
          const SizedBox(height: 2),
          Text(
            context.text.transactionCount(summary.count),
            style: context.typo.bodySmall.copyWith(color: colors.subtext),
          ),
          const SizedBox(height: 20),

          if (summary.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  context.text.noTransactions,
                  style: context.typo.body.copyWith(color: colors.subtext),
                ),
              ),
            )
          else ...[
            // ---- Income / Expense ----
            Row(
              children: [
                Expanded(
                  child: TotalCard(
                    label: context.text.income,
                    amount: summary.income,
                    color: colors.ok,
                    icon: Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TotalCard(
                    label: context.text.expenses,
                    amount: summary.expense,
                    color: colors.danger,
                    icon: Icons.arrow_upward,
                  ),
                ),
              ],
            ),

            // ---- By category ----
            if (summary.byCategory.isNotEmpty) ...[
              const SizedBox(height: 24),
              _SectionTitle(context.text.byCategory),
              const SizedBox(height: 8),
              for (final c in summary.byCategory) _CategoryRow(total: c),
            ],

            // ---- Top expenses ----
            if (summary.topExpenses.isNotEmpty) ...[
              const SizedBox(height: 16),
              _SectionTitle(context.text.topExpenses),
              const SizedBox(height: 4),
              for (final tx in summary.topExpenses)
                TransactionTile(
                  transaction: tx,
                  onTap: () {
                    Navigator.of(context).pop();
                    if (hostContext.mounted) {
                      showExpenseDetailBottomSheet(hostContext, tx);
                    }
                  },
                ),
            ],
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: context.typo.subtitle.copyWith(
      color: context.colors.text,
      fontWeight: FontWeight.w600,
    ),
  );
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.total});

  final CategoryTotal total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final percent = NumberFormat.decimalPercentPattern(
      locale: Localizations.localeOf(context).toLanguageTag(),
      decimalDigits: 0,
    ).format(total.share);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.danger.withValues(alpha: 0.12),
            ),
            child: Icon(
              CategoryIconMapper.iconFor(total.category),
              color: colors.danger,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        total.category,
                        style: context.typo.bodySmall.copyWith(
                          color: colors.text,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.formatKip(total.amount),
                      style: context.typo.bodySmall.copyWith(
                        color: colors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 40,
                      child: Text(
                        percent,
                        textAlign: TextAlign.end,
                        style: context.typo.caption.copyWith(
                          color: colors.subtext,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: Container(
                    height: 6,
                    color: colors.inactiveContainer,
                    alignment: Alignment.centerLeft,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: total.share),
                      duration: AppDurations.slow,
                      curve: Curves.easeOutCubic,
                      builder: (_, value, _) => FractionallySizedBox(
                        widthFactor: value.clamp(0.0, 1.0),
                        heightFactor: 1,
                        child: ColoredBox(
                          color: colors.danger.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
