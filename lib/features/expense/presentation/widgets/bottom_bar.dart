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
        NativeGlassNavBarItem(label: 'Home', symbol: 'house'),
        NativeGlassNavBarItem(label: 'Expense', symbol: 'kipsign.circle'),
        NativeGlassNavBarItem(label: 'History', symbol: 'calendar'),
        NativeGlassNavBarItem(label: 'Profile', symbol: 'person.crop.circle'),
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
        tabs: const [
          GButton(icon: CupertinoIcons.home, text: 'Home'),
          GButton(icon: CupertinoIcons.graph_square, text: 'Expense'),
          GButton(icon: CupertinoIcons.calendar, text: 'History'),
          GButton(icon: CupertinoIcons.person, text: 'Profile'),
        ],
        selectedIndex: currentIndex,
        onTabChange: onTap, 
      ),
    );
  }
}