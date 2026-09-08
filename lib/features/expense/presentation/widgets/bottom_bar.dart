// features/expense/presentation/widgets/bottom_bar.dart
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/router/route_paths.dart';
import 'package:native_glass_navbar/native_glass_navbar.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NativeGlassNavBar(
      tintColor: context.colors.primary,
      currentIndex: currentIndex,
      onTap: onTap,
      actionButton: TabBarActionButton(
        symbol: 'plus',
        onTap: () => context.push(RoutePaths.addExpense),
      ),
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
      fallback: GNav(
        rippleColor: context.colors.onPrimary,
        hoverColor: context.colors.background,
        gap: 8,
        activeColor: context.colors.onPrimary,
        iconSize: 24,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: const Duration(milliseconds: 400),
        tabBackgroundColor: context.colors.primary,
        tabs: [
          GButton(icon: CupertinoIcons.home, text: context.text.home),
          GButton(icon: CupertinoIcons.graph_square, text: context.text.expenses),
          GButton(icon: CupertinoIcons.calendar, text: context.text.history),
          GButton(icon: CupertinoIcons.person, text: context.text.profile),
        ],
        selectedIndex: currentIndex,
        onTabChange: onTap, 
      ),
    );
  }
}