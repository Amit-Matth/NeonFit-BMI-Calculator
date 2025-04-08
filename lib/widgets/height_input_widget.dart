import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class HeightInputWidget extends StatelessWidget {
  final double height;
  final Function(double) onHeightChanged;

  const HeightInputWidget({
    Key? key,
    required this.height,
    required this.onHeightChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final primaryColor = themeService.primaryColor;
    final accentColor = themeService.accentColor;

    final int feet = (height / 30.48).floor();
    final int inches = ((height - feet * 30.48) / 2.54).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Height',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _HeightCard(
                label: 'Feet',
                value: feet,
                min: 1,
                max: 8,
                primaryColor: primaryColor,
                accentColor: accentColor,
                onChanged: (int newFeet) {
                  final double newHeight = newFeet * 30.48 + inches * 2.54;
                  onHeightChanged(newHeight);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _HeightCard(
                label: 'Inches',
                value: inches,
                min: 0,
                max: 11,
                primaryColor: primaryColor,
                accentColor: accentColor,
                onChanged: (int newInches) {
                  final double newHeight = feet * 30.48 + newInches * 2.54;
                  onHeightChanged(newHeight);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeightCard extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final Color primaryColor;
  final Color accentColor;
  final Function(int) onChanged;

  const _HeightCard({
    Key? key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.primaryColor,
    required this.accentColor,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [primaryColor, accentColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1E1E2C), const Color(0xFF2C2C3A)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                child: Text(
                  label == 'Feet' ? "$value'" : '$value"',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent,
              thumbColor: Colors.white,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: gradient,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.6),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                Slider(
                  value: value.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: max - min,
                  onChanged: (double newValue) {
                    onChanged(newValue.round());
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label == 'Feet' ? "$min'" : '$min"',
                style: TextStyle(color: Colors.grey[500]),
              ),
              Text(
                label == 'Feet' ? "$max'" : '$max"',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
