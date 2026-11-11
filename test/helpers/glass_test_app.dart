import 'package:flutter/material.dart';
import 'package:kipp/core/theme/glass_theme.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// Wraps [app] in the same Liquid Glass scope `main.dart` installs, so
/// migrated glass widgets resolve the app's glass theme and Material
/// brightness under test.
///
/// `adaptiveQuality` is off: the adaptive scope benchmarks real raster
/// timings, which are meaningless in the test binding. The package detects
/// `FLUTTER_TEST` itself and loads its shaders from the test asset bundle.
Widget wrapWithGlass(Widget app) {
  return LiquidGlassWidgets.wrap(
    respectSystemAccessibility: true,
    brightnessResolver: Theme.maybeBrightnessOf,
    theme: kippGlassTheme,
    child: app,
  );
}
