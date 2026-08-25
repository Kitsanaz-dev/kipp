// core/res/app_deco.dart
import 'package:flutter/material.dart';

/// ຄຸ້ມ decoration ທີ່ "ປ່ຽນຕາມ theme" (ຕ່າງຈາກ Spacing/Radius ທີ່ຄົງທີ່)
/// ຫຼັກໆຄື shadow - Light mode ໃຊ້ shadow ອ່ອນ, Dark mode ໃຊ້ shadow ເຂັ້ມ/ບໍ່ມີ
class AppDeco extends ThemeExtension<AppDeco> {
  final List<BoxShadow> shadow;
  final List<BoxShadow> shadowSm;

  const AppDeco({
    required this.shadow,
    required this.shadowSm,
  });

  @override
  AppDeco copyWith({List<BoxShadow>? shadow, List<BoxShadow>? shadowSm}) {
    return AppDeco(
      shadow: shadow ?? this.shadow,
      shadowSm: shadowSm ?? this.shadowSm,
    );
  }

  @override
  AppDeco lerp(ThemeExtension<AppDeco>? other, double t) {
    if (other is! AppDeco) return this;
    return t < 0.5 ? this : other; // shadow list ບໍ່ interpolate ງ່າຍ, ສະຫຼັບກາງທາງ
  }
}