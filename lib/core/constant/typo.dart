// core/res/typo.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Blueprint ຂອງ typography scale ໜຶ່ງຊຸດ (ບໍ່ມີສີ - ສີແຍກອອກໃນ AppTypo)
abstract class Typo {
  const Typo();

  TextStyle get h1;       // ຫົວຂໍ້ໃຫຍ່ - "Welcome"
  TextStyle get h2;       // ຫົວຂໍ້ຮອງ - "Sign in"
  TextStyle get title;    // ຫົວຂໍ້ card/section - "Total"
  TextStyle get subtitle; // ຂໍ້ຄວາມຮອງ - tab label
  TextStyle get body;     // ຂໍ້ຄວາມທົ່ວໄປ
  TextStyle get bodySmall;// ຂໍ້ຄວາມນ້ອຍ - description
  TextStyle get caption;  // ຂໍ້ຄວາມນ້ອຍທີ່ສຸດ - timestamp, hint
  TextStyle get button;   // ຂໍ້ຄວາມໃນປຸ່ມ
}

class NotoSans extends Typo {
  const NotoSans();

  @override
  TextStyle get h1 => GoogleFonts.notoSansLao(fontSize: 32, fontWeight: FontWeight.bold, height: 1.3);

  @override
  TextStyle get h2 => GoogleFonts.notoSansLao(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3);

  @override
  TextStyle get title => GoogleFonts.notoSansLao(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4);

  @override
  TextStyle get subtitle => GoogleFonts.notoSansLao(fontSize: 15, fontWeight: FontWeight.w500, height: 1.4);

  @override
  TextStyle get body => GoogleFonts.notoSansLao(fontSize: 14, fontWeight: FontWeight.normal, height: 1.5);

  @override
  TextStyle get bodySmall => GoogleFonts.notoSansLao(fontSize: 13, fontWeight: FontWeight.normal, height: 1.5);

  @override
  TextStyle get caption => GoogleFonts.notoSansLao(fontSize: 12, fontWeight: FontWeight.normal, height: 1.4);

  @override
  TextStyle get button => GoogleFonts.notoSansLao(fontSize: 16, fontWeight: FontWeight.w600);
}