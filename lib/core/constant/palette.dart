// core/res/palette.dart
import 'package:flutter/material.dart';

class Palette {
  Palette._();

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // ---- Grey scale (ລະອຽດເພື່ອໃຊ້ interpolate surface/container) ----
  static const grey100 = Color(0xFFF2F2F2);
  static const grey150 = Color(0xFFE8E8E8);
  static const grey200 = Color(0xFFDCDCDC);
  static const grey250 = Color(0xFFCFCFCF);
  static const grey300 = Color(0xFFB8B8B8);
  static const grey350 = Color(0xFFA6A6A6);
  static const grey400 = Color(0xFF9B9B9B);
  static const grey500 = Color(0xFF6E6E6E);
  static const grey600 = Color(0xFF4A4A4A);
  static const grey700 = Color(0xFF2D2D2D);
  static const grey770 = Color(0xFF232323);
  static const grey800 = Color(0xFF1C1C1E);
  static const grey900 = Color(0xFF0F0F10);

  // ---- Brand: Coral (Kipp primary, ຈາກຮູບທີ່ເຈົ້າສົ່ງ) ----
  static const coral100 = Color(0xFFFAE1DC);
  static const coral300 = Color(0xFFF1A594);
  static const coral400 = Color(0xFFEFA79D);
  static const coral500 = Color(0xFFE8897E);
  static const coral600 = Color(0xFFD97669);

  // ---- Semantic accents ----
  static const green  = Color(0xFF4CAF7D); // income
  static const red    = Color(0xFFE05C5C); // expense
  static const yellow = Color(0xFFE8A93E); // warning
}