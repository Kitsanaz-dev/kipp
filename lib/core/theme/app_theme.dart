// core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/res/app_colors.dart';
import 'package:kipp/core/res/app_deco.dart';
import 'package:kipp/core/res/app_typo.dart';

/// Blueprint ຂອງ theme ໃດໜຶ່ງ - LightTheme ແລະ DarkTheme
/// ຕ້ອງ implement class ນີ້ຄົບທຸກ field
abstract class AppTheme {
  Brightness get brightness;
  AppColor get color;
  AppTypo get typo;
  AppDeco get deco;
}