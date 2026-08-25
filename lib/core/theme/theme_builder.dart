import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

ThemeData buildThemeData(AppTheme appTheme) {
  return ThemeData(
    useMaterial3: true,
    brightness: appTheme.brightness,
    scaffoldBackgroundColor: appTheme.color.background,
    fontFamily: appTheme.typo.typo.body.fontFamily,
    extensions: [
      appTheme.color,
      appTheme.typo,
      appTheme.deco,
    ],
  );
}

final lightThemeData = buildThemeData(LightTheme());
final darkThemeData = buildThemeData(DarkTheme());