// features/expense/presentation/widgets/bottom_bar.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/router/route_paths.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:native_glass_navbar/native_glass_navbar.dart';

/// Main tab bar. On iOS 26+ this is the real UIKit glass tab bar
/// ([NativeGlassNavBar]) with its own plus action; everywhere else (Android,
/// older iOS) it falls back to a [GlassTabBar.bottom] whose trailing extra
/// button is the add-transaction action.
class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    void addExpense() => context.push(RoutePaths.addExpense);

    final fallback = GlassTabBar.bottom(
      selectedIndex: currentIndex,
      onTabSelected: onTap,
      verticalPadding: 12,
      selectedIconColor: colors.primary,
      selectedLabelColor: colors.primary,
      unselectedIconColor: colors.subtext,
      unselectedLabelColor: colors.subtext,
      tabs: [
        GlassTab(
          icon: const Icon(CupertinoIcons.home),
          label: context.text.home,
        ),
        GlassTab(
          icon: const Icon(CupertinoIcons.graph_square),
          label: context.text.expenses,
        ),
        GlassTab(
          icon: const Icon(CupertinoIcons.calendar),
          label: context.text.history,
        ),
        GlassTab(
          icon: const Icon(CupertinoIcons.person),
          label: context.text.profile,
        ),
      ],
      extraButton: GlassTabBarExtraButton(
        icon: const Icon(CupertinoIcons.add),
        iconColor: colors.primary,
        label: context.text.addTransaction,
        onTap: addExpense,
      ),
    );

    return NativeGlassNavBar(
      tintColor: colors.primary,
      currentIndex: currentIndex,
      onTap: onTap,
      actionButton: TabBarActionButton(symbol: 'plus', onTap: addExpense),
      tabs: [
        NativeGlassNavBarItem(label: context.text.home, symbol: 'house'),
        NativeGlassNavBarItem(
          label: context.text.expenses,
          symbol: 'kipsign.circle',
        ),
        NativeGlassNavBarItem(label: context.text.history, symbol: 'calendar'),
        NativeGlassNavBarItem(
          label: context.text.profile,
          symbol: 'person.crop.circle',
        ),
      ],
      // The native bar pads itself for the home indicator; the glass
      // fallback floats over it on iOS, but must clear Android's system
      // navigation bar.
      fallback: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: defaultTargetPlatform == TargetPlatform.android,
        child: fallback,
      ),
    );
  }
}
