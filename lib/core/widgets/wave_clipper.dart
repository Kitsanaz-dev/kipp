// core/widgets/wave_clipper.dart
import 'package:flutter/widgets.dart';

/// Wave shape ສຳລັບພື້ນຫຼັງດ້ານເທິງ - ໃຊ້ຮ່ວມກັນລະຫວ່າງ SplashScreen ແລະ StartScreen
class WaveClipper extends CustomClipper<Path> {
  const WaveClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 40,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
