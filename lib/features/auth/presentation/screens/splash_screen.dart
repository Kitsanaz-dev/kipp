// features/auth/presentation/screens/splash_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/widgets/wave_clipper.dart';

/// ໜ້າ splash ຕອນເປີດແອັບ - ສະແດງໄວ້ໃນຂະນະທີ່ router ກຳລັງກວດ session ຈາກ Hive.
/// ເມື່ອ auth ພ້ອມ, redirect ໃນ app_router ຈະພາໄປ /home ຫຼື /start ໃຫ້ເອງ.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: Column(
        children: [
          // ---- Top: coral wave background + logo (ຄືກັບ StartScreen) ----
          Expanded(
            flex: 3,
            child: ClipPath(
              clipper: const WaveClipper(),
              child: Container(
                color: colors.primary,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/wallet.svg',
                    height: 160,
                    colorFilter: ColorFilter.mode(
                      colors.onPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ---- Bottom: wordmark + loading ----
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kipp',
                  style: context.typo.h1.copyWith(color: colors.primary),
                ),
                const SizedBox(height: 24),
                CupertinoActivityIndicator(color: colors.subtext),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
