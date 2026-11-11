// core/widgets/glass_body.dart
import 'package:flutter/material.dart';

/// Body adapter for `GlassScaffold`.
///
/// `GlassScaffold` is a `CupertinoPageScaffold` underneath, so unlike
/// Material's `Scaffold` it provides no [Material] ancestor (needed by
/// `TextFormField`, `InkWell`, `TextButton`…) and no default text style, and
/// it does not strip the app bar's share of the top safe-area padding from
/// the body. This restores all three so screen bodies render as they did
/// under `Scaffold`.
class GlassBody extends StatelessWidget {
  const GlassBody({
    super.key,
    required this.child,
    this.removeTop = true,
    this.removeBottom = false,
  });

  final Widget child;

  /// Strip the top padding: true when an app bar sits above the body.
  final bool removeTop;

  /// Strip the bottom padding: true when a bottom bar sits below the body.
  final bool removeBottom;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: removeTop,
      removeBottom: removeBottom,
      child: Material(type: MaterialType.transparency, child: child),
    );
  }
}
