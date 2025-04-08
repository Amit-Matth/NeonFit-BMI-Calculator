import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neon_bmi_calculator/services/sound_service.dart';
import '/models/bmi_record.dart';
import '/services/bmi_database.dart';
import '/services/theme_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final BMIDatabase _bmiDatabase = BMIDatabase();

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final soundService = Provider.of<SoundService>(context);
    final enableAnimations = themeService.enableAnimations;
    final primaryGradient = themeService.primaryGradient;
    final recordCount = _bmiDatabase.recordCount;

    return Scaffold(
      backgroundColor: themeService.currentBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGradient[0]),
          onPressed: () {
            final soundService = Provider.of<SoundService>(context, listen: false);
            soundService.playToggleSound();
            Navigator.of(context).pop();
          },
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: primaryGradient,
          ).createShader(bounds),
          child: Text(
            'BMI History ($recordCount)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: themeService.currentTextColor,
            ),
          ),
        ),
        backgroundColor: themeService.currentBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: primaryGradient[0],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline,
                color: themeService.currentTextColor
                    .withAlpha((255 * 0.7).round())),
            onPressed: () {
              _showClearHistoryDialog(context, themeService);
              soundService.playResetSound();
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<BMIRecord>('bmi_Records').listenable(),
        builder: (context, box, _) {
          final records = box.values.toList().cast<BMIRecord>();
          records.sort((a, b) => b.date.compareTo(a.date));

          if (records.isEmpty) {
            return _buildEmptyState(enableAnimations, themeService);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              int totalInches = (record.height / 2.54).round();
              int feet = totalInches ~/ 12;
              int inches = totalInches % 12;

              final Widget item = _buildHistoryItem(
                  record, context, themeService, soundService, feet, inches);

              if (enableAnimations) {
                return item
                    .animate(
                      delay: Duration(milliseconds: index * 50),
                    )
                    .fadeIn(
                      duration: const Duration(milliseconds: 500),
                    )
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                    );
              }
              return item;
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryItem(
      BMIRecord record,
      BuildContext context,
      ThemeService themeService,
      SoundService soundService,
      int feet,
      int inches) {
    final dateFormat = DateFormat.yMMMd();
    final timeFormat = DateFormat.jm();
    final categoryColor = record.getCategoryColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: themeService.currentCardColor,
        border: Border.all(
          color: themeService.currentCardColor.withAlpha((255 * 0.5).round()),
          width: 1,
        ),
        boxShadow: themeService.neonShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _showRecordDetails(context, record, themeService, feet, inches);
            soundService.playTapSound();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${dateFormat.format(record.date)} at ${timeFormat.format(record.date)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: themeService.currentTextColor
                            .withAlpha((255 * 0.6).round()),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: categoryColor.withAlpha((255 * 0.2).round()),
                        border: Border.all(
                          color: categoryColor.withAlpha((255 * 0.3).round()),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        record.category,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            categoryColor.withAlpha((255 * 0.8).round()),
                            categoryColor.withAlpha((255 * 0.6).round()),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: categoryColor.withAlpha((255 * 0.3).round()),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          record.bmiValue.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(Icons.height, 'Height',
                              '${feet}\' ${inches}"', themeService),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                              Icons.fitness_center,
                              'Weight',
                              '${record.weight.toStringAsFixed(1)} kg',
                              themeService),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                              record.gender == Gender.male
                                  ? Icons.male
                                  : Icons.female,
                              'Gender',
                              record.gender.name,
                              themeService),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            Icons.cake,
                            'Age',
                            '${record.age} years',
                            themeService,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value, ThemeService themeService) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: themeService.currentTextColor.withAlpha((255 * 0.6).round()),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: themeService.currentTextColor.withAlpha((255 * 0.6).round()),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: themeService.currentTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool enableAnimations, ThemeService themeService) {
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: themeService.currentTextColor.withAlpha((255 * 0.4).round()),
          ),
          const SizedBox(height: 24),
          Text(
            'No BMI History Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color:
                  themeService.currentTextColor.withAlpha((255 * 0.8).round()),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Your BMI calculation history will appear here after you save your results.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: themeService.currentTextColor
                    .withAlpha((255 * 0.6).round()),
              ),
            ),
          ),
        ],
      ),
    );

    if (enableAnimations) {
      return content.animate().fadeIn(
            duration: const Duration(milliseconds: 600),
          );
    }
    return content;
  }

  void _showClearHistoryDialog(
      BuildContext context, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: themeService.currentCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Clear History',
            style: TextStyle(
              color: themeService.currentTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to clear all your BMI history? This action cannot be undone.',
            style: TextStyle(
              color:
                  themeService.currentTextColor.withAlpha((255 * 0.7).round()),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: themeService.currentTextColor
                      .withAlpha((255 * 0.6).round()),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(
                'Clear',
                style: TextStyle(
                  color: themeService.currentPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await _bmiDatabase.clearRecords();
                if (mounted) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'History cleared successfully',
                        style: TextStyle(
                            color: themeService.isDarkMode
                                ? Colors.black
                                : Colors.white),
                      ),
                      backgroundColor: themeService.currentPrimaryColor
                          .withAlpha((255 * 0.8).round()),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showRecordDetails(BuildContext context, BMIRecord record,
      ThemeService themeService, int feet, int inches) {
    final primaryGradient = themeService.primaryGradient;
    final categoryColor = record.getCategoryColor();
    final dateFormat = DateFormat.yMMMMd();
    final timeFormat = DateFormat.jm();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: themeService.currentCardColor,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'BMI Record Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: primaryGradient,
                              ).createShader(
                                  const Rect.fromLTWH(0, 0, 200, 70)),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: themeService.currentTextColor
                                .withAlpha((255 * 0.6).round()),
                          ),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: themeService.currentBackgroundColor
                            .withAlpha((255 * 0.5).round()),
                      ),
                      child: Text(
                        '${dateFormat.format(record.date)} at ${timeFormat.format(record.date)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeService.currentTextColor
                              .withAlpha((255 * 0.7).round()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            categoryColor.withAlpha((255 * 0.3).round()),
                            categoryColor.withAlpha((255 * 0.1).round()),
                          ],
                        ),
                        border: Border.all(
                          color: categoryColor.withAlpha((255 * 0.3).round()),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            record.bmiValue.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              height: 1,
                              foreground: Paint()
                                ..shader = LinearGradient(
                                  colors: [
                                    categoryColor,
                                    categoryColor
                                        .withAlpha((255 * 0.7).round()),
                                  ],
                                ).createShader(
                                    const Rect.fromLTWH(0, 0, 150, 60)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color:
                                  categoryColor.withAlpha((255 * 0.2).round()),
                            ),
                            child: Text(
                              record.category,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: categoryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMeasurementItem(
                            'Height',
                            '${feet}\' ${inches}"',
                            Icons.height,
                            themeService,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMeasurementItem(
                            'Weight',
                            '${record.weight.toStringAsFixed(1)} kg',
                            Icons.fitness_center,
                            themeService,
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
                            '${record.age} years',
                            Icons.calendar_today,
                            themeService,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMeasurementItem(
                            'Gender',
                            record.gender.name,
                            record.gender == Gender.male
                                ? Icons.male
                                : Icons.female,
                            themeService,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: themeService.currentBackgroundColor
                            .withAlpha((255 * 0.5).round()),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.tips_and_updates,
                                color: primaryGradient[0],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Health Insight',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryGradient[0],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            record.getRecommendation(),
                            style: TextStyle(
                              fontSize: 14,
                              color: themeService.currentTextColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget _buildMeasurementItem(
      String label, String value, IconData icon, ThemeService themeService) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:
            themeService.currentBackgroundColor.withAlpha((255 * 0.3).round()),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: themeService.currentTextColor.withAlpha((255 * 0.6).round()),
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
                  themeService.currentTextColor.withAlpha((255 * 0.6).round()),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: themeService.currentTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
