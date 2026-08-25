// core/res/app_color.dart
import 'package:flutter/material.dart';

class AppColor extends ThemeExtension<AppColor> {
  final Color surface;
  final Color background;
  final Color text;
  final Color subtext;
  final Color toastContainer;
  final Color onToastContainer;
  final Color hint;
  final Color hintContainer;
  final Color onHintContainer;
  final Color inactive;
  final Color inactiveContainer;
  final Color onInactiveContainer;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color tertiary;
  final Color onTertiary;
  final Color danger;
  final Color ok;

  const AppColor({
    required this.surface,
    required this.background,
    required this.text,
    required this.subtext,
    required this.toastContainer,
    required this.onToastContainer,
    required this.hint,
    required this.hintContainer,
    required this.onHintContainer,
    required this.inactive,
    required this.inactiveContainer,
    required this.onInactiveContainer,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.danger,
    required this.ok,
  });

  @override
  AppColor copyWith({
    Color? surface,
    Color? background,
    Color? text,
    Color? subtext,
    Color? toastContainer,
    Color? onToastContainer,
    Color? hint,
    Color? hintContainer,
    Color? onHintContainer,
    Color? inactive,
    Color? inactiveContainer,
    Color? onInactiveContainer,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? tertiary,
    Color? onTertiary,
    Color? danger,
    Color? ok,
  }) {
    return AppColor(
      surface: surface ?? this.surface,
      background: background ?? this.background,
      text: text ?? this.text,
      subtext: subtext ?? this.subtext,
      toastContainer: toastContainer ?? this.toastContainer,
      onToastContainer: onToastContainer ?? this.onToastContainer,
      hint: hint ?? this.hint,
      hintContainer: hintContainer ?? this.hintContainer,
      onHintContainer: onHintContainer ?? this.onHintContainer,
      inactive: inactive ?? this.inactive,
      inactiveContainer: inactiveContainer ?? this.inactiveContainer,
      onInactiveContainer: onInactiveContainer ?? this.onInactiveContainer,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      danger: danger ?? this.danger,
      ok: ok ?? this.ok,
    );
  }

  @override
  AppColor lerp(ThemeExtension<AppColor>? other, double t) {
    if (other is! AppColor) return this;
    return AppColor(
      surface: Color.lerp(surface, other.surface, t)!,
      background: Color.lerp(background, other.background, t)!,
      text: Color.lerp(text, other.text, t)!,
      subtext: Color.lerp(subtext, other.subtext, t)!,
      toastContainer: Color.lerp(toastContainer, other.toastContainer, t)!,
      onToastContainer: Color.lerp(onToastContainer, other.onToastContainer, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      hintContainer: Color.lerp(hintContainer, other.hintContainer, t)!,
      onHintContainer: Color.lerp(onHintContainer, other.onHintContainer, t)!,
      inactive: Color.lerp(inactive, other.inactive, t)!,
      inactiveContainer: Color.lerp(inactiveContainer, other.inactiveContainer, t)!,
      onInactiveContainer: Color.lerp(onInactiveContainer, other.onInactiveContainer, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      ok: Color.lerp(ok, other.ok, t)!,
    );
  }
}