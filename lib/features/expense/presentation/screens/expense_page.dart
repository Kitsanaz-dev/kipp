// // features/expense/presentation/screens/expense_page.dart
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:kipp/core/constant/radius.dart';
// import 'package:kipp/core/theme/app_theme.dart';
// import 'package:kipp/core/utils/currency_formatter.dart';
// import 'package:kipp/core/utils/date_group_formatter.dart';

// import 'package:kipp/features/expense/presentation/widgets/data_section_header.dart';
// import 'package:kipp/features/expense/presentation/widgets/transaction_tile.dart';

// class ExpensePage extends StatefulWidget {
//   const ExpensePage({super.key});

//   @override
//   State<ExpensePage> createState() => _ExpensePageState();
// }

// class _ExpensePageState extends State<ExpensePage> {
//   bool _showIncome = false; // false = ສະແດງ Expense ໂດຍ default

//   @override
//   Widget build(BuildContext context) {
//     final colors = context.colors;

//     // TODO: ປ່ຽນເປັນ ref.watch(transactionsByTypeProvider(_showIncome)) ຕອນຕໍ່ data ຈິງ
//     final filtered = mockTransactions.where((t) => t.isIncome == _showIncome).toList();

//     // TODO: ຄິດໄລ່ຈາກ transaction ຈິງ ບໍ່ແມ່ນ hardcode
//     const totalIncome = 6000000.0;
//     const totalExpense = 125000.0;

//     return SafeArea(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildChart(context),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: _TotalCard(
//                     label: 'Total Income',
//                     amount: totalIncome,
//                     color: colors.ok,
//                     icon: Icons.arrow_downward,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _TotalCard(
//                     label: 'Total Expense',
//                     amount: totalExpense,
//                     color: colors.danger,
//                     icon: Icons.arrow_upward,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             _buildToggle(context),
//             const SizedBox(height: 12),
//             if (filtered.isEmpty)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 32),
//                 child: Center(
//                   child: Text(
//                     'ຍັງບໍ່ມີລາຍການ',
//                     style: context.typo.body.copyWith(color: colors.subtext),
//                   ),
//                 ),
//               )
//             else
//               ..._buildGroupedList(context, filtered),
//           ],
//         ),
//       ),
//     );
//   }

//   // ---- Bar chart: income (ຂຽວ) vs expense (ແດງ) ລາຍວັນ ----
//   Widget _buildChart(BuildContext context) {
//     final colors = context.colors;
//     final maxY = mockChartData
//         .map((d) => d.income > d.expense ? d.income : d.expense)
//         .fold(0.0, (a, b) => a > b ? a : b);

//     return Container(
//       height: 220,
//       padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
//       decoration: BoxDecoration(
//         color: colors.surface,
//         borderRadius: AppRadius.lgAll,
//         border: Border.all(color: colors.inactiveContainer),
//       ),
//       child: BarChart(
//         BarChartData(
//           maxY: maxY * 1.2,
//           gridData: FlGridData(
//             drawVerticalLine: false,
//             horizontalInterval: maxY / 4,
//             getDrawingHorizontalLine: (value) => FlLine(
//               color: colors.inactiveContainer,
//               strokeWidth: 1,
//             ),
//           ),
//           borderData: FlBorderData(show: false),
//           titlesData: FlTitlesData(
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 44,
//                 interval: maxY / 4,
//                 getTitlesWidget: (value, meta) => Text(
//                   CurrencyFormatter.compact(value),
//                   style: context.typo.caption.copyWith(color: colors.subtext),
//                 ),
//               ),
//             ),
//             rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 interval: 3,
//                 getTitlesWidget: (value, meta) {
//                   final index = value.toInt();
//                   if (index < 0 || index >= mockChartData.length) return const SizedBox();
//                   final date = mockChartData[index].date;
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 6),
//                     child: Text(
//                       '${date.day}',
//                       style: context.typo.caption.copyWith(color: colors.subtext),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           barGroups: List.generate(mockChartData.length, (i) {
//             final d = mockChartData[i];
//             return BarChartGroupData(
//               x: i,
//               barRods: [
//                 BarChartRodData(
//                   toY: d.income,
//                   color: colors.ok,
//                   width: 4,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//                 BarChartRodData(
//                   toY: d.expense,
//                   color: colors.danger,
//                   width: 4,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ],
//               barsSpace: 3,
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   // ---- Toggle Income/Expense ----
//   Widget _buildToggle(BuildContext context) {
//     final colors = context.colors;

//     return SegmentedButton<bool>(
//       style: ButtonStyle(
//         backgroundColor: WidgetStateProperty.resolveWith((states) {
//           if (!states.contains(WidgetState.selected)) return Colors.transparent;
//           return _showIncome ? colors.ok : colors.danger;
//         }),
//         foregroundColor: WidgetStateProperty.resolveWith((states) {
//           return states.contains(WidgetState.selected) ? colors.onPrimary : colors.text;
//         }),
//         elevation: const WidgetStatePropertyAll(0),
//       ),
//       segments: const [
//         ButtonSegment(value: true, label: Text('Income')),
//         ButtonSegment(value: false, label: Text('Expense')),
//       ],
//       selected: {_showIncome},
//       onSelectionChanged: (newSelection) {
//         setState(() => _showIncome = newSelection.first);
//       },
//     );
//   }

//   // ---- ຈັດກຸ່ມ list ຕາມວັນ (ໃຊ້ helper ດຽວກັບ HomeScreen) ----
//   List<Widget> _buildGroupedList(BuildContext context, List<TransactionUiModel> list) {
//     final Map<String, List<TransactionUiModel>> grouped = {};
//     for (final tx in list) {
//       grouped.putIfAbsent(DateGroupFormatter.label(tx.date), () => []).add(tx);
//     }

//     final widgets = <Widget>[];
//     grouped.forEach((label, txList) {
//       widgets.add(DateSectionHeader(label: label));
//       widgets.addAll(txList.map((tx) => TransactionTile(transaction: tx)));
//     });
//     return widgets;
//   }
// }

// class _TotalCard extends StatelessWidget {
//   const _TotalCard({
//     required this.label,
//     required this.amount,
//     required this.color,
//     required this.icon,
//   });

//   final String label;
//   final double amount;
//   final Color color;
//   final IconData icon;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.1),
//         borderRadius: AppRadius.lgAll,
//         border: Border.all(color: color.withValues(alpha: 0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: color, size: 16),
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: context.typo.caption.copyWith(
//                   color: color,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             CurrencyFormatter.formatKip(amount),
//             style: context.typo.title.copyWith(color: context.colors.text),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Expense Page'),
      ),
    );
  }
}