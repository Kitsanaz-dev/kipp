// core/theme/dark_theme.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/res/app_colors.dart';
import 'package:kipp/core/res/app_deco.dart';
import 'package:kipp/core/res/app_typo.dart';
import 'package:kipp/core/constant/typo.dart';
import '../constant/palette.dart';
import 'app_theme.dart';

class DarkTheme implements AppTheme {
  @override
  Brightness get brightness => Brightness.dark;

  @override
  AppColor get color => AppColor(
    surface: Palette.grey800,
    background: Palette.black, // ຕ້ອງ opaque ຄືກັບ light theme (Palette.white) - ຢ່າໃຫ້ scaffold ໂປ່ງໃສ
    text: Palette.grey100,
    subtext: Palette.grey350, // grey500 ເກົ່າ contrast ບໍ່ພໍ (~3.3:1 ເທິງ surface) - grey350 ໃຫ້ ~7:1
    toastContainer: Palette.grey100.withValues(alpha: 0.85),
    onToastContainer: Palette.grey800,
    hint: Palette.grey400, // grey600 ເກົ່າ contrast ~1.8:1 ເທິງ hintContainer - grey400 ໃຫ້ ~5.7:1
    hintContainer: Palette.grey770,
    onHintContainer: Palette.grey350,
    inactive: Palette.grey500,
    inactiveContainer: Palette.grey700,
    onInactiveContainer: Palette.grey400,
    primary: Palette.coral400, // ອ່ອນລົງໜ້ອຍໜຶ່ງໃຫ້ contrast ດີເທິງພື້ນມືດ
    onPrimary: Palette.black,
    secondary: Palette.red,
    onSecondary: Palette.white,
    tertiary: Palette.yellow,
    onTertiary: Palette.black,
    danger: Palette.red,
    ok: Palette.green,
  );
  @override
  late final AppTypo typo = AppTypo(
    typo: const NotoSans(),
    fontColor: color.text,
  );
  // core/theme/dark_theme.dart (ເພີ່ມສ່ວນນີ້)
  @override
  AppDeco get deco => AppDeco(
    shadow: [
      BoxShadow(
        color: Palette.black.withValues(alpha: 0.35),
        blurRadius: 35,
        offset: const Offset(0, 10),
      ),
    ],
    shadowSm: [
      BoxShadow(
        color: Palette.black.withValues(alpha: 0.25),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
