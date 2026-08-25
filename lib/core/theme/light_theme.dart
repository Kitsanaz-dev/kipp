// core/theme/light_theme.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/res/app_colors.dart';
import 'package:kipp/core/res/app_deco.dart';
import 'package:kipp/core/res/app_typo.dart';
import 'package:kipp/core/constant/typo.dart';
import '../constant/palette.dart';
import 'app_theme.dart';

class LightTheme implements AppTheme {
  @override
  Brightness get brightness => Brightness.light;

  @override
  AppColor get color => AppColor(
    surface: Palette.grey100,
    background: Palette.white,
    text: Palette.black,
    subtext: Palette.grey600,
    toastContainer: Palette.black.withValues(alpha: 0.85),
    onToastContainer: Palette.grey100,
    hint: Palette.grey350,
    hintContainer: Palette.grey150,
    onHintContainer: Palette.grey500,
    inactive: Palette.grey400,
    inactiveContainer: Palette.grey200,
    onInactiveContainer: Palette.white,
    primary: Palette.coral500,
    onPrimary: Palette.white,
    secondary: Palette.red, // ໃຊ້ສຳລັບ expense/negative
    onSecondary: Palette.white,
    tertiary: Palette.yellow, // ໃຊ້ສຳລັບ warning/highlight
    onTertiary: Palette.white,
    danger: Palette.red,
    ok: Palette.green,
  );

  @override
  late final AppTypo typo = AppTypo(
    typo: const NotoSans(),
    fontColor: color.text,
  );
  @override
  AppDeco get deco => AppDeco(
    shadow: [
      BoxShadow(
        color: Palette.black.withValues(alpha: 0.08),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
    shadowSm: [
      BoxShadow(
        color: Palette.black.withValues(alpha: 0.06),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
