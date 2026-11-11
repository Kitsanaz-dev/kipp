// core/widgets/glass_cta_button.dart
import 'package:flutter/material.dart';
import 'package:kipp/core/constant/radius.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/widgets/adaptive_spinner.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// Full-width, tinted glass call-to-action button (a [GlassButton.custom])
/// for plain pages: Get started, Login, Sign up, Save, Log out.
///
/// - [onPressed] `null` disables it (dimmed, no taps).
/// - [isLoading] swaps [child] for an [AdaptiveSpinner] and disables taps,
///   so a submit can't fire twice.
/// - [tint] defaults to the brand primary; pass e.g. a faint danger tint
///   for a destructive action.
class GlassCtaButton extends StatelessWidget {
  const GlassCtaButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.height = 54,
    this.tint,
    this.spinnerColor,
    this.spinnerStrokeWidth = 2,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final double height;

  /// Glass tint; defaults to `colors.primary`.
  final Color? tint;

  /// Spinner colour while loading; defaults to `colors.onPrimary`.
  final Color? spinnerColor;

  /// Spinner stroke (Android only), as [AdaptiveSpinner.strokeWidth].
  final double spinnerStrokeWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null && !isLoading;

    // GlassButton sizes to its child when width is null and budgets its
    // press texture from a finite width, so hand it the real one.
    return LayoutBuilder(
      builder: (context, constraints) => GlassButton.custom(
        width: constraints.maxWidth,
        height: height,
        shape: const LiquidRoundedSuperellipse(borderRadius: AppRadius.xl),
        settings: LiquidGlassSettings(
          glassColor: (tint ?? colors.primary).withValues(
            alpha: tint == null ? 0.9 : tint!.a,
          ),
        ),
        enabled: enabled,
        onTap: onPressed ?? () {},
        child: isLoading
            ? AdaptiveSpinner(
                size: 22,
                color: spinnerColor ?? colors.onPrimary,
                strokeWidth: spinnerStrokeWidth,
              )
            : child,
      ),
    );
  }
}
