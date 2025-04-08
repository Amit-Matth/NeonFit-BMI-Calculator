import 'package:flutter/material.dart';
import '/services/theme_service.dart';
import 'package:provider/provider.dart';

class WeightInputWidget extends StatelessWidget {
  final double weight;
  final Function(double) onWeightChanged;

  const WeightInputWidget({
    super.key,
    required this.weight,
    required this.onWeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final useMetric = themeService.useMetric;
    final primaryGradient = themeService.primaryGradient;

    // Convert kg to lb if needed for display
    final displayWeight = useMetric ? weight : weight * 2.20462;
    final weightUnit = useMetric ? 'kg' : 'lb';

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
            'Weight',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryGradient[0],
            ),
          ),

          const SizedBox(height: 16),

          // Weight display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                displayWeight.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                weightUnit,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Weight adjustment buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Subtract big button
              _buildAdjustButton(
                context,
                Icons.remove_circle_outline,
                () {
                  final newWeight = weight - 5;
                  if (newWeight >= 20) {
                    onWeightChanged(newWeight);
                  }
                },
                primaryGradient[0],
                isLarge: true,
              ),

              // Subtract small button
              _buildAdjustButton(
                context,
                Icons.remove,
                () {
                  final newWeight = weight - 0.1;
                  if (newWeight >= 20) {
                    onWeightChanged(newWeight);
                  }
                },
                primaryGradient[0],
              ),

              // Add small button
              _buildAdjustButton(
                context,
                Icons.add,
                () {
                  final newWeight = weight + 0.1;
                  if (newWeight <= 250) {
                    onWeightChanged(newWeight);
                  }
                },
                primaryGradient[1],
              ),

              // Add big button
              _buildAdjustButton(
                context,
                Icons.add_circle_outline,
                () {
                  final newWeight = weight + 5;
                  if (newWeight <= 250) {
                    onWeightChanged(newWeight);
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
              activeTrackColor: primaryGradient[0],
              inactiveTrackColor: Colors.grey[800],
              thumbColor: primaryGradient[0],
              overlayColor: primaryGradient[0].withOpacity(0.2),
              trackHeight: 4,
            ),
            child: Slider(
              min: 20,
              max: 250,
              value: weight,
              onChanged: (value) {
                onWeightChanged(value);
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
