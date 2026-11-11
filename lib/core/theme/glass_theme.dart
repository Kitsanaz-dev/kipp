// core/theme/glass_theme.dart
import 'package:kipp/core/constant/palette.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// App-wide Liquid Glass theme: iOS 27 optics with Kipp's brand and
/// semantic colours wired into the glow palette (used by toasts, action
/// sheets and button glows). Primary follows the Material themes: coral500
/// in light mode, coral600 in dark mode.
final kippGlassTheme = GlassThemeData(
  light: GlassThemeVariant.ios27Light.copyWith(
    glowColors: const GlassGlowColors(
      primary: Palette.coral500,
      success: Palette.green,
      warning: Palette.yellow,
      danger: Palette.red,
    ),
  ),
  dark: GlassThemeVariant.ios27Dark.copyWith(
    glowColors: const GlassGlowColors(
      primary: Palette.coral600,
      success: Palette.green,
      warning: Palette.yellow,
      danger: Palette.red,
    ),
  ),
);
