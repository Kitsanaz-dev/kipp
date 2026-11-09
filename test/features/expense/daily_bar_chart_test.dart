import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/features/expense/domain/services/expense_stats.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';
import 'package:kipp/features/expense/presentation/widgets/daily_bar_chart.dart';

import '../../helpers/pump_app.dart';

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(400, 800);
    view.devicePixelRatio = 1;
  });
  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  Future<void> pumpMonth(WidgetTester tester, DateTime month) => pumpApp(
    tester,
    DailyBarChart(
      data: ExpenseStats.dailyTotals(const [], DateRange.month(month)),
    ),
  );

  testWidgets('30-day month labels every 5th day', (tester) async {
    await pumpMonth(tester, DateTime(2026, 11));
    for (final day in [1, 6, 11, 16, 21, 26]) {
      expect(find.text('$day'), findsOneWidget, reason: 'day $day');
    }
    for (final day in [2, 5, 10, 30]) {
      expect(find.text('$day'), findsNothing, reason: 'day $day');
    }
  });

  testWidgets('31-day month labels every 6th day', (tester) async {
    await pumpMonth(tester, DateTime(2026, 12));
    // 25 is skipped: it collides with a y-axis label.
    for (final day in [1, 7, 13, 19, 31]) {
      expect(find.text('$day'), findsOneWidget, reason: 'day $day');
    }
    expect(find.text('6'), findsNothing);
  });

  testWidgets('year buckets use month labels, every 2nd by default', (
    tester,
  ) async {
    await pumpApp(
      tester,
      DailyBarChart(
        data: ExpenseStats.chartTotals(
          const [],
          DateRange.year(DateTime(2026)),
        ),
        labelOf: (d) => 'M${d.month}',
      ),
    );
    for (final m in [1, 3, 5, 7, 9, 11]) {
      expect(find.text('M$m'), findsOneWidget);
    }
    expect(find.text('M2'), findsNothing);
  });

  testWidgets('labelEvery: 1 shows every week day', (tester) async {
    await pumpApp(
      tester,
      DailyBarChart(
        data: ExpenseStats.chartTotals(
          const [],
          DateRange.week(DateTime(2026, 11, 12)),
        ),
        labelOf: (d) => 'D${d.day}',
        labelEvery: 1,
      ),
    );
    for (var d = 9; d <= 15; d++) {
      expect(find.text('D$d'), findsOneWidget);
    }
  });
}
