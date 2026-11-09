import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';
import 'package:kipp/features/expense/presentation/widgets/expense_card.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('non-tappable card shows no details hint', (tester) async {
    await pumpApp(tester, const ExpenseCard(expense: 10, income: 30));
    expect(find.text('See details'), findsNothing);
    expect(find.text("Today's balance"), findsOneWidget);
    expect(find.text('₭ 20.00'), findsOneWidget);
  });

  testWidgets('tappable card shows the hint and calls onTap', (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      ExpenseCard(
        expense: 10,
        income: 30,
        period: PeriodFilter.thisMonth,
        onTap: () => taps++,
      ),
    );
    expect(find.text('See details'), findsOneWidget);
    expect(find.text("This month's balance"), findsOneWidget);

    await tester.tap(find.byType(ExpenseCard));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });
}
