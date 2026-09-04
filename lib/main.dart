// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:kipp/app.dart';

import 'package:kipp/features/auth/data/models/user_model.dart';
import 'package:kipp/features/expense/data/models/expense_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: KippApp()));
}

