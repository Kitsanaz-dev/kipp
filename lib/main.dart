// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:kipp/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Hive ຍັງໃຊ້ສຳລັບ settings ເທົ່ານັ້ນ (theme_service / locale_service).
  await Hive.initFlutter();
  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: KippApp()));
}
