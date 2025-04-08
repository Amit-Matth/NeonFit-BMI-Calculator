import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/services/theme_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final isDarkMode = themeService.isDarkMode;
    final useMetric = themeService.useMetric;
    final enableAnimations = themeService.enableAnimations;
    final enableSounds = themeService.enableSounds;
    final primaryGradient = themeService.primaryGradient;

    Widget content = Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: primaryGradient,
          ).createShader(bounds),
          child: const Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: primaryGradient[0],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Display settings section
            _buildSectionHeader('Display', Icons.palette_outlined),
            const SizedBox(height: 16),
            _buildSettingSwitch(
              title: 'Dark Mode',
              subtitle: 'Use dark color scheme',
              icon: Icons.dark_mode_outlined,
              value: isDarkMode,
              onChanged: (value) {
                themeService.isDarkMode = value;
              },
              gradientColors: primaryGradient,
            ),
            const SizedBox(height: 16),
            _buildSettingSwitch(
              title: 'Animations',
              subtitle: 'Enable animations throughout the app',
              icon: Icons.animation_outlined,
              value: enableAnimations,
              onChanged: (value) {
                themeService.enableAnimations = value;
              },
              gradientColors: primaryGradient,
            ),

            const SizedBox(height: 32),

            // Units section
            _buildSectionHeader('Units', Icons.straighten_outlined),
            const SizedBox(height: 16),
            _buildSettingSwitch(
              title: 'Use Metric System',
              subtitle:
                  'Use kilograms and centimeters instead of pounds and inches',
              icon: Icons.scale_outlined,
              value: useMetric,
              onChanged: (value) {
                themeService.useMetric = value;
              },
              gradientColors: primaryGradient,
            ),

            const SizedBox(height: 32),

            // Sound settings section
            _buildSectionHeader('Sound', Icons.volume_up_outlined),
            const SizedBox(height: 16),
            _buildSettingSwitch(
              title: 'Sound Effects',
              subtitle: 'Play sound effects during interactions',
              icon: Icons.music_note_outlined,
              value: enableSounds,
              onChanged: (value) {
                themeService.enableSounds = value;
              },
              gradientColors: primaryGradient,
            ),

            const SizedBox(height: 32),

            // App information section
            _buildSectionHeader('About', Icons.info_outline),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'NeonFit BMI Calculator',
              subtitle: 'Version 1.0.0',
              icon: Icons.fitness_center,
              gradientColors: primaryGradient,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'Developer',
              subtitle: 'Created with Flutter',
              icon: Icons.code,
              gradientColors: primaryGradient,
            ),

            const SizedBox(height: 40),

            // Reset to defaults button
            Center(
              child: TextButton.icon(
                icon: Icon(
                  Icons.refresh,
                  color: primaryGradient[0],
                ),
                label: Text(
                  'Reset to Defaults',
                  style: TextStyle(
                    color: primaryGradient[0],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  _showResetConfirmationDialog(context, themeService);
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (enableAnimations) {
      return content.animate().fadeIn(
            duration: const Duration(milliseconds: 300),
          );
    }

    return content;
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[400],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Divider(
            color: Colors.grey[800],
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingSwitch({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    required List<Color> gradientColors,
  }) {
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
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  gradientColors[0].withOpacity(0.2),
                  gradientColors[1].withOpacity(0.2),
                ],
              ),
            ),
            child: Icon(
              icon,
              color: value ? gradientColors[0] : Colors.grey[500],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: value ? Colors.white : Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: gradientColors[0],
            inactiveThumbColor: Colors.grey[300],
            inactiveTrackColor: Colors.grey[700],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
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
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  gradientColors[0].withOpacity(0.2),
                  gradientColors[1].withOpacity(0.2),
                ],
              ),
            ),
            child: Icon(
              icon,
              color: gradientColors[0],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showResetConfirmationDialog(
      BuildContext context, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Reset Settings',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to reset all settings to their default values?',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Reset',
                style: TextStyle(
                  color: themeService.primaryGradient[0],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                // Reset all settings to default
                themeService.isDarkMode = true;
                themeService.useMetric = false;
                themeService.enableAnimations = true;
                themeService.enableSounds = true;

                Navigator.of(context).pop();

                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Settings reset to defaults',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green[700],
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
