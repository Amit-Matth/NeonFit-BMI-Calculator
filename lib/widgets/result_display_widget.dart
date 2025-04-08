import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/models/bmi_record.dart';
import '/services/theme_service.dart';
import 'package:provider/provider.dart';

class ResultDisplayWidget extends StatelessWidget {
  final BMIRecord result;
  final VoidCallback onSaveToHistory;
  final bool showSaveButton;

  const ResultDisplayWidget({
    super.key,
    required this.result,
    required this.onSaveToHistory,
    this.showSaveButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final enableAnimations = themeService.enableAnimations;

    // Get category color
    final categoryColor = result.getCategoryColor();

    // Percentile position (from 0 to 100)
    final percentilePosition = result.percentilePosition;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // BMI Value and Category
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                categoryColor.withOpacity(0.7),
                categoryColor.withOpacity(0.5),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: categoryColor.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              // BMI Value
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.bmiValue.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  const Text(
                    'BMI',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Category
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Text(
                  result.category,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Percentile scale
        _buildPercentileScale(percentilePosition, categoryColor),

        const SizedBox(height: 32),

        // Health advice
        _buildHealthAdvice(result.category, categoryColor),

        const SizedBox(height: 32),

        // Measurement details
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[900],
            border: Border.all(
              color: Colors.grey[800]!,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Your Measurements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: categoryColor,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildMeasurementItem(
                      'Height',
                      '${result.height}\'${result.height}"',
                      Icons.height,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMeasurementItem(
                      'Weight',
                      '${result.weight.toStringAsFixed(1)} kg',
                      Icons.fitness_center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMeasurementItem(
                      'Age',
                      '${result.age} years',
                      Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMeasurementItem(
                      'Gender',
                      result.gender.toString().split('.').last,
                      result.gender == Gender.male ? Icons.male : Icons.female,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (showSaveButton) ...[
          const SizedBox(height: 32),

          // Save button
          ElevatedButton.icon(
            icon: const Icon(Icons.save_alt),
            label: const Text('Save to History'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: categoryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onSaveToHistory,
          ),
        ],
      ],
    );

    if (enableAnimations) {
      return content
          .animate()
          .fadeIn(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
          )
          .slide(
            begin: const Offset(0, 0.1),
            end: const Offset(0, 0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          );
    }

    return content;
  }

  Widget _buildPercentileScale(double percentilePosition, Color categoryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'BMI Percentile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: categoryColor,
              ),
            ),
            Text(
              '${percentilePosition.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              colors: [
                Colors.blue, // Underweight
                Colors.green, // Normal
                Colors.amber, // Overweight
                Colors.orange, // Obese
                Colors.red, // Extremely Obese
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Marker
                  Positioned(
                    left: constraints.maxWidth * (percentilePosition / 100) - 6,
                    top: -4,
                    child: Container(
                      width: 12,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Underweight',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),
            Text(
              'Normal',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
              ),
            ),
            Text(
              'Overweight',
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber,
              ),
            ),
            Text(
              'Obese',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthAdvice(String category, Color categoryColor) {
    final advice = result.getRecommendation();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            categoryColor.withOpacity(0.2),
            categoryColor.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: categoryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates,
                color: categoryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Health Insight',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: categoryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            advice,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[850]!.withOpacity(0.7),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.grey[500],
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
