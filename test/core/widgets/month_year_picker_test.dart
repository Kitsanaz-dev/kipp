import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/core/theme/theme_builder.dart';
import 'package:kipp/core/widgets/month_year_picker.dart';
import 'package:kipp/l10n/app_localizations.dart';

import '../../helpers/glass_test_app.dart';

/// Holds what the picker returned once it closes.
class _Result {
  bool closed = false;
  DateTime? value;
}

Future<_Result> _openPicker(
  WidgetTester tester, {
  required DateTime initial,
  required DateTime first,
  required DateTime last,
  Locale locale = const Locale('en'),
  bool yearOnly = false,
}) async {
  final result = _Result();
  await tester.pumpWidget(
    wrapWithGlass(
      MaterialApp(
        theme: lightThemeData,
        locale: locale,
        supportedLocales: const [Locale('lo'), Locale('en')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result.value = await showMonthYearPicker(
                context,
                initial: initial,
                first: first,
                last: last,
                yearOnly: yearOnly,
              );
              result.closed = true;
            },
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return result;
}

void main() {
  testWidgets('tapping an enabled month returns its first day', (tester) async {
    final result = await _openPicker(
      tester,
      initial: DateTime(2026, 5, 17),
      first: DateTime(2025, 3),
      last: DateTime(2026, 11),
    );

    expect(find.text('Select month'), findsOneWidget);
    expect(find.text('2025'), findsOneWidget);
    expect(find.text('2026'), findsOneWidget);

    await tester.tap(find.text('Aug'));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(result.closed, isTrue);
    expect(result.value, DateTime(2026, 8));
  });

  testWidgets('months outside [first, last] are not selectable', (
    tester,
  ) async {
    final result = await _openPicker(
      tester,
      initial: DateTime(2026, 11),
      first: DateTime(2025, 3),
      last: DateTime(2026, 11),
    );

    await tester.tap(find.text('Dec'));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
    expect(result.closed, isFalse);

    await tester.tap(find.text('2025'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Feb'));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
    expect(result.closed, isFalse);

    await tester.tap(find.text('Mar'));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
    expect(result.value, DateTime(2025, 3));
  });

  testWidgets('initial outside the bounds is clamped', (tester) async {
    final result = await _openPicker(
      tester,
      initial: DateTime(2030, 1),
      first: DateTime(2026, 1),
      last: DateTime(2026, 6),
    );
    // Only 2026 exists, so the year row has a single chip.
    expect(find.text('2026'), findsOneWidget);
    expect(find.text('2030'), findsNothing);
    expect(result.closed, isFalse);
  });

  testWidgets('renders Lao labels and month names', (tester) async {
    await _openPicker(
      tester,
      initial: DateTime(2026, 1),
      first: DateTime(2026, 1),
      last: DateTime(2026, 12),
      locale: const Locale('lo'),
    );

    expect(find.text('ເລືອກເດືອນ'), findsOneWidget);
    expect(find.text('Jan'), findsNothing);
  });

  testWidgets('year-only mode returns Jan 1 of the tapped year', (
    tester,
  ) async {
    final result = await _openPicker(
      tester,
      initial: DateTime(2026, 5),
      first: DateTime(2024, 3),
      last: DateTime(2026, 11),
      yearOnly: true,
    );

    expect(find.text('Select year'), findsOneWidget);
    expect(find.text('This year'), findsOneWidget);
    expect(find.text('Jan'), findsNothing); // no month grid

    await tester.tap(find.text('2025'));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
    expect(result.value, DateTime(2025));
  });
}
