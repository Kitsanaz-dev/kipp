// presentation/screens/start_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/router/route_paths.dart';
// import 'login_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ---- Top: coral wave background ----
          Column(
            children: [
              Expanded(
                flex: 3,
                child: ClipPath(
                  clipper: _WaveClipper(),
                  child: Container(
                    color: context.colors.primary,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/wallet.svg',
                        height: 160,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(flex: 2, child: SizedBox()),
            ],
          ),

          // ---- Bottom: text + button ----
          Positioned(
            left: 24,
            right: 24,
            bottom: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Welcome to', style: context.typo.h2),
                    const SizedBox(width: 8),
                    Text(
                      'Kipp',
                      style: context.typo.h2.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'ຈັດການລາຍຮັບ-ລາຍຈ່າຍ ໄດ້ງ່າຍໆ\nຄວບຄຸມການເງິນຂອງເຈົ້າໃນມືດຽວ',
                  style: context.typo.subtitle.copyWith(
                    color: context.colors.subtext,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(RoutePaths.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started',
                          style: context.typo.title.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          CupertinoIcons.arrow_right,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// wave shape clipper ສຳລັບພື້ນຫຼັງດ້ານເທິງ
class _WaveClipper extends CustomClipper<Path> {
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
