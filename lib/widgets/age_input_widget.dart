import 'package:flutter/material.dart';
import '/services/theme_service.dart';
import 'package:provider/provider.dart';

class AgeInputWidget extends StatelessWidget {
  final int age;
  final Function(int) onAgeChanged;

  const AgeInputWidget({
    super.key,
    required this.age,
    required this.onAgeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final primaryGradient = themeService.primaryGradient;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[900]!.withOpacity(0.7),
            Colors.grey[850]!.withOpacity(0.7),
          ],
        ),
        border: Border.all(
          color: Colors.grey[800]!.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          Text(
            'Age',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryGradient[0],
            ),
          ),

          const SizedBox(height: 16),

          // Age display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                age.toString(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'years',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Age adjustment buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Subtract button
              _buildAdjustButton(
                context,
                Icons.remove_circle_outline,
                () {
                  final newAge = age - 1;
                  if (newAge >= 1) {
                    onAgeChanged(newAge);
                  }
                },
                primaryGradient[0],
                isLarge: true,
              ),

              // Add button
              _buildAdjustButton(
                context,
                Icons.add_circle_outline,
                () {
                  final newAge = age + 1;
                  if (newAge <= 120) {
                    onAgeChanged(newAge);
                  }
                },
                primaryGradient[1],
                isLarge: true,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: primaryGradient[1],
              inactiveTrackColor: Colors.grey[800],
              thumbColor: primaryGradient[1],
              overlayColor: primaryGradient[1].withOpacity(0.2),
              trackHeight: 4,
            ),
            child: Slider(
              min: 1,
              max: 120,
              value: age.toDouble(),
              onChanged: (value) {
                onAgeChanged(value.toInt());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
    Color color, {
    bool isLarge = false,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(isLarge ? 30 : 20),
      child: Container(
        width: isLarge ? 50 : 40,
        height: isLarge ? 50 : 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[850],
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: isLarge ? 30 : 24,
        ),
      ),
    );
  }
}
