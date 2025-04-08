import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/bmi_record.dart';
import '../services/theme_service.dart';

class ResultCard extends StatelessWidget {
  final BMIRecord bmiRecord;
  final bool enableAnimations;

  const ResultCard({
    Key? key,
    required this.bmiRecord,
    required this.enableAnimations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final primaryColor = themeService.currentPrimaryColor;
    final accentColor = themeService.currentAccentColor;

    final categoryColor = bmiRecord.getCategoryColor();
    final dateFormat = DateFormat('MMM dd, yyyy');
    int totalInches = (bmiRecord.height / 2.54).round();
    int feet = totalInches ~/ 12;
    int inches = totalInches % 12;

    Widget resultHeader = Text(
      'YOUR RESULT',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: themeService.currentTextColor,
      ),
      textAlign: TextAlign.center,
    );
    if (enableAnimations) {
      resultHeader = resultHeader.animate().fadeIn(duration: 400.ms);
    }

    Widget bmiValueText = Center(
      child: Text(
        bmiRecord.bmiValue.toStringAsFixed(1),
        style: TextStyle(
          fontSize: 70,
          fontWeight: FontWeight.bold,
          color: primaryColor,
          shadows: [
            Shadow(
              color: primaryColor.withAlpha((255 * 0.6).round()),
              blurRadius: 10,
            ),
          ],
        ),
      ),
    );
    if (enableAnimations) {
      bmiValueText = bmiValueText.animate().scale(
            duration: 600.ms,
            delay: 200.ms,
            curve: Curves.elasticOut,
          );
    }

    Widget categoryDisplay = Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: categoryColor,
          border: Border.all(
            color: categoryColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withAlpha((255 * 0.3).round()),
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
            color: (categoryColor.computeLuminance() > 0.5)
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
    );
    if (enableAnimations) {
      categoryDisplay = categoryDisplay
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
          );
    }

    Widget heightDetail = _buildDetailRow(
      label: 'Height',
      value: '${feet}\' ${inches}"',
      icon: Icons.height,
      primaryColor: primaryColor,
      themeService: themeService,
    );
    if (enableAnimations) {
      heightDetail = heightDetail.animate().fadeIn(
            duration: 400.ms,
            delay: 800.ms,
          );
    }

    Widget weightDetail = _buildDetailRow(
      label: 'Weight',
      value: '${bmiRecord.weight.toStringAsFixed(1)} kg',
      icon: Icons.fitness_center,
      primaryColor: primaryColor,
      themeService: themeService,
    );
    if (enableAnimations) {
      weightDetail = weightDetail.animate().fadeIn(
            duration: 400.ms,
            delay: 900.ms,
          );
    }

    Widget ageDetail = _buildDetailRow(
      label: 'Age',
      value: '${bmiRecord.age} years',
      icon: Icons.cake,
      primaryColor: primaryColor,
      themeService: themeService,
    );
    if (enableAnimations) {
      ageDetail = ageDetail.animate().fadeIn(
            duration: 400.ms,
            delay: 1000.ms,
          );
    }

    Widget genderDetail = _buildDetailRow(
      label: 'Gender',
      value: bmiRecord.gender.name[0].toUpperCase() +
          bmiRecord.gender.name.substring(1),
      icon: bmiRecord.gender == Gender.male ? Icons.male : Icons.female,
      primaryColor: primaryColor,
      themeService: themeService,
    );
    if (enableAnimations) {
      genderDetail = genderDetail.animate().fadeIn(
            duration: 400.ms,
            delay: 1100.ms,
          );
    }

    Widget dateDetail = _buildDetailRow(
      label: 'Date',
      value: dateFormat.format(bmiRecord.date),
      icon: Icons.calendar_today,
      primaryColor: primaryColor,
      themeService: themeService,
    );
    if (enableAnimations) {
      dateDetail = dateDetail.animate().fadeIn(
            duration: 400.ms,
            delay: 1200.ms,
          );
    }

    Widget recommendationBox = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha((255 * 0.4).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withAlpha((255 * 0.3).round()),
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
              color: themeService.currentTextColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
    if (enableAnimations) {
      recommendationBox = recommendationBox.animate().fadeIn(
            duration: 600.ms,
            delay: 1400.ms,
          );
    }

    return Container(
      margin: EdgeInsets.all(15),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeService.currentCardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.3).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: categoryColor.withAlpha((255 * 0.2).round()),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          resultHeader,
          const SizedBox(height: 24),
          bmiValueText,
          const SizedBox(height: 16),
          categoryDisplay,
          const SizedBox(height: 32),
          heightDetail,
          const SizedBox(height: 12),
          weightDetail,
          const SizedBox(height: 12),
          ageDetail,
          const SizedBox(height: 12),
          genderDetail,
          const SizedBox(height: 12),
          dateDetail,
          const SizedBox(height: 32),
          recommendationBox,
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required IconData icon,
    required Color primaryColor,
    required ThemeService themeService,
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
            color: themeService.currentTextColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color:
                  themeService.currentTextColor.withAlpha((255 * 0.85).round()),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
