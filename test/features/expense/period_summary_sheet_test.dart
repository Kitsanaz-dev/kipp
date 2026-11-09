import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';
import 'package:kipp/features/expense/presentation/widgets/expense_detail_bottom_sheet.dart';
import 'package:kipp/features/expense/presentation/widgets/period_summary_sheet.dart';

import '../../helpers/pump_app.dart';
import 'expense_test_helpers.dart';

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(400, 1600);
    view.devicePixelRatio = 1;
  });
  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  final nov = DateRange.month(DateTime(2026, 11));

  Widget opener() => Builder(
    builder: (context) => TextButton(
      onPressed: () => showPeriodSummarySheet(context, nov, 'November'),
      child: const Text('open'),
    ),
  );

  testWidgets('shows totals, categories and top expenses', (tester) async {
    await pumpApp(
      tester,
      opener(),
      items: [
        tx('a', DateTime(2026, 11, 3), 300, income: true, category: 'Salary'),
        tx('b', DateTime(2026, 11, 4), 75, category: 'Food'),
        tx('c', DateTime(2026, 11, 5), 25, category: 'Travel'),
        tx('old', DateTime(2026, 10, 5), 999, category: 'Shopping'),
      ],
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('November'), findsOneWidget);
    expect(find.text('3 transactions'), findsOneWidget);
    expect(find.text('₭ 200.00'), findsOneWidget); // balance
    expect(find.text('By category'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('25%'), findsOneWidget);
    expect(find.text('Shopping'), findsNothing);
    expect(find.text('Top expenses'), findsOneWidget);
  });

  testWidgets('tapping a top expense swaps to the detail sheet', (
    tester,
  ) async {
    await pumpApp(
      tester,
      opener(),
      items: [tx('b', DateTime(2026, 11, 4), 75, category: 'Food')],
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('- ₭ 75.00'));
    await tester.pumpAndSettle();

    expect(find.byType(PeriodSummarySheet), findsNothing);
    expect(find.byType(ExpenseDetailBottomSheet), findsOneWidget);
  });

  testWidgets('empty range shows the empty state', (tester) async {
    await pumpApp(tester, opener());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('No transactions yet'), findsOneWidget);
    expect(find.text('By category'), findsNothing);
  });
}
