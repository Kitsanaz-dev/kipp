import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipp/core/extensions/build_context_ext.dart';
import 'package:kipp/core/widgets/app_snackbar.dart';
import 'package:kipp/core/widgets/glass_body.dart';
import 'package:kipp/core/theme/theme_builder.dart';
import 'package:kipp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kipp/features/expense/domain/value_objects/date_range.dart';
import 'package:kipp/features/expense/presentation/providers/expense_provider.dart';
import 'package:kipp/features/expense/presentation/screens/expense_screen.dart';
import 'package:kipp/features/expense/presentation/screens/history_screen.dart';
import 'package:kipp/features/settings/presentation/screens/profile_screen.dart';
import 'package:kipp/features/expense/presentation/widgets/bottom_bar.dart';
import 'package:kipp/features/expense/presentation/widgets/day_type_nav_bar.dart';
import 'package:kipp/features/expense/presentation/widgets/expense_card.dart';
import 'package:kipp/features/expense/presentation/widgets/grouped_transaction_list.dart';
import 'package:kipp/features/expense/presentation/widgets/kipp_app_bar.dart';
import 'package:kipp/features/expense/presentation/widgets/period_summary_sheet.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

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
    final appBar = _appBar(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyleFor(Theme.of(context).brightness),
      child: GlassScaffold(
        backgroundColor: context.colors.background,
        // Tabs lay themselves out between the bars, as under Scaffold.
        extendBody: false,
        appBar: appBar,
        // The bar sits in the body column rather than `bottomBar:` because
        // its height is only known after layout (native iOS bar vs. glass
        // fallback); the column sizes it exactly like
        // Scaffold.bottomNavigationBar did. The add action lives in the bar
        // itself (native plus action / glass extra button).
        body: Column(
          children: [
            Expanded(
              child: GlassBody(
                removeTop: appBar != null,
                removeBottom: true,
                child: IndexedStack(
                  index: _tab.index,
                  children: const [
                    _HomeTab(),
                    ExpenseScreen(),
                    HistoryScreen(),
                    ProfileScreen(),
                  ],
                ),
              ),
            ),
            AppSnackbarAnchor(
              child: BottomBar(
                currentIndex: _tab.index,
                onTap: (index) => setState(() => _tab = HomeTab.values[index]),
              ),
            ),
          ],
        ),
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
  PeriodFilter _filter = PeriodFilter.today;

  void _openPeriodSummary() {
    final titles = [
      context.text.todaysBalance,
      context.text.thisWeeksBalance,
      context.text.thisMonthsBalance,
    ];
    showPeriodSummarySheet(
      context,
      _filter.toRange(DateTime.now()),
      titles[_filter.index],
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(expenseSummaryProvider(_filter));
    final transactions = ref.watch(expensesByDayTypeProvider(_filter));
    final userName = ref.watch(authProvider).valueOrNull?.name ?? '';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                context.text.welcomeUser(userName),
                style: context.typo.title.copyWith(
                  color: context.colors.text,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            DayTypeNavBar(
              current: _filter,
              onTap: (value) => setState(() => _filter = value),
            ),
            const SizedBox(height: 16),
            ExpenseCard(
              expense: summary.expense,
              income: summary.income,
              period: _filter,
              onTap: _openPeriodSummary,
            ),
            const SizedBox(height: 24),
            GroupedTransactionList(transactions: transactions),
          ],
        ),
      ),
    );
  }
}
