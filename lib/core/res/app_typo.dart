// core/res/app_typo.dart
import 'package:flutter/material.dart';
import '../constant/typo.dart';

/// ຜະສົມ Typo (font scale) ເຂົ້າກັບ fontColor ຂອງແຕ່ລະ theme
class AppTypo extends ThemeExtension<AppTypo> {
  final Typo typo;
  final Color fontColor;

  const AppTypo({
    required this.typo,
    required this.fontColor,
  });

  TextStyle get h1 => typo.h1.copyWith(color: fontColor);
  TextStyle get h2 => typo.h2.copyWith(color: fontColor);
  TextStyle get title => typo.title.copyWith(color: fontColor);
  TextStyle get subtitle => typo.subtitle.copyWith(color: fontColor);
  TextStyle get body => typo.body.copyWith(color: fontColor);
  TextStyle get bodySmall => typo.bodySmall.copyWith(color: fontColor);
  TextStyle get caption => typo.caption.copyWith(color: fontColor);
  TextStyle get button => typo.button.copyWith(color: fontColor);

  @override
  AppTypo copyWith({Typo? typo, Color? fontColor}) {
    return AppTypo(
      typo: typo ?? this.typo,
      fontColor: fontColor ?? this.fontColor,
    );
  }

  @override
  AppTypo lerp(ThemeExtension<AppTypo>? other, double t) {
    if (other is! AppTypo) return this;
    return AppTypo(
      typo: typo, // font family ບໍ່ animate, ປ່ຽນສະເພາະສີ
      fontColor: Color.lerp(fontColor, other.fontColor, t)!,
    );
  }
}