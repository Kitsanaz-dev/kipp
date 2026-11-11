import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/features/expense/presentation/screens/add_expense_detail_screen.dart';

import '../../helpers/pump_app.dart';

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

  testWidgets('validates, picks a category and resets it on type toggle', (
    tester,
  ) async {
    await pumpApp(tester, const AddExpenseDetailScreen());

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter an amount'), findsOneWidget);
    expect(find.text('Please select a type'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, '0');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Amount must be greater than 0'), findsOneWidget);

    // Category sheet lists expense categories by default.
    await tester.tap(find.text('Select Type'));
    await tester.pumpAndSettle();
    expect(find.text('Select Type...'), findsOneWidget); // sheet title
    expect(find.text('Salary'), findsNothing);
    await tester.tap(find.text('Travel'));
    await tester.pumpAndSettle();
    expect(find.text('Travel'), findsOneWidget);
    // The form is not auto-validated: the error clears on the next Save.
    expect(find.text('Please select a type'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Please select a type'), findsNothing);

    // Switching to income clears the chosen category.
    await tester.tap(find.text('Income'));
    await tester.pumpAndSettle();
    expect(find.text('Travel'), findsNothing);
    expect(find.text('Select Type'), findsOneWidget);

    await tester.tap(find.text('Select Type'));
    await tester.pumpAndSettle();
    expect(find.text('Salary'), findsOneWidget);
  });
}
