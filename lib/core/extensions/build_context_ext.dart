import 'package:flutter/material.dart';
import 'package:kipp/core/res/app_colors.dart';
import 'package:kipp/core/res/app_deco.dart';
import 'package:kipp/core/res/app_typo.dart';
import 'package:kipp/l10n/app_localizations.dart';

extension BuildContextExt on BuildContext {
  AppColor get colors => Theme.of(this).extension<AppColor>()!;
  AppTypo get typo => Theme.of(this).extension<AppTypo>()!;
  AppDeco get deco => Theme.of(this).extension<AppDeco>()!;
  AppLocalizations get text => AppLocalizations.of(this)!;
}