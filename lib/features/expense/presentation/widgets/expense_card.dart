// features/expense/presentation/widgets/expense_card.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/theme/app_theme.dart';
import 'package:kipp/core/utils/currency_formatter.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    super.key,
    required this.expense,
    required this.income,
    this.dayType = 0,
  });

  final double expense;
  final double income;
  final int dayType; // 0 = Today, 1 = This Week, 2 = This Month
  double get balance => income - expense;

  static const _balanceLabels = [
    "Today's balance",
    "This week's balance",
    "This month's balance",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ ປ່ຽນ label smooth ຕາມ dayType (0/1/2)
            AnimatedSwitcher(
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
                _balanceLabels[dayType],
                key: ValueKey(dayType), // ✅ ຕ້ອງມີ key ບໍ່ຄືກັນ ຈຶ່ງ trigger animation
                style: context.typo.title.copyWith(color: context.colors.onPrimary),
              ),
            ),
            const SizedBox(height: 8),

            // TODO: balance ນີ້ຄິດໄລ່ຈາກ expense/income ທີ່ Home screen ສົ່ງມາ
            // ຕອນຕໍ່ data ຈິງ, expense/income ຕ້ອງ filter ຕາມ dayType ກ່ອນສົ່ງເຂົ້າມາ
            // (ເບິ່ງ TODO ໃນ home_screen.dart)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Text(
                CurrencyFormatter.formatKip(balance),
                key: ValueKey('balance-$dayType-$balance'),
                style: context.typo.h1.copyWith(color: context.colors.onPrimary),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                _SummaryItem(
                  icon: Icons.arrow_downward,
                  label: 'Income',
                  amount: income,
                  iconColor: context.colors.ok,
                  iconBackgroundColor: context.colors.onPrimary.withValues(alpha: 0.5),
                ),
                const Spacer(),
                _SummaryItem(
                  icon: Icons.arrow_upward,
                  label: 'Expenses',
                  amount: -expense,
                  iconColor: context.colors.danger,
                  iconBackgroundColor: context.colors.onPrimary.withValues(alpha: 0.5),
                ),
              ],
            ),
          ],
        ),
      ),
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
    final resolvedBgColor = iconBackgroundColor ?? onPrimary.withValues(alpha: 0.3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, color: resolvedIconColor, size: 28), // ✅ ຕັດ fontWeight ອອກແລ້ວ
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
            Text(label, style: context.typo.subtitle.copyWith(color: onPrimary)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          CurrencyFormatter.formatKip(amount),
          style: context.typo.title.copyWith(color: onPrimary),
        ),
      ],
    );
  }
}