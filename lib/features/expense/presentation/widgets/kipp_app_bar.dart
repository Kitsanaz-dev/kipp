import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/theme/theme_builder.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// Transparent iOS 26 style navigation bar (a [GlassAppBar]) with a centred
/// title. Glass lives on the [leading] / [actions] buttons, not the bar.
///
/// Still a [PreferredSizeWidget], so it works in `GlassScaffold.appBar` and
/// in Material's `Scaffold.appBar`.
class KippAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KippAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Material's AppBar used to set the status-bar icon style; keep that.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyleFor(Theme.of(context).brightness),
      child: GlassAppBar(
        toolbarHeight: kToolbarHeight,
        title: Text(
          title,
          style: context.typo.h2.copyWith(color: context.colors.text),
        ),
        leading: leading,
        actions: actions,
      ),
    );
  }
}

/// Glass back button for [KippAppBar.leading]; pops the current route.
class KippBackButton extends StatelessWidget {
  const KippBackButton({super.key, this.color});

  /// Icon colour; defaults to `context.colors.text`.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GlassIconButton(
      icon: Icon(CupertinoIcons.back, color: color ?? context.colors.text),
      semanticLabel: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () => context.pop(),
    );
  }
}
