import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kipp/core/router/route_paths.dart';
import 'package:kipp/core/theme/app_theme.dart';
import 'package:native_glass_navbar/native_glass_navbar.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key, required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return NativeGlassNavBar(
      tintColor: context.colors.primary,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      actionButton: TabBarActionButton(
        symbol: 'plus',
        onTap: () {
          context.push(RoutePaths.addExpense);
        },
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: Duration(milliseconds: 400),
        tabBackgroundColor: context.colors.primary,
        tabs: [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.explore, text: 'Expense'),
          GButton(icon: Icons.history, text: 'History'),
          GButton(icon: Icons.person, text: 'Profile'),
        ],
        selectedIndex: currentIndex,
        onTabChange: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
