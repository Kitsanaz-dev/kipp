import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/router/route_paths.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';
import 'package:kipp/features/expense/presentation/screens/expense_screen.dart';
import 'package:kipp/features/expense/presentation/screens/history_screen.dart';
import 'package:kipp/features/settings/presentation/screens/profile_screen.dart';
import 'package:kipp/features/expense/presentation/widgets/bottom_bar.dart';
import 'package:kipp/features/expense/presentation/widgets/day_type_nav_bar.dart';
import 'package:kipp/features/expense/presentation/widgets/expense_card.dart';
import 'package:kipp/features/expense/presentation/widgets/grouped_transaction_list.dart';
import 'package:kipp/features/expense/presentation/widgets/kipp_app_bar.dart';

/// Bottom-navigation destinations, in tab order.
enum HomeTab { home, expense, history, profile }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  HomeTab _tab = HomeTab.home;

  /// The home tab draws its own header instead of the shared app bar.
  PreferredSizeWidget? _appBar(BuildContext context) {
    switch (_tab) {
      case HomeTab.home:
        return null;
      case HomeTab.expense:
        return KippAppBar(title: context.text.expenses);
      case HomeTab.history:
        return KippAppBar(title: context.text.history);
      case HomeTab.profile:
        return KippAppBar(title: context.text.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: IndexedStack(
        index: _tab.index,
        children: const [
          _HomeTab(),
          ExpenseScreen(),
          HistoryScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: _tab.index,
        onTap: (index) => setState(() => _tab = HomeTab.values[index]),
      ),
      floatingActionButton: (!kIsWeb && Platform.isIOS)
          ? null
          : FloatingActionButton(
              backgroundColor: context.colors.primary,
              onPressed: () => context.push(RoutePaths.addExpense),
              child: Icon(Icons.add, color: context.colors.onPrimary),
            ),
    );
  }
}

/// Home tab: greeting, day-type filter, summary card and recent transactions.
/// Owns the selected day-type filter since nothing outside this tab needs it.
class _HomeTab extends ConsumerStatefulWidget {
  const _HomeTab();

  @override
  ConsumerState<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<_HomeTab> {
  int _dayType = 0;

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(expenseSummaryProvider(_dayType));
    final transactions = ref.watch(expensesByDayTypeProvider(_dayType));

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                context.text.welcomeUser,
                style: context.typo.title.copyWith(
                  color: context.colors.text,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            DayTypeNavBar(
              currentDayType: _dayType,
              onTap: (value) => setState(() => _dayType = value),
            ),
            const SizedBox(height: 16),
            ExpenseCard(
              expense: summary.expense,
              income: summary.income,
              dayType: _dayType,
            ),
            const SizedBox(height: 24),
            GroupedTransactionList(transactions: transactions),
          ],
        ),
      ),
    );
  }
}
