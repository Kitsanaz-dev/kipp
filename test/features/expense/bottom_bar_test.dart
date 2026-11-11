import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/features/expense/presentation/widgets/bottom_bar.dart';

import '../../helpers/pump_app.dart';

void main() {
  // Tests run as Android, so BottomBar shows its glass fallback tab bar.
  testWidgets('fallback tab bar shows the four tabs and reports taps', (
    tester,
  ) async {
    int? tapped;
    await pumpApp(tester, BottomBar(currentIndex: 0, onTap: (i) => tapped = i));

    // The glass bar paints labels in two layers (resting + under the
    // indicator lens), so each label can appear more than once.
    for (final label in ['Home', 'Expenses', 'History', 'Profile']) {
      expect(find.text(label), findsWidgets);
    }
    expect(find.bySemanticsLabel('Add Transaction'), findsOneWidget);

    await tester.tap(find.text('History').first);
    await tester.pumpAndSettle();
    expect(tapped, 2);
  });
}
