import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/sound_service.dart';
import '/services/theme_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final soundService = Provider.of<SoundService>(context);
    final primaryGradient = themeService.primaryGradient;

    Widget content = Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGradient[0]),
          onPressed: () {
            final soundService =
                Provider.of<SoundService>(context, listen: false);
            soundService.playToggleSound();
            Navigator.of(context).pop();
          },
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: primaryGradient,
          ).createShader(bounds),
          child: Text(
            'Settings',
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
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSectionHeader(
                'Display', Icons.palette_outlined, context, themeService),
            const SizedBox(height: 16),
            _buildSettingSwitch(
              context: context,
              themeService: themeService,
              soundService: soundService,
              title: 'Dark Mode',
              subtitle: 'Use dark color scheme',
              icon: Icons.dark_mode_outlined,
              value: themeService.isDarkMode,
              onChanged: (value) {
                themeService.isDarkMode = value;
              },
              gradientColors: primaryGradient,
            ),
            const SizedBox(height: 16),
            _buildSettingSwitch(
              context: context,
              themeService: themeService,
              soundService: soundService,
              title: 'Animations',
              subtitle: 'Enable animations throughout the app',
              icon: Icons.animation_outlined,
              value: themeService.enableAnimations,
              onChanged: (value) {
                themeService.enableAnimations = value;
              },
              gradientColors: primaryGradient,
            ),
            const SizedBox(height: 32),
            _buildSectionHeader(
                'Sound', Icons.volume_up_outlined, context, themeService),
            const SizedBox(height: 16),
            _buildSettingSwitch(
              context: context,
              themeService: themeService,
              soundService: soundService,
              title: 'Sound Effects',
              subtitle: 'Play sound effects during interactions',
              icon: Icons.music_note_outlined,
              value: soundService.enableSounds,
              onChanged: (value) {
                soundService.enableSounds = value;
              },
              gradientColors: primaryGradient,
            ),
            const SizedBox(height: 32),
            _buildSectionHeader(
                'About', Icons.info_outline, context, themeService),
            const SizedBox(height: 16),
            _FlippingCard(
              themeService: themeService,
              soundService: soundService,
              child: _InfoCardContent(
                themeService: themeService,
                title: 'NeonFit BMI Calculator',
                subtitle: 'Version 1.0.0',
                icon: Icons.fitness_center,
                gradientColors: primaryGradient,
              ),
            ),
            const SizedBox(height: 16),
            _FlippingCard(
              themeService: themeService,
              soundService: soundService,
              child: _InfoCardContent(
                themeService: themeService,
                title: 'Developer',
                subtitle: 'Amit Matth',
                icon: Icons.code,
                gradientColors: primaryGradient,
              ),
            ),
            const SizedBox(height: 40),
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
                  soundService.playResetSound();
                  _showResetConfirmationDialog(
                      context, themeService, soundService);
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (themeService.enableAnimations) {
      content = content.animate().fadeIn(
            duration: const Duration(milliseconds: 300),
          );
    }
    return content;
  }

  Widget _buildSectionHeader(String title, IconData icon, BuildContext context,
      ThemeService themeService) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: themeService.currentTextColor.withAlpha((255 * 0.6).round()),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: themeService.currentTextColor.withAlpha((255 * 0.7).round()),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Divider(
            color: themeService.currentTextColor.withAlpha((255 * 0.2).round()),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingSwitch({
    required BuildContext context,
    required ThemeService themeService,
    required SoundService soundService,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    required List<Color> gradientColors,
  }) {
    final settingSwitchContent = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeService.currentCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeService.isDarkMode
              ? Colors.grey[700]!.withAlpha((255 * 0.5).round())
              : Colors.grey[400]!.withAlpha((255 * 0.5).round()),
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
                  gradientColors[0].withAlpha((255 * 0.2).round()),
                  gradientColors[1].withAlpha((255 * 0.2).round()),
                ],
              ),
            ),
            child: Icon(
              icon,
              color: value
                  ? gradientColors[0]
                  : themeService.currentTextColor
                      .withAlpha((255 * 0.6).round()),
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
                    color: value
                        ? themeService.currentTextColor
                        : themeService.currentTextColor
                            .withAlpha((255 * 0.8).round()),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: themeService.currentTextColor
                        .withAlpha((255 * 0.6).round()),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              onChanged(newValue);
              soundService.playToggleSound();
            },
            activeColor: themeService.currentAccentColor,
            activeTrackColor:
                themeService.currentPrimaryColor.withAlpha((255 * 0.5).round()),
            inactiveThumbColor:
                themeService.isDarkMode ? Colors.grey[400] : Colors.grey[700],
            inactiveTrackColor: themeService.isDarkMode
                ? Colors.grey[800]!.withAlpha((255 * 0.6).round())
                : Colors.grey[300],
          ),
        ],
      ),
    );

    return _FlippingCard(
      themeService: themeService,
      soundService: soundService,
      child: settingSwitchContent,
    );
  }

  void _showResetConfirmationDialog(BuildContext context,
      ThemeService themeService, SoundService soundService) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: themeService.currentCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Reset Settings',
            style: TextStyle(
              color: themeService.currentTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to reset all settings to their default values?',
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
                'Reset',
                style: TextStyle(
                  color: themeService.primaryGradient[0],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                themeService.isDarkMode = true;
                themeService.enableAnimations = true;
                soundService.enableSounds = true;
                soundService.playResetSound();
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Settings reset to defaults',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: themeService.currentCardColor,
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

class _InfoCardContent extends StatelessWidget {
  final ThemeService themeService;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;

  const _InfoCardContent({
    required this.themeService,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeService.currentCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeService.isDarkMode
              ? Colors.grey[700]!.withAlpha((255 * 0.6).round())
              : Colors.grey[400]!.withAlpha((255 * 0.6).round()),
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
                  gradientColors[0].withAlpha((255 * 0.2).round()),
                  gradientColors[1].withAlpha((255 * 0.2).round()),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: themeService.currentTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: themeService.currentTextColor
                        .withAlpha((255 * 0.6).round()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlippingCard extends StatefulWidget {
  final Widget child;
  final ThemeService themeService;
  final SoundService soundService;

  const _FlippingCard({
    required this.child,
    required this.themeService,
    required this.soundService,
  });

  @override
  _FlippingCardState createState() => _FlippingCardState();
}

class _FlippingCardState extends State<_FlippingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.soundService.playFlipSound();
    if (widget.themeService.enableAnimations) {
      if (_isFlipped) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      _isFlipped = !_isFlipped;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.themeService.enableAnimations) {
      return GestureDetector(
        onTap: _handleTap,
        child: widget.child,
      );
    }

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? staticChild) {
          final angle = _controller.value * math.pi;
          final isShowingFront = _controller.value < 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isShowingFront
                ? staticChild
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: staticChild,
                  ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
