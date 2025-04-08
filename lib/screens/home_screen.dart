import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../models/bmi_record.dart';
import '../services/bmi_database.dart';
import '../services/sound_service.dart';
import '../services/theme_service.dart';
import '../widgets/gender_select_widget.dart';
import '../widgets/height_input_widget.dart';
import '../widgets/weight_age_widget.dart';
import '../widgets/result_card.dart';
import 'package:neon_bmi_calculator/screens/help_screen.dart';
import 'package:neon_bmi_calculator/screens/history_screen.dart';
import 'package:neon_bmi_calculator/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Gender _gender = Gender.male;
  double _height = 170;
  double _weight = 70;
  double _age = 25.0;

  bool _showResult = false;
  BMIRecord? _currentRecord;

  final BMIDatabase _database = BMIDatabase();

  @override
  void initState() {
    super.initState();
    _loadLatestRecord();
  }

  Future<void> _loadLatestRecord() async {
    final latestRecord = _database.getLatestRecord();
    if (latestRecord != null) {
      if (mounted) {
        setState(() {
          _gender = latestRecord.gender;
          _height = latestRecord.height;
          _weight = latestRecord.weight;
          _age = latestRecord.age.toDouble();
        });
      }
    }
  }

  void _calculateBMI() {
    final soundService = Provider.of<SoundService>(context, listen: false);
    final bmiRecord = BMIRecord.calculate(
      height: _height,
      weight: _weight,
      age: _age.round(),
      gender: _gender,
    );

    Provider.of<BMIDatabase>(context, listen: false).addRecord(bmiRecord);

    setState(() {
      soundService.playResultSound();
      _currentRecord = bmiRecord;
      _showResult = true;
    });
  }

  void _resetCalculator() {
    final soundService = Provider.of<SoundService>(context, listen: false);
    setState(() {
      soundService.playResultSound();
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();

    Widget screenContent;
    if (_showResult) {
      screenContent = _buildResultScreen(themeService.enableAnimations);
    } else {
      screenContent = _buildInputScreen(themeService.enableAnimations);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: screenContent,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool enableAnimations) {
    Widget appBarContent = Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.purple, Colors.blue],
                    ).createShader(bounds),
                    child: const Text(
                      'NeonFit',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'BMI',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Calculate your Body Mass Index',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(Icons.show_chart, Colors.green, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HistoryScreen()));
                  }),
                  const SizedBox(width: 12),
                  _buildIconButton(Icons.settings, Colors.purple, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen()));
                  }),
                  const SizedBox(width: 12),
                  _buildIconButton(Icons.help_outline, Colors.blue, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HelpScreen()));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (enableAnimations) {
      return appBarContent.animate().fadeIn(duration: 400.ms);
    }
    return appBarContent;
  }

  Widget _buildInputScreen(bool enableAnimations) {
    Widget calculateButton = Container(
      margin: const EdgeInsets.all(10),
      child: OutlinedButton(
        onPressed: _calculateBMI,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'CALCULATE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    if (enableAnimations) {
      calculateButton = calculateButton
          .animate()
          .fadeIn(
            duration: 400.ms,
            delay: 600.ms,
          )
          .moveY(
            begin: 30,
            end: 0,
            duration: 500.ms,
            delay: 600.ms,
            curve: Curves.easeOutQuad,
          );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAppBar(enableAnimations),
        const SizedBox(height: 24),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: GenderSelectWidget(
            selectedGender: _gender,
            onGenderChanged: (gender) {
              setState(() {
                _gender = gender;
              });
            },
          ),
        ),
        const SizedBox(height: 24),
        HeightInputWidget(
          height: _height,
          onHeightChanged: (height) {
            setState(() {
              _height = height;
            });
          },
        ),
        const SizedBox(height: 24),
        WeightAgeWidget(
          weight: _weight,
          age: _age,
          onWeightChanged: (weight) {
            setState(() {
              _weight = weight;
            });
          },
          onAgeChanged: (age) {
            setState(() {
              _age = age;
            });
          },
        ),
        const SizedBox(height: 10),
        calculateButton,
      ],
    );
  }

  Widget _buildResultScreen(bool enableAnimations) {
    if (_currentRecord == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    Widget reCalculateButton = Container(
      margin: const EdgeInsets.all(10),
      child: OutlinedButton(
        onPressed: _resetCalculator,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'RE-CALCULATE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    if (enableAnimations) {
      reCalculateButton = reCalculateButton.animate().fadeIn(
            duration: 400.ms,
            delay: 1800.ms,
          );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAppBar(enableAnimations),
        const SizedBox(height: 24),
        ResultCard(
            bmiRecord: _currentRecord!, enableAnimations: enableAnimations),
        const SizedBox(height: 20),
        reCalculateButton,
      ],
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: () {
        final soundService = Provider.of<SoundService>(context, listen: false);
        soundService.playToggleSound();
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withAlpha((255 * 0.2).round()),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withAlpha((255 * 0.5).round()),
              blurRadius: 4,
              spreadRadius: 0.4,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
