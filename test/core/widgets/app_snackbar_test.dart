import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/core/widgets/app_snackbar.dart';

import '../../helpers/pump_app.dart';

void main() {
  Widget trigger(void Function(BuildContext) show) => Builder(
    builder: (context) =>
        TextButton(onPressed: () => show(context), child: const Text('go')),
  );

  testWidgets('showError shows the message with the error icon', (
    tester,
  ) async {
    await pumpApp(
      tester,
      trigger((c) => AppSnackbar.showError(c, 'Network is down')),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    expect(find.text('Network is down'), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.xmark_circle_fill), findsOneWidget);

    await tester.pump(AppSnackbar.displayDuration);
    await tester.pumpAndSettle();
    expect(find.text('Network is down'), findsNothing);
  });

  testWidgets('a new toast replaces the one on screen', (tester) async {
    var n = 0;
    await pumpApp(
      tester,
      trigger((c) => AppSnackbar.showSuccess(c, 'Saved ${++n}')),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    expect(find.text('Saved 1'), findsNothing);
    expect(find.text('Saved 2'), findsOneWidget);
    expect(
      find.byIcon(CupertinoIcons.check_mark_circled_solid),
      findsOneWidget,
    );

    await tester.pump(AppSnackbar.displayDuration);
    await tester.pumpAndSettle();
  });
}
