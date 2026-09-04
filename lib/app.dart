// app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipp/core/locale/locale_service.dart';
import 'package:kipp/core/router/app_router.dart';
import 'package:kipp/core/theme/theme_builder.dart';
import 'package:kipp/core/theme/theme_service.dart';
import 'package:kipp/l10n/app_localizations.dart';

class KippApp extends ConsumerWidget {
  const KippApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeServiceProvider);
    final locale = ref.watch(localeServiceProvider);
    final router = ref.watch(routerProvider);

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
      routerConfig: router,
    );
  }
}
