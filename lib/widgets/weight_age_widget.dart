import 'package:flutter/material.dart';
import 'package:neon_bmi_calculator/widgets/rectangular_slider_thumb_shape.dart';
import 'package:provider/provider.dart';
import '../services/sound_service.dart';
import '../services/theme_service.dart';

enum SliderPosition { left, right }

class WeightAgeWidget extends StatelessWidget {
  final double weight;
  final double age;
  final Function(double) onWeightChanged;
  final Function(double) onAgeChanged;

  const WeightAgeWidget({
    Key? key,
    required this.weight,
    required this.age,
    required this.onWeightChanged,
    required this.onAgeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: _InputCard(
              label: 'Weight',
              value: weight.toStringAsFixed(1),
              unit: 'kg',
              sliderPosition: SliderPosition.right,
              sliderValue: weight,
              sliderMin: 20.0,
              sliderMax: 200.0,
              sliderDivisions: (200 - 20) * 2,
              onSliderChanged: onWeightChanged,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _InputCard(
              label: 'Age',
              value: age.toStringAsFixed(1),
              unit: 'yrs',
              sliderPosition: SliderPosition.left,
              sliderValue: age,
              sliderMin: 1.0,
              sliderMax: 150.0,
              sliderDivisions: (150 - 1) * 2,
              onSliderChanged: onAgeChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final SliderPosition sliderPosition;
  final double sliderValue;
  final double sliderMin;
  final double sliderMax;
  final int sliderDivisions;
  final Function(double) onSliderChanged;

  const _InputCard({
    Key? key,
    required this.label,
    required this.value,
    required this.unit,
    required this.sliderPosition,
    required this.sliderValue,
    required this.sliderMin,
    required this.sliderMax,
    required this.sliderDivisions,
    required this.onSliderChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final soundService = Provider.of<SoundService>(context, listen: false);
    final primaryColor = themeService.currentPrimaryColor;
    final accentColor = themeService.currentAccentColor;
    final gradient = LinearGradient(
      colors: [primaryColor, accentColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    CrossAxisAlignment contentAlignment = sliderPosition == SliderPosition.right
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.end;

    Widget contentWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: contentAlignment,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: themeService.currentTextColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            this.value,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: primaryColor.withAlpha((255 * 0.3).round()),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor,
                  blurRadius: 2,
                ),
              ],
            ),
            child: Text(
              unit,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );

    Widget sliderWidget = Expanded(
      child: RotatedBox(
        quarterTurns: 3,
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 12,
            thumbShape:
                RectangularSliderThumbShape(thumbSize: const Size(15, 40)),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
            thumbColor: primaryColor,
            activeTrackColor: primaryColor,
            inactiveTrackColor: primaryColor.withAlpha((255 * 0.3).round()),
            valueIndicatorColor: accentColor,
          ),
          child: Slider(
            value: sliderValue,
            min: sliderMin,
            max: sliderMax,
            divisions: sliderDivisions,
            onChanged: (double newValue) {
              onSliderChanged(newValue);
            },
            onChangeEnd: (double newValue) {
              soundService.playSlideSound();
            },
          ),
        ),
      ),
    );

    List<Widget> children;
    if (sliderPosition == SliderPosition.left) {
      children = [
        sliderWidget,
        const SizedBox(width: 8),
        Expanded(child: contentWidget),
      ];
    } else {
      children = [
        Expanded(child: contentWidget),
        const SizedBox(width: 8),
        sliderWidget,
      ];
    }

    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: themeService.currentCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: primaryColor.withAlpha((255 * 0.5).round()), width: 1),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withAlpha(themeService.isDarkMode
                ? (255 * 0.6).round()
                : (255 * 0.4).round()),
            blurRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
