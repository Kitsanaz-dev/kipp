import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:kipp/features/expense/presentation/screens/expense_screen.dart';
import 'package:kipp/features/expense/presentation/widgets/daily_bar_chart.dart';

import '../../helpers/pump_app.dart';
import 'expense_test_helpers.dart';

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(700, 1400);
    view.devicePixelRatio = 1;
  });
  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  final now = DateTime.now();
  final thisMonth = DateTime(now.year, now.month);
  final lastMonth = DateTime(now.year, now.month - 1);
  String title(DateTime m) => DateFormat.yMMMM('en').format(m);

  final items = [
    tx('cur-exp', DateTime(now.year, now.month, 1, 9), 40, category: 'Food'),
    tx('cur-inc', DateTime(now.year, now.month, 1, 10), 100, income: true),
    tx('old-exp', DateTime(now.year, now.month - 1, 3), 7, category: 'Travel'),
  ];

  testWidgets('binds totals, net balance and list to the current month', (
    tester,
  ) async {
    await pumpApp(tester, const ExpenseScreen(), items: items);

    expect(find.text(title(thisMonth)), findsOneWidget);
    expect(find.text('Net balance'), findsOneWidget);
    expect(find.text('₭ 60.00'), findsOneWidget); // net balance
    expect(find.text('- ₭ 40.00'), findsOneWidget); // expense tab default
    expect(find.text('- ₭ 7.00'), findsNothing);
  });

  testWidgets('previous month via chevron', (tester) async {
    await pumpApp(tester, const ExpenseScreen(), items: items);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();

    expect(find.text(title(lastMonth)), findsOneWidget);
    expect(find.text('- ₭ 7.00'), findsOneWidget);
    expect(find.text('- ₭ 40.00'), findsNothing);
  });

  testWidgets('swiping the chart changes month within bounds', (tester) async {
    await pumpApp(tester, const ExpenseScreen(), items: items);
    final chart = find.byType(DailyBarChart);

    // Already on the current month: swiping left (to the future) is a no-op.
    await tester.fling(chart, const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text(title(thisMonth)), findsOneWidget);

    // Swipe right → previous month (the earliest one with data).
    await tester.fling(chart, const Offset(300, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text(title(lastMonth)), findsOneWidget);

    // Earliest month reached: another right swipe stays put.
    await tester.fling(chart, const Offset(300, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text(title(lastMonth)), findsOneWidget);

    // A slow drag does not change month.
    await tester.drag(chart, const Offset(-60, 0));
    await tester.pumpAndSettle();
    expect(find.text(title(lastMonth)), findsOneWidget);

    await tester.fling(chart, const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text(title(thisMonth)), findsOneWidget);
  });
}
