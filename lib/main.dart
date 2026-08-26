import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kipp/core/router/app_router.dart';
import 'package:kipp/core/theme/theme_builder.dart';
import 'package:kipp/core/theme/theme_service.dart';
import 'package:kipp/features/expense/data/models/expense_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());
  runApp(ProviderScope(child: KippApp()));
}

class KippApp extends ConsumerWidget {
  const KippApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeServiceProvider); // ✅ ຟັງ provider
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Kipp",
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
