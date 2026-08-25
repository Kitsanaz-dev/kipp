// core/res/radius.dart
import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 14.0;   // ໃຊ້ໃນ TextField ຕາມທີ່ຂຽນໄປແລ້ວ
  static const xl = 16.0;   // ໃຊ້ໃນ Button
  static const xxl = 24.0;
  static const full = 999.0; // pill/circle shape

  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgAll => BorderRadius.circular(lg);
  static BorderRadius get xlAll => BorderRadius.circular(xl);
  static BorderRadius get xxlAll => BorderRadius.circular(xxl);
}