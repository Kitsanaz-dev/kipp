// core/widgets/app_snackbar.dart
// Shared success / error toast used across features.
//
// Screens are GlassScaffolds (CupertinoPageScaffold underneath), which have no
// Material Scaffold for ScaffoldMessenger to show a SnackBar in, so messages
// are shown as floating GlassToast banners in the navigator's overlay instead.
// That overlay outlives the route, so a toast shown right before `pop()` stays
// visible on the screen below, as the SnackBar did.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kipp/core/constant/durations.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class AppSnackbar {
  AppSnackbar._();

  /// How long a toast stays up; same as the SnackBar it replaced.
  static const displayDuration = Duration(seconds: 2);

  /// Height of the bottom bar on the current route, reported by
  /// [AppSnackbarAnchor]; toasts float above it.
  static final ValueNotifier<double> _bottomChrome = ValueNotifier(0);

  /// Removes the toast on screen, if any (a new one replaces it).
  static VoidCallback? _dismissCurrent;

  static void showSuccess(BuildContext context, String message) {
    _show(context, message: message, type: GlassToastType.success);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message: message, type: GlassToastType.error);
  }

  static void _show(
    BuildContext context, {
    required String message,
    required GlassToastType type,
  }) {
    _dismissCurrent?.call();

    late final OverlayEntry entry;
    var removed = false;
    void remove() {
      if (removed) return;
      removed = true;
      entry.remove();
      if (identical(_dismissCurrent, remove)) _dismissCurrent = null;
    }

    entry = OverlayEntry(
      builder: (_) => _ToastHost(
        message: message,
        type: type,
        bottomChrome: _bottomChrome,
        onDismissed: remove,
      ),
    );
    Overlay.of(context).insert(entry);
    _dismissCurrent = remove;
  }
}

/// Wraps a bottom bar so [AppSnackbar] toasts float above it while the
/// enclosing route is the current one.
class AppSnackbarAnchor extends StatefulWidget {
  const AppSnackbarAnchor({super.key, required this.child});

  final Widget child;

  @override
  State<AppSnackbarAnchor> createState() => _AppSnackbarAnchorState();
}

class _AppSnackbarAnchorState extends State<AppSnackbarAnchor> {
  void _report() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final isCurrent = ModalRoute.of(context)?.isCurrent ?? true;
      final box = context.findRenderObject() as RenderBox?;
      final height = isCurrent && box != null && box.hasSize
          ? box.size.height
          : 0.0;
      AppSnackbar._bottomChrome.value = height;
    });
  }

  @override
  void dispose() {
    AppSnackbar._bottomChrome.value = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Depend on the route so pushes/pops over this screen re-report.
    ModalRoute.of(context);
    _report();
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        _report();
        return true;
      },
      child: SizeChangedLayoutNotifier(child: widget.child),
    );
  }
}

/// One toast: slides/fades in above the bottom chrome, auto-dismisses after
/// [AppSnackbar.displayDuration], swipe down to dismiss early.
class _ToastHost extends StatefulWidget {
  const _ToastHost({
    required this.message,
    required this.type,
    required this.bottomChrome,
    required this.onDismissed,
  });

  final String message;
  final GlassToastType type;
  final ValueListenable<double> bottomChrome;
  final VoidCallback onDismissed;

  @override
  State<_ToastHost> createState() => _ToastHostState();
}

class _ToastHostState extends State<_ToastHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.medium,
  )..forward();
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppSnackbar.displayDuration, _dismiss);
  }

  Future<void> _dismiss() async {
    _timer?.cancel();
    if (!mounted) return;
    await _controller.reverse();
    if (mounted) widget.onDismissed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isError = widget.type == GlassToastType.error;
    final media = MediaQuery.of(context);
    final reduceMotion = GlassAccessibilityData.of(context).reduceMotion;

    final toast = Material(
      type: MaterialType.transparency,
      child: Dismissible(
        key: const ValueKey('app_toast'),
        direction: DismissDirection.down,
        onDismissed: (_) {
          _timer?.cancel();
          widget.onDismissed();
        },
        child: GlassToast(
          message: widget.message,
          type: widget.type,
          dismissible: false,
          icon: Icon(
            isError
                ? CupertinoIcons.xmark_circle_fill
                : CupertinoIcons.check_mark_circled_solid,
            color: isError ? colors.danger : colors.ok,
          ),
        ),
      ),
    );

    return ValueListenableBuilder<double>(
      valueListenable: widget.bottomChrome,
      builder: (context, chrome, child) => AnimatedPositioned(
        duration: AppDurations.normal,
        curve: Curves.easeOutCubic,
        left: 16,
        right: 16,
        bottom:
            math.max(media.padding.bottom, chrome) +
            media.viewInsets.bottom +
            12,
        child: child!,
      ),
      child: FadeTransition(
        opacity: _curve,
        child: reduceMotion
            ? toast
            : SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.6),
                  end: Offset.zero,
                ).animate(_curve),
                child: toast,
              ),
      ),
    );
  }
}
