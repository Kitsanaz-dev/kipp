import 'package:go_router/go_router.dart';
import 'package:kipp/features/auth/presentation/screens/start_screen.dart';
import 'package:kipp/features/auth/presentation/screens/login_screen.dart';
import 'package:kipp/features/auth/presentation/screens/register_screen.dart';
import 'package:kipp/features/expense/presentation/screens/add_expense_detial_page.dart';
import 'package:kipp/features/expense/presentation/screens/home_screen.dart';
import 'package:kipp/features/expense/presentation/screens/receipt_capture_screen.dart';
import 'dart:io';
import 'page_transitions.dart';
import 'route_paths.dart';

final appRouter = GoRouter(
  initialLocation: RoutePaths.start,
  routes: [
    GoRoute(
      path: RoutePaths.start,
      builder: (context, state) => const StartScreen(), // ໜ້າທຳອິດ ບໍ່ຕ້ອງ animate
    ),
    GoRoute(
      path: RoutePaths.login,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: RoutePaths.register,
      pageBuilder: (context, state) => fadeTransitionPage(
        key: state.pageKey,
        child: const RegisterScreen(),
      ),
    ),
    GoRoute(
      path: RoutePaths.home,
      pageBuilder: (context, state) => fadeThroughPage(
        key: state.pageKey,
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: RoutePaths.addExpense,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const AddExpenseDetailPage(),
      ),
    ),
    GoRoute(
      path: RoutePaths.receiptCapture,
      pageBuilder: (context, state) => slideTransitionPage<File?>(
        key: state.pageKey,
        child: const ReceiptCaptureScreen(),
      ),
    ),
  ],
);