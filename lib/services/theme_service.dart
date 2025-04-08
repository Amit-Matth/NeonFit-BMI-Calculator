import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  // Neon primary color (neon cyan)
  final Color _primaryColor = const Color(0xFF00FFFF);

  // Neon accent color (neon pink)
  final Color _accentColor = const Color(0xFFFF00FF);

  // Background color (dark gray)
  final Color _backgroundColor = const Color(0xFF121212);

  // Card color (slightly lighter dark gray)
  final Color _cardColor = const Color(0xFF1D1D1D);

  // Text color
  final Color _textColor = Colors.white;

  // Getters
  Color get primaryColor => _primaryColor;
  Color get accentColor => _accentColor;
  Color get backgroundColor => _backgroundColor;
  Color get cardColor => _cardColor;
  Color get textColor => _textColor;

  // Neon shadow effect
  List<BoxShadow> get neonShadow => [
        BoxShadow(
          color: _primaryColor.withOpacity(0.5),
          blurRadius: 12,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: _accentColor.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  // App theme
  ThemeData get theme => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: _backgroundColor,
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.dark(
          primary: _primaryColor,
          secondary: _accentColor,
          background: _backgroundColor,
          surface: _cardColor,
          onSurface: _textColor,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
          ),
        ),
        cardTheme: CardTheme(
          color: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _primaryColor,
            side: BorderSide(
              color: _primaryColor,
              width: 2,
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: _primaryColor,
          inactiveTrackColor: _primaryColor.withOpacity(0.3),
          thumbColor: _accentColor,
          valueIndicatorColor: _accentColor,
          overlayColor: _primaryColor.withOpacity(0.2),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: _backgroundColor,
          titleTextStyle: TextStyle(
            color: _textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: _backgroundColor,
          selectedItemColor: _primaryColor,
          unselectedItemColor: Colors.grey[600],
        ),
      );

  // Dark mode toggle
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  set isDarkMode(bool value) => _isDarkMode = value;

  // Animation toggle
  bool _enableAnimations = true;
  bool get enableAnimations => _enableAnimations;
  set enableAnimations(bool value) => _enableAnimations = value;

  // Sound toggle
  bool _enableSounds = true;
  bool get enableSounds => _enableSounds;
  set enableSounds(bool value) => _enableSounds = value;

  // Unit system
  bool _useMetric = true;
  bool get useMetric => _useMetric;
  set useMetric(bool value) => _useMetric = value;

  // Gradient
  List<Color> _primaryGradient = [
    Color(0xff633b9c),
    Color(0xff344066),
    Color(0xff415fdd),
    Color(0xffa13ff3),
  ];
  List<Color> get primaryGradient => _primaryGradient;
  set primaryGradient(List<Color> value) => _primaryGradient = value;
}
