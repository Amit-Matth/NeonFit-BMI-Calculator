import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/bmi_record.dart';
import 'services/bmi_database.dart';
import 'services/theme_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(BMIRecordAdapter());
  Hive.registerAdapter(GenderAdapter());
  // Initialize the BMI Database
  final bmiDatabase = BMIDatabase();
  await bmiDatabase.init();

  // Open the box before app starts
  await Hive.openBox<BMIRecord>('bmiRecords');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'Neon BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: themeService.theme.copyWith(
        textTheme: GoogleFonts.chakraPetchTextTheme(
          themeService.theme.textTheme,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
