import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kipp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kipp/features/auth/presentation/screens/splash_screen.dart';
import 'package:kipp/features/auth/presentation/screens/start_screen.dart';
import 'package:kipp/features/auth/presentation/screens/login_screen.dart';
import 'package:kipp/features/auth/presentation/screens/register_screen.dart';
import 'package:kipp/features/expense/presentation/screens/add_expense_detail_screen.dart';
import 'package:kipp/features/expense/presentation/screens/home_screen.dart';
import 'package:kipp/features/expense/presentation/screens/receipt_capture_screen.dart';
import 'package:kipp/features/settings/presentation/screens/edit_profile_screen.dart';
import 'page_transitions.dart';
import 'route_paths.dart';

part 'app_router.g.dart';

/// ໜ້າ auth (ບໍ່ຕ້ອງ login ກ່ອນ)
const _authRoutes = {
  RoutePaths.splash,
  RoutePaths.start,
  RoutePaths.login,
  RoutePaths.register,
};

@riverpod
GoRouter router(RouterRef ref) {
  // bridge auth state -> Listenable ເພື່ອໃຫ້ GoRouter re-run redirect ຕອນ auth ປ່ຽນ
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);
  ref.listen(authProvider, (_, _) => refresh.value++);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loc = state.matchedLocation;

      // ຍັງໂຫຼດ session ຈາກ Hive ຢູ່ - ຄ້າງໜ້າ splash ໄວ້ກ່ອນ
      if (auth.isLoading) {
        return loc == RoutePaths.splash ? null : RoutePaths.splash;
      }

      final loggedIn = !auth.hasError && auth.valueOrNull != null;
      final onAuthRoute = _authRoutes.contains(loc);

      // session ພ້ອມແລ້ວ - ອອກຈາກ splash ໄປໜ້າທີ່ຖືກຕ້ອງ
      if (loc == RoutePaths.splash) {
        return loggedIn ? RoutePaths.home : RoutePaths.start;
      }

      if (!loggedIn && !onAuthRoute) return RoutePaths.start;
      if (loggedIn && onAuthRoute) return RoutePaths.home;
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(), // ໜ້າໂຫຼດ ບໍ່ຕ້ອງ animate
      ),
      GoRoute(
        path: RoutePaths.start,
        builder: (context, state) => const StartScreen(), // ໜ້າ welcome ບໍ່ຕ້ອງ animate
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
          child: const AddExpenseDetailScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.receiptCapture,
        pageBuilder: (context, state) => slideTransitionPage<File?>(
          key: state.pageKey,
          child: const ReceiptCaptureScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.editProfile,
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const EditProfileScreen(),
        ),
      ),
    ],
  );
}
