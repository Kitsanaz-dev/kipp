import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

/// Status-bar / nav-bar overlay for a given brightness.
/// Dark mode -> white status-bar icons; light mode -> dark icons.
SystemUiOverlayStyle systemOverlayStyleFor(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
  );
}

ThemeData buildThemeData(AppTheme appTheme) {
  return ThemeData(
    useMaterial3: true,
    brightness: appTheme.brightness,
    scaffoldBackgroundColor: appTheme.color.background,
    fontFamily: appTheme.typo.typo.body.fontFamily,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: systemOverlayStyleFor(appTheme.brightness),
    ),
    extensions: [
      appTheme.color,
      appTheme.typo,
      appTheme.deco,
    ],
  );
}

final lightThemeData = buildThemeData(LightTheme());
final darkThemeData = buildThemeData(DarkTheme());