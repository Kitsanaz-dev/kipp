import 'package:flutter/material.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';

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
    return AppBar(
      title: Text(title, style: context.typo.h2.copyWith(color: context.colors.onPrimary)),
      centerTitle: true,
      backgroundColor: context.colors.primary,
      leading: leading,
      actions: actions,
    );
  }
}
