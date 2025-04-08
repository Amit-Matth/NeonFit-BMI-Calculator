import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/bmi_record.dart';
import '../services/theme_service.dart';

class ResultCard extends StatelessWidget {
  final BMIRecord bmiRecord;

  const ResultCard({
    Key? key,
    required this.bmiRecord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final primaryColor = themeService.primaryColor;
    final accentColor = themeService.accentColor;

    final categoryColor = bmiRecord.getCategoryColor();
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1D1D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: categoryColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Result header
          Text(
            'YOUR RESULT',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 24),

          // BMI Value
          Center(
            child: Text(
              bmiRecord.bmiValue.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                shadows: [
                  Shadow(
                    color: primaryColor.withOpacity(0.6),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ).animate().scale(
                duration: 600.ms,
                delay: 200.ms,
                curve: Curves.elasticOut,
              ),

          const SizedBox(height: 16),

          // Category
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: categoryColor.withOpacity(0.2),
                border: Border.all(
                  color: categoryColor,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: categoryColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                bmiRecord.category.toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: categoryColor,
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(
                duration: 600.ms,
                delay: 400.ms,
              )
              .moveY(
                begin: 20,
                end: 0,
                duration: 600.ms,
                delay: 400.ms,
                curve: Curves.easeOutQuad,
              ),

          const SizedBox(height: 32),

          // User details
          _buildDetailRow(
            'Height',
            '${bmiRecord.height.toStringAsFixed(0)} cm',
            icon: Icons.height,
            primaryColor: primaryColor,
          ).animate().fadeIn(
                duration: 400.ms,
                delay: 800.ms,
              ),

          const SizedBox(height: 12),

          _buildDetailRow(
            'Weight',
            '${bmiRecord.weight.toStringAsFixed(1)} kg',
            icon: Icons.fitness_center,
            primaryColor: primaryColor,
          ).animate().fadeIn(
                duration: 400.ms,
                delay: 900.ms,
              ),

          const SizedBox(height: 12),

          _buildDetailRow(
            'Age',
            '${bmiRecord.age} years',
            icon: Icons.cake,
            primaryColor: primaryColor,
          ).animate().fadeIn(
                duration: 400.ms,
                delay: 1000.ms,
              ),

          const SizedBox(height: 12),

          _buildDetailRow(
            'Gender',
            bmiRecord.gender.name[0].toUpperCase() +
                bmiRecord.gender.name.substring(1), // Capitalized
            icon: bmiRecord.gender == Gender.male ? Icons.male : Icons.female,
            primaryColor: primaryColor,
          ).animate().fadeIn(
                duration: 400.ms,
                delay: 1100.ms,
              ),

          const SizedBox(height: 12),

          _buildDetailRow(
            'Date',
            dateFormat.format(bmiRecord.date),
            icon: Icons.calendar_today,
            primaryColor: primaryColor,
          ).animate().fadeIn(
                duration: 400.ms,
                delay: 1200.ms,
              ),
          const SizedBox(height: 32),

          // Recommendation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: accentColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: accentColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'RECOMMENDATION',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  bmiRecord.getRecommendation(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[300],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(
                duration: 600.ms,
                delay: 1400.ms,
              ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    required IconData icon,
    required Color primaryColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: primaryColor,
        ),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[200],
          ),
        ),
      ],
    );
  }
}

// Extension method to capitalize a string
extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
