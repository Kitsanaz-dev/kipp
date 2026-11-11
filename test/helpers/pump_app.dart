import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/core/theme/theme_builder.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';
import 'package:kipp/l10n/app_localizations.dart';

import 'glass_test_app.dart';

class _FakeExpenseList extends ExpenseList {
  _FakeExpenseList(this._items);

  final List<ExpenseEntity> _items;

  @override
  Future<List<ExpenseEntity>> build() async => _items;
}

/// Pumps [home] inside a themed, localized MaterialApp with
/// [expenseListProvider] resolving to [items].
Future<void> pumpApp(
  WidgetTester tester,
  Widget home, {
  List<ExpenseEntity> items = const [],
  Locale locale = const Locale('en'),
  bool dark = false,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        expenseListProvider.overrideWith(() => _FakeExpenseList(items)),
      ],
      child: wrapWithGlass(
        MaterialApp(
          theme: dark ? darkThemeData : lightThemeData,
          locale: locale,
          supportedLocales: const [Locale('lo'), Locale('en')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(body: home),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
