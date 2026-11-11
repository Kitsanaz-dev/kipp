// presentation/screens/start_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/widgets/glass_cta_button.dart';
import 'package:kipp/core/router/route_paths.dart';
import 'package:kipp/core/widgets/wave_clipper.dart';

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
                  clipper: const WaveClipper(),
                  child: Container(
                    color: context.colors.primary,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/wallet.svg',
                        height: 160,
                        colorFilter: ColorFilter.mode(
                          context.colors.onPrimary,
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
                    Text(context.text.welcomeTo, style: context.typo.h2),
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
                  context.text.startSubtitle,
                  style: context.typo.subtitle.copyWith(
                    color: context.colors.subtext,
                  ),
                ),
                const SizedBox(height: 32),
                GlassCtaButton(
                  onPressed: () {
                    context.push(RoutePaths.login);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.text.getStarted,
                        style: context.typo.title.copyWith(
                          color: context.colors.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        CupertinoIcons.arrow_right,
                        color: context.colors.onPrimary,
                        size: 20,
                      ),
                    ],
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
