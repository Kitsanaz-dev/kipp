import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';
import 'package:kipp/features/expense/presentation/widgets/period_switcher.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../helpers/pump_app.dart';

/// Hosts a PeriodSwitcher with its own range state.
class _Host extends StatefulWidget {
  const _Host({
    required this.unit,
    required this.initial,
    required this.first,
    required this.last,
  });

  final PeriodUnit unit;
  final DateTime initial;
  final DateTime first;
  final DateTime last;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late DateRange range = widget.unit.rangeOf(widget.initial);

  @override
  Widget build(BuildContext context) => PeriodSwitcher(
    unit: widget.unit,
    range: range,
    first: widget.first,
    last: widget.last,
    onChanged: (r) => setState(() => range = r),
  );
}

/// The prev/next button, found by its tooltip ('Previous page' / 'Next page').
GlassIconButton _button(WidgetTester tester, IconData icon) => tester.widget(
  find.descendant(
    of: find.byTooltip(
      icon == Icons.chevron_left ? 'Previous page' : 'Next page',
    ),
    matching: find.byType(GlassIconButton),
  ),
);

Future<void> _tapChevron(WidgetTester tester, IconData icon) async {
  await tester.tap(find.byIcon(icon));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(700, 1200);
    view.devicePixelRatio = 1;
  });
  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  testWidgets('month: chevrons step months and respect bounds', (tester) async {
    await pumpApp(
      tester,
      _Host(
        unit: PeriodUnit.month,
        initial: DateTime(2026, 11),
        first: DateTime(2026, 9, 15),
        last: DateTime(2026, 11, 9),
      ),
    );

    expect(find.text('November 2026'), findsOneWidget);
    expect(_button(tester, Icons.chevron_right).onPressed, isNull);

    await _tapChevron(tester, Icons.chevron_left);
    await _tapChevron(tester, Icons.chevron_left);
    expect(find.text('September 2026'), findsOneWidget);
    expect(_button(tester, Icons.chevron_left).onPressed, isNull);
  });

  testWidgets('day: title shows the weekday and steps by one day', (
    tester,
  ) async {
    await pumpApp(
      tester,
      _Host(
        unit: PeriodUnit.day,
        initial: DateTime(2026, 11, 9),
        first: DateTime(2026, 11, 8),
        last: DateTime(2026, 11, 9, 14),
      ),
    );

    expect(find.text('Mon, Nov 9, 2026'), findsOneWidget);
    expect(_button(tester, Icons.chevron_right).onPressed, isNull);

    await _tapChevron(tester, Icons.chevron_left);
    expect(find.text('Sun, Nov 8, 2026'), findsOneWidget);
    expect(_button(tester, Icons.chevron_left).onPressed, isNull);
  });

  testWidgets('week: title spans Monday to Sunday', (tester) async {
    await pumpApp(
      tester,
      _Host(
        unit: PeriodUnit.week,
        initial: DateTime(2026, 11, 12),
        first: DateTime(2026, 1),
        last: DateTime(2026, 11, 12),
      ),
    );

    expect(find.text('Nov 9 – Nov 15, 2026'), findsOneWidget);
    await _tapChevron(tester, Icons.chevron_left);
    expect(find.text('Nov 2 – Nov 8, 2026'), findsOneWidget);
  });

  testWidgets('year: steps years and opens the year picker', (tester) async {
    await pumpApp(
      tester,
      _Host(
        unit: PeriodUnit.year,
        initial: DateTime(2026, 11),
        first: DateTime(2024, 3),
        last: DateTime(2026, 11, 9),
      ),
    );

    expect(find.text('2026'), findsOneWidget);
    await _tapChevron(tester, Icons.chevron_left);
    expect(find.text('2025'), findsOneWidget);

    await tester.tap(find.text('2025'));
    await tester.pumpAndSettle();
    expect(find.text('Select year'), findsOneWidget);
    await tester.tap(find.text('2024'));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
    expect(find.text('Select year'), findsNothing);
    expect(find.text('2024'), findsOneWidget);
    expect(_button(tester, Icons.chevron_left).onPressed, isNull);
  });

  testWidgets('month: title opens the month picker', (tester) async {
    await pumpApp(
      tester,
      _Host(
        unit: PeriodUnit.month,
        initial: DateTime(2026, 11),
        first: DateTime(2026, 1),
        last: DateTime(2026, 11),
      ),
    );

    await tester.tap(find.text('November 2026'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mar'));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
    expect(find.text('March 2026'), findsOneWidget);
  });

  testWidgets('next is disabled at the current period and enables after '
      'stepping back', (tester) async {
    final now = DateTime(2026, 11, 9);
    await pumpApp(
      tester,
      _Host(
        unit: PeriodUnit.week,
        initial: now,
        first: DateTime(2026, 1),
        last: now,
      ),
    );

    expect(_button(tester, Icons.chevron_right).onPressed, isNull);
    expect(_button(tester, Icons.chevron_left).onPressed, isNotNull);

    await _tapChevron(tester, Icons.chevron_left);
    expect(_button(tester, Icons.chevron_right).onPressed, isNotNull);

    // Tapping a disabled glass button does nothing.
    await _tapChevron(tester, Icons.chevron_right);
    expect(_button(tester, Icons.chevron_right).onPressed, isNull);
    await _tapChevron(tester, Icons.chevron_right);
    expect(find.text('Nov 9 – Nov 15, 2026'), findsOneWidget);
  });
}
