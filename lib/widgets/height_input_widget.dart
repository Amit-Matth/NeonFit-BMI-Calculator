import 'package:flutter/material.dart';
import 'package:neon_bmi_calculator/widgets/rectangular_slider_thumb_shape.dart';
import 'package:provider/provider.dart';
import '../services/sound_service.dart';
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
    final primaryColor = themeService.currentPrimaryColor;
    final accentColor = themeService.currentAccentColor;

    final int feet = (height / 30.48).floor();
    final int inches = ((height - feet * 30.48) / 2.54).round();

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Height',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeightCard(
                  label: 'Feet',
                  value: feet,
                  min: 0,
                  max: 9,
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
                  max: 12,
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
      ),
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
    final themeService = Provider.of<ThemeService>(context);
    final gradient = LinearGradient(
      colors: [primaryColor, accentColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final soundService = Provider.of<SoundService>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: themeService.currentCardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor,
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: themeService.currentTextColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      label == 'Feet' ? "$value'" : '$value"',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 12,
              thumbShape: RectangularSliderThumbShape(thumbSize: Size(15, 40)),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
              thumbColor: primaryColor,
            ),
            child: Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: max,
              onChanged: (double newValue) {
                soundService.playSlideSound();
                onChanged(newValue.round());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label == 'Feet' ? "$min'" : '$min"',
                      style: TextStyle(color: themeService.currentTextColor),
                    ),
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label == 'Feet' ? "$max'" : '$max"',
                      style: TextStyle(color: themeService.currentTextColor),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
