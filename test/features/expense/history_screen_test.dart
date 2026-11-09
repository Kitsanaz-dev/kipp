import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:kipp/features/expense/presentation/screens/history_screen.dart';

import '../../helpers/pump_app.dart';
import 'expense_test_helpers.dart';

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(700, 1600);
    view.devicePixelRatio = 1;
  });
  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  final now = DateTime.now();
  String title(DateTime m) => DateFormat.yMMMM('en').format(m);

  testWidgets('draws a green and a red marker per day as needed', (
    tester,
  ) async {
    // Two distinct days in the current month (1st and 2nd, or today if the
    // month is young — any two days work as long as they differ).
    final d1 = DateTime(now.year, now.month, 1, 9);
    final d2 = DateTime(now.year, now.month, 2, 9);
    await pumpApp(
      tester,
      const HistoryScreen(),
      items: [
        tx('i1', d1, 10, income: true),
        tx('e1', d1, 5),
        tx('e2', d2, 5),
        tx('e3', d2, 6),
      ],
    );

    expect(find.byKey(const ValueKey('income-marker')), findsOneWidget);
    expect(find.byKey(const ValueKey('expense-marker')), findsNWidgets(2));
  });

  testWidgets('jump-to-today appears off the current month and resets', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const HistoryScreen(),
      // Data a year back so the calendar allows going to previous months.
      items: [tx('old', DateTime(now.year - 1, 1, 1), 1)],
    );
    final thisMonth = DateTime(now.year, now.month);
    expect(find.text(title(thisMonth)), findsOneWidget);
    expect(find.text('Today'), findsWidgets); // date label
    final todayButtons = find.widgetWithText(TextButton, 'Today');
    expect(todayButtons, findsNothing);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(find.text(title(DateTime(now.year, now.month - 1))), findsOneWidget);
    expect(todayButtons, findsOneWidget);

    await tester.tap(todayButtons);
    await tester.pumpAndSettle();
    expect(find.text(title(thisMonth)), findsOneWidget);
    expect(todayButtons, findsNothing);
  });

  testWidgets('tapping the header title opens the month picker', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const HistoryScreen(),
      items: [tx('old', DateTime(now.year - 1, 3, 1), 1)],
    );

    await tester.tap(find.text(title(DateTime(now.year, now.month))));
    await tester.pumpAndSettle();
    expect(find.text('Select month'), findsOneWidget);

    await tester.tap(find.text('${now.year - 1}'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mar'));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(find.text(title(DateTime(now.year - 1, 3))), findsOneWidget);
  });

  testWidgets('shows income and expense totals for the selected day', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const HistoryScreen(),
      items: [
        tx('i', now, 120, income: true),
        tx('e1', now, 30),
        tx('e2', now, 15),
        tx('other', now.subtract(const Duration(days: 40)), 999),
      ],
    );

    expect(find.text('Day income'), findsOneWidget);
    expect(find.text('Day expense'), findsOneWidget);
    expect(find.text('₭ 120.00'), findsOneWidget);
    expect(find.text('₭ 45.00'), findsOneWidget);
  });
}
