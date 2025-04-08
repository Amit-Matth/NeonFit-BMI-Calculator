import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../models/bmi_record.dart';
import '../services/bmi_database.dart';
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
  // Default values
  Gender _gender = Gender.male;
  double _height = 170; // cm
  double _weight = 70; // kg
  int _age = 25;

  // Result state
  bool _showResult = false;
  BMIRecord? _currentRecord;

  final BMIDatabase _database = BMIDatabase();

  @override
  void initState() {
    super.initState();
    // Load the latest record if available
    _loadLatestRecord();
  }

  Future<void> _loadLatestRecord() async {
    final latestRecord = _database.getLatestRecord();
    if (latestRecord != null) {
      setState(() {
        _gender = latestRecord.gender;
        _height = latestRecord.height;
        _weight = latestRecord.weight;
        _age = latestRecord.age;
      });
    }
  }

  void _calculateBMI() {
    final bmiRecord = BMIRecord.calculate(
      height: _height,
      weight: _weight,
      age: _age,
      gender: _gender,
    );

    // Save to database
    _database.addRecord(bmiRecord);

    setState(() {
      _currentRecord = bmiRecord;
      _showResult = true;
    });
  }

  void _resetCalculator() {
    setState(() {
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _showResult ? _buildResultScreen() : _buildInputScreen(),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final themeService = Provider.of<ThemeService>(context);

    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Left Side: NeonFit BMI text
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
                        color: Colors.white, // masked by shader
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

            // Right Side: Icon Buttons
            Row(
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
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildInputScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // App title
        _buildAppBar(),

        const SizedBox(height: 24),

        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildIconButton(Icons.calculate, Colors.purple, () {}),
              SizedBox(
                width: 6,
              ),
              Text(
                'BMI Calculator',
                style: TextStyle(color: Colors.white, fontSize: 28),
              )
            ],
          ),
        ),

        const SizedBox(
          height: 24,
        ),

        // Gender selection
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

        // Height slider        HeightInputWidget(          height: _height,          onHeightChanged: (height) {            setState(() {              _height = height;            });          },        ),
        const SizedBox(height: 24),

        // Weight and age inputs
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

        const SizedBox(height: 32),

        // Calculate button
        ElevatedButton(
          onPressed: _calculateBMI,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'CALCULATE',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
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
            ),
      ],
    );
  }

  Widget _buildResultScreen() {
    if (_currentRecord == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Result header
        _buildAppBar(),

        const SizedBox(height: 24),
//
        // Result card
        ResultCard(bmiRecord: _currentRecord!),

        const SizedBox(height: 32),

        // Re-calculate button
        OutlinedButton(
          onPressed: _resetCalculator,
          child: const Text(
            'RE-CALCULATE',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ).animate().fadeIn(
              duration: 400.ms,
              delay: 1800.ms,
            ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.5),
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
