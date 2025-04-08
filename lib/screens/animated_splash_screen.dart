import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:neon_bmi_calculator/screens/home_screen.dart';
import 'package:neon_bmi_calculator/services/theme_service.dart';
import 'package:provider/provider.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  void navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context, listen: false);

    return Scaffold(
      backgroundColor: themeService.currentBackgroundColor,
      body: Center(
        child: Image.asset(
          'assets/images/icon.png',
          width: 150,
          height: 150,
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .scale(
                delay: 300.ms,
                duration: 800.ms,
                curve: Curves.elasticOut,
                begin: const Offset(0.5, 0.5))
            .then(delay: 200.ms)
            .shake(hz: 4, duration: 300.ms, curve: Curves.easeInOutCubic)
            .then(delay: 500.ms)
            .slideY(end: -0.3, duration: 400.ms, curve: Curves.easeInCubic)
            .fadeOut(duration: 300.ms),
      ),
    );
  }
}
