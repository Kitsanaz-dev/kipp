// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:kipp/app.dart';
import 'package:kipp/core/theme/glass_theme.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Hive ຍັງໃຊ້ສຳລັບ settings ເທົ່ານັ້ນ (theme_service / locale_service).
  await Hive.initFlutter();
  // Pre-warm the glass shaders so the first glass frame doesn't flash.
  await LiquidGlassWidgets.initialize();

  runApp(
    ProviderScope(
      child: LiquidGlassWidgets.wrap(
        adaptiveQuality: true,
        respectSystemAccessibility: true,
        // Bridges MaterialApp's ThemeMode into the glass brightness cascade.
        brightnessResolver: Theme.maybeBrightnessOf,
        theme: kippGlassTheme,
        child: const KippApp(),
      ),
    ),
  );
}
