import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/core/locale/locale_service.dart';
import 'package:kipp/core/theme/theme_builder.dart';
import 'package:kipp/core/theme/theme_service.dart';
import 'package:kipp/core/widgets/app_snackbar.dart';
import 'package:kipp/features/auth/domain/entities/user_entity.dart';
import 'package:kipp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kipp/features/settings/presentation/screens/profile_screen.dart';
import 'package:kipp/l10n/app_localizations.dart';

import '../../helpers/glass_test_app.dart';

class _FakeAuth extends Auth {
  _FakeAuth({this.failLogout = false});

  final bool failLogout;
  int logoutCalls = 0;

  @override
  Future<UserEntity?> build() async =>
      const UserEntity(id: '1', name: 'Kip', email: 'kip@example.com');

  @override
  Future<void> logout() async {
    logoutCalls++;
    if (failLogout) throw StateError('offline');
  }
}

// Theme / locale services read Hive on build; tests don't need persistence.
class _FakeThemeService extends ThemeService {
  @override
  ThemeMode build() => ThemeMode.light;
}

class _FakeLocaleService extends LocaleService {
  @override
  Locale build() => const Locale('en');
}

Future<void> _pumpProfile(WidgetTester tester, _FakeAuth auth) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => auth),
        themeServiceProvider.overrideWith(_FakeThemeService.new),
        localeServiceProvider.overrideWith(_FakeLocaleService.new),
      ],
      child: wrapWithGlass(
        MaterialApp(
          theme: lightThemeData,
          locale: const Locale('en'),
          supportedLocales: const [Locale('lo'), Locale('en')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(body: ProfileScreen()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  const confirm = 'Are you sure you want to log out?';

  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(400, 1000);
    view.devicePixelRatio = 1;
  });
  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  testWidgets('log out asks for confirmation; Cancel keeps the session', (
    tester,
  ) async {
    final auth = _FakeAuth();
    await _pumpProfile(tester, auth);

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.text(confirm), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text(confirm), findsNothing);
    expect(auth.logoutCalls, 0);
  });

  testWidgets('a failed log out closes the dialog and shows an error toast', (
    tester,
  ) async {
    final auth = _FakeAuth(failLogout: true);
    await _pumpProfile(tester, auth);

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    // The destructive action is the second "Log out" (after the dialog title).
    await tester.tap(find.text('Log out').last);
    await tester.pumpAndSettle();

    expect(auth.logoutCalls, 1);
    expect(find.text(confirm), findsNothing);
    expect(find.text('Something went wrong, please try again'), findsOneWidget);

    // The toast auto-dismisses.
    await tester.pump(AppSnackbar.displayDuration);
    await tester.pumpAndSettle();
    expect(find.text('Something went wrong, please try again'), findsNothing);
  });
}
