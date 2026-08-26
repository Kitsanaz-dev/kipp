import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kipp/core/router/route_paths.dart';
import 'package:kipp/core/theme/app_theme.dart';
import 'package:kipp/core/utils/date_group_formatter.dart';
import 'package:kipp/features/expense/domain/entities/expense_entity.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';
import 'package:kipp/features/expense/presentation/screens/history_page.dart';
import 'package:kipp/features/auth/presentation/screens/profile_page.dart';
import 'package:kipp/features/expense/presentation/screens/expense_page.dart';
import 'package:kipp/features/expense/presentation/widgets/bottom_bar.dart';
import 'package:kipp/features/expense/presentation/widgets/data_section_header.dart';
import 'package:kipp/features/expense/presentation/widgets/day_type_nav_bar.dart';
import 'package:kipp/features/expense/presentation/widgets/kipp_app_bar.dart';
import 'package:kipp/features/expense/presentation/widgets/expense_card.dart';
import 'package:kipp/features/expense/presentation/widgets/transaction_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  int _currentDayType = 0;

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(expenseSummaryProvider(_currentDayType));
    final recentList = ref.watch(expensesByDayTypeProvider(_currentDayType));
    return Scaffold(
      appBar: _currentIndex == 1
          ? const KippAppBar(title: 'Expense')
          : _currentIndex == 2
          ? const KippAppBar(title: 'History')
          : _currentIndex == 3
          ? const KippAppBar(title: 'Profile')
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Welcome, User',
                        style: context.typo.title.copyWith(
                          color: context.colors.text,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // home_screen.dart (ສະເພາະສ່ວນທີ່ແກ້)
                    DayTypeNavBar(
                      currentDayType: _currentDayType,
                      onTap: (value) {
                        setState(() {
                          _currentDayType = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),
                    ExpenseCard(
                      expense: summary.expense,
                      income: summary.income,
                      dayType: _currentDayType,
                    ),
                    const SizedBox(height: 24),
                    ..._buildGroupedTransactions(context, recentList),
                  ],
                ),
              ),
            ),
          ),
          const ExpensePage(),
          const HistoryPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
      ),
      floatingActionButton: (!kIsWeb && Platform.isIOS)
          ? null
          : FloatingActionButton(
              backgroundColor: context.colors.primary,
              child: Icon(Icons.add, color: context.colors.onPrimary),
              onPressed: () {
                context.push(RoutePaths.addExpense);
              },
            ),
    );
  }

  // ເພີ່ມ method ນີ້ໃນ _HomeScreenState
  List<Widget> _buildGroupedTransactions(
    BuildContext context,
    List<ExpenseEntity> transactions, // ✅
  ) {
    // ຈັດກຸ່ມຕາມວັນທີ (label ດຽວກັນ ຢູ່ນຳກັນ)
    final Map<String, List<ExpenseEntity>> grouped = {};
    for (final tx in transactions) {
      final label = DateGroupFormatter.label(tx.date);
      grouped.putIfAbsent(label, () => []).add(tx);
    }

    final widgets = <Widget>[];
    grouped.forEach((label, txList) {
      widgets.add(DateSectionHeader(label: label));
      for (final tx in txList) {
        widgets.add(TransactionTile(transaction: tx));
      }
    });

    if (widgets.isEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: Text(
              'ຍັງບໍ່ມີລາຍການ',
              style: context.typo.body.copyWith(color: context.colors.subtext),
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}
