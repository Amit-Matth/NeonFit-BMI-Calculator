import 'package:flutter/material.dart';
import 'package:neon_bmi_calculator/screens/animated_splash_screen.dart';
import 'package:neon_bmi_calculator/services/sound_service.dart';
import 'package:provider/provider.dart';
import 'services/bmi_database.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bmiDatabase = BMIDatabase();
  await bmiDatabase.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => SoundService()),
        Provider<BMIDatabase>.value(value: bmiDatabase),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return MaterialApp(
      title: 'Neon BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: themeService.theme,
      home: const AnimatedSplashScreen(),
    );
  }
}
