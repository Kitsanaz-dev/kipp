// Verify the logged-out route without platform storage or network access.
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:kipp/app.dart';
import 'package:kipp/core/network/api_client.dart';
import 'package:kipp/core/network/network_providers.dart';
import 'package:kipp/features/auth/presentation/screens/start_screen.dart';
import 'helpers/fake_token_storage.dart';
import 'helpers/glass_test_app.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('kipp_test');
    // Hive ໃຊ້ສະເພາະ settings (theme/locale) - ບໍ່ມີ custom adapter ໃຫ້ register.
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  testWidgets('App builds and shows the start screen', (tester) async {
    final storage = FakeTokenStorage();
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) => handler.reject(
            DioException(
              requestOptions: options,
              error: StateError('Unexpected HTTP request'),
            ),
          ),
        ),
      );
    addTearDown(() => dio.close(force: true));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenStorageProvider.overrideWithValue(storage),
          apiClientProvider.overrideWithValue(ApiClient(storage, dio: dio)),
        ],
        child: wrapWithGlass(const KippApp()),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(StartScreen), findsOneWidget);
    expect(find.text('Kipp'), findsOneWidget);
  });
}
