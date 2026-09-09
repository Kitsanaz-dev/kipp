// Basic smoke test for the Kipp app.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:kipp/app.dart';

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
    await tester.pumpWidget(const ProviderScope(child: KippApp()));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
