// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:kipp/core/router/app_router.dart';
import 'package:kipp/core/theme/theme_builder.dart';
import 'package:kipp/core/theme/theme_service.dart';
import 'package:kipp/core/locale/locale_service.dart';
import 'package:kipp/features/expense/data/models/expense_model.dart';
import 'package:kipp/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ ຕ້ອງມີ
  await Hive.initFlutter();                   // ✅ ຕ້ອງມີ ແລະຕ້ອງ await
  Hive.registerAdapter(ExpenseModelAdapter()); // ✅ ຕ້ອງມີ

  runApp(const ProviderScope(child: KippApp()));
}

class KippApp extends ConsumerWidget {
  const KippApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeServiceProvider);
    final locale = ref.watch(localeServiceProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Kipp",
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [Locale('lo'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
    );
  }
}