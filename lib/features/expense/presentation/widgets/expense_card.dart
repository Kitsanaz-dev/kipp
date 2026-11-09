// features/expense/presentation/widgets/expense_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/utils/currency_formatter.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    super.key,
    required this.expense,
    required this.income,
    this.dayType = 0,
    this.onTap,
  });

  final double expense;
  final double income;
  final int dayType; // 0 = Today, 1 = This Week, 2 = This Month

  /// When set, the card gets a ripple, a "See details ›" hint, and calls this.
  final VoidCallback? onTap;
  double get balance => income - expense;

  List<String> _balanceLabels(BuildContext context) => [
    context.text.todaysBalance,
    context.text.thisWeeksBalance,
    context.text.thisMonthsBalance,
  ];

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16.0);

    // Ink (not a Container decoration) paints the card colour on the Material,
    // so the InkWell ripple shows above it; the Material clips it to the radius.
    return Material(
      type: MaterialType.transparency,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        height: 210,
        decoration: BoxDecoration(
          color: context.colors.primary.withValues(alpha: 0.9),
          borderRadius: borderRadius,
        ),
        child: InkWell(
          onTap: onTap == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onTap!();
                },
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                // Align keeps the label left-aligned, as before, inside the
                // AnimatedSwitcher's centred Stack.
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buildBalanceLabel(context),
                ),
              ),
              if (onTap != null) const _SeeDetails(),
            ],
          ),
          const SizedBox(height: 8),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Text(
              CurrencyFormatter.formatKip(balance),
              key: ValueKey('balance-$dayType-$balance'),
              style: context.typo.h1.copyWith(color: context.colors.white),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _SummaryItem(
                icon: Icons.arrow_downward,
                label: context.text.income,
                amount: income,
                iconColor: context.colors.ok,
                iconBackgroundColor: context.colors.white.withValues(
                  alpha: 0.1,
                ),
              ),
              const Spacer(),
              _SummaryItem(
                icon: Icons.arrow_upward,
                label: context.text.expenses,
                amount: -expense,
                iconColor: context.colors.danger,
                iconBackgroundColor: context.colors.white.withValues(
                  alpha: 0.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceLabel(BuildContext context) {
    // ✅ ປ່ຽນ label smooth ຕາມ dayType (0/1/2)
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: Text(
        _balanceLabels(context)[dayType],
        key: ValueKey(dayType), // ✅ ຕ້ອງມີ key ບໍ່ຄືກັນ ຈຶ່ງ trigger animation
        style: context.typo.title.copyWith(color: context.colors.white),
      ),
    );
  }
}

/// Subtle "See details ›" hint shown on tappable cards.
class _SeeDetails extends StatelessWidget {
  const _SeeDetails();

  @override
  Widget build(BuildContext context) {
    final color = context.colors.white.withValues(alpha: 0.8);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.text.seeDetails,
          style: context.typo.caption.copyWith(color: color),
        ),
        Icon(Icons.chevron_right, size: 16, color: color),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.amount,
    this.iconColor,
    this.iconBackgroundColor,
  });

  final IconData icon;
  final String label;
  final double amount;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colors.onPrimary;
    final resolvedIconColor = iconColor ?? onPrimary;
    final resolvedBgColor =
        iconBackgroundColor ?? onPrimary.withValues(alpha: 0.3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  color: resolvedIconColor,
                  size: 28,
                ), // ✅ ຕັດ fontWeight ອອກແລ້ວ
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: Container(
                    height: 30,
                    width: 30,
                    color: resolvedBgColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: context.typo.subtitle.copyWith(
                color: context.colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          CurrencyFormatter.formatKip(amount),
          style: context.typo.title.copyWith(color: context.colors.white),
        ),
      ],
    );
  }
}
