import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';
import 'package:kipp/features/expense/presentation/widgets/month_switcher.dart';

import '../../helpers/pump_app.dart';

/// Hosts a MonthSwitcher with its own month state.
class _Host extends StatefulWidget {
  const _Host({required this.initial, required this.first, required this.last});

  final DateRange initial;
  final DateTime first;
  final DateTime last;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late DateRange month = widget.initial;

  @override
  Widget build(BuildContext context) => MonthSwitcher(
    month: month,
    first: widget.first,
    last: widget.last,
    onChanged: (m) => setState(() => month = m),
  );
}

IconButton _button(WidgetTester tester, IconData icon) => tester.widget(
  find.ancestor(of: find.byIcon(icon), matching: find.byType(IconButton)),
);

void main() {
  testWidgets('chevrons step months and respect bounds', (tester) async {
    await pumpApp(
      tester,
      _Host(
        initial: DateRange.month(DateTime(2026, 11)),
        first: DateTime(2026, 9, 15),
        last: DateTime(2026, 11, 9),
      ),
    );

    expect(find.text('November 2026'), findsOneWidget);
    expect(_button(tester, Icons.chevron_right).onPressed, isNull);
    expect(_button(tester, Icons.chevron_left).onPressed, isNotNull);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(find.text('October 2026'), findsOneWidget);
    expect(_button(tester, Icons.chevron_right).onPressed, isNotNull);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(find.text('September 2026'), findsOneWidget);
    expect(_button(tester, Icons.chevron_left).onPressed, isNull);
  });

  testWidgets('title opens the picker and applies the chosen month', (
    tester,
  ) async {
    await pumpApp(
      tester,
      _Host(
        initial: DateRange.month(DateTime(2026, 11)),
        first: DateTime(2026, 1),
        last: DateTime(2026, 11),
      ),
    );

    await tester.tap(find.text('November 2026'));
    await tester.pumpAndSettle();
    expect(find.text('Select month'), findsOneWidget);

    await tester.tap(find.text('Mar'));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
    expect(find.text('March 2026'), findsOneWidget);
  });
}
