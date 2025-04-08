import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _darkModeKey = 'isDarkMode';
  static const String _enableAnimationsKey = 'enableAnimations';

  final Color _primaryColor = const Color(0xFF00FFFF);

  final Color _accentColor = const Color(0xFFFF00FF);

  final Color _darkBackgroundColor = const Color(0xFF121212);
  final Color _darkCardColor = const Color(0xFF1D1D1D);
  final Color _darkTextColor = Colors.white;

  final Color _lightBackgroundColor = Colors.white;
  final Color _lightCardColor = const Color(0xFFF0F0F0);
  final Color _lightTextColor = Colors.black;

  bool _isDarkMode = true;
  bool _enableAnimations = true;

  bool _preferencesLoaded = false;

  bool get preferencesLoaded => _preferencesLoaded;

  ThemeService() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_darkModeKey) ?? true;
    _enableAnimations = prefs.getBool(_enableAnimationsKey) ?? true;
    _preferencesLoaded = true;
    notifyListeners();
  }

  Future<void> _saveBoolPreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Color get currentPrimaryColor => _primaryColor;

  Color get currentAccentColor => _accentColor;

  Color get currentBackgroundColor =>
      _isDarkMode ? _darkBackgroundColor : _lightBackgroundColor;

  Color get currentCardColor => _isDarkMode ? _darkCardColor : _lightCardColor;

  Color get currentTextColor => _isDarkMode ? _darkTextColor : _lightTextColor;

  Color get currentTextColorLow =>
      _isDarkMode ? _darkTextColor : _lightTextColor;

  List<BoxShadow> get neonShadow => [
        BoxShadow(
          color: _primaryColor,
          blurRadius: 4,
        )
      ];

  ThemeData get theme {
    if (_isDarkMode) {
      return ThemeData.dark().copyWith(
        scaffoldBackgroundColor: _darkBackgroundColor,
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.dark(
          primary: _primaryColor,
          secondary: _accentColor,
          surfaceTint: _darkBackgroundColor,
          surface: _darkCardColor,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: _darkTextColor,
          brightness: Brightness.dark,
        ),
        textTheme: ThemeData.dark()
            .textTheme
            .apply(
              bodyColor: _darkTextColor,
              displayColor: _darkTextColor,
            )
            .copyWith(
              displayLarge:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              displayMedium:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              bodyLarge: const TextStyle(fontSize: 16),
              bodyMedium: const TextStyle(fontSize: 14),
            ),
        cardTheme: CardThemeData(
          color: _darkCardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: _primaryColor.withAlpha((255 * 0.3).round()),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.black,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _primaryColor,
            side: BorderSide(color: _primaryColor, width: 2),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: _primaryColor,
          inactiveTrackColor: _primaryColor.withAlpha((255 * 0.3).round()),
          thumbColor: _accentColor,
          valueIndicatorColor: _accentColor,
          overlayColor: _primaryColor.withAlpha((255 * 0.2).round()),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: _darkBackgroundColor,
          elevation: 0,
          titleTextStyle: TextStyle(
              color: _darkTextColor, fontSize: 20, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: _primaryColor),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: _darkBackgroundColor,
          selectedItemColor: _primaryColor,
          unselectedItemColor: Colors.grey[600],
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return _accentColor;
            }
            return null;
          }),
          trackColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return _primaryColor.withAlpha((255 * 0.5).round());
            }
            return null;
          }),
        ),
      );
    } else {
      return ThemeData.light().copyWith(
        scaffoldBackgroundColor: _lightBackgroundColor,
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.light(
          primary: _primaryColor,
          secondary: _accentColor,
          surfaceTint: _lightBackgroundColor,
          surface: _lightCardColor,
          onPrimary: _darkTextColor,
          onSecondary: _darkTextColor,
          onSurface: _lightTextColor,
          brightness: Brightness.light,
        ),
        textTheme: ThemeData.light()
            .textTheme
            .apply(
              bodyColor: _lightTextColor,
              displayColor: _lightTextColor,
            )
            .copyWith(
              displayLarge: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor),
              displayMedium: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor),
              bodyLarge: const TextStyle(fontSize: 16),
              bodyMedium: const TextStyle(fontSize: 14),
            ),
        cardTheme: CardThemeData(
          color: _lightCardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: Colors.grey.withAlpha((255 * 0.5).round()),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: _darkTextColor,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _primaryColor,
            side: BorderSide(color: _primaryColor, width: 2),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: _primaryColor,
          inactiveTrackColor: _primaryColor.withAlpha((255 * 0.3).round()),
          thumbColor: _accentColor,
          valueIndicatorColor: _accentColor,
          overlayColor: _primaryColor.withAlpha((255 * 0.2).round()),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: _lightBackgroundColor,
          elevation: 0,
          titleTextStyle: TextStyle(
              color: _lightTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: _primaryColor),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: _lightCardColor,
          selectedItemColor: _primaryColor,
          unselectedItemColor: Colors.grey[700],
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return _accentColor;
            }
            return null;
          }),
          trackColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return _primaryColor.withAlpha((255 * 0.5).round());
            }
            return null;
          }),
        ),
      );
    }
  }

  bool get isDarkMode => _isDarkMode;

  set isDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      _saveBoolPreference(_darkModeKey, value);
      notifyListeners();
    }
  }

  bool get enableAnimations => _enableAnimations;

  set enableAnimations(bool value) {
    if (_enableAnimations != value) {
      _enableAnimations = value;
      _saveBoolPreference(_enableAnimationsKey, value);
      notifyListeners();
    }
  }

  List<Color> _primaryGradient = [
    const Color(0xff633b9c),
    const Color(0xff344066),
    const Color(0xff415fdd),
    const Color(0xffa13ff3),
  ];

  List<Color> get primaryGradient => _primaryGradient;

  set primaryGradient(List<Color> value) {
    _primaryGradient = value;
    notifyListeners();
  }
}
