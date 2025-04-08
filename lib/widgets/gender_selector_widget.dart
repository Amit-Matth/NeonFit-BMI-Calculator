import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/models/bmi_record.dart';
import '/services/theme_service.dart';
import 'package:provider/provider.dart';

class GenderSelectorWidget extends StatelessWidget {
  final Gender selectedGender;
  final Function(Gender) onChanged;

  const GenderSelectorWidget({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final isDarkMode = themeService.isDarkMode;
    final enableAnimations = themeService.enableAnimations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Gender',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
        ),
        Row(
          children: [
            // Male Gender Option
            Expanded(
              child: _buildGenderOption(
                context,
                Gender.male,
                'Male',
                Icons.male_rounded,
                [Colors.blue[600]!, Colors.blue[400]!],
                enableAnimations,
              ),
            ),
            const SizedBox(width: 16),
            // Female Gender Option
            Expanded(
              child: _buildGenderOption(
                context,
                Gender.female,
                'Female',
                Icons.female_rounded,
                [Colors.pink[600]!, Colors.pink[400]!],
                enableAnimations,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(
    BuildContext context,
    Gender gender,
    String label,
    IconData icon,
    List<Color> gradientColors,
    bool enableAnimations,
  ) {
    final isSelected = selectedGender == gender;
    final borderRadius = BorderRadius.circular(16);

    var container = Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: isSelected
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              )
            : null,
        color: isSelected
            ? null
            : Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[200],
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: gradientColors[0].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () => onChanged(gender),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 60,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (enableAnimations) {
      return container
          .animate(target: isSelected ? 1 : 0)
          .scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1, 1),
            duration: const Duration(milliseconds: 200),
          )
          .elevation(
            begin: 0,
            end: 5,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutQuart,
          );
    }

    return container;
  }
}
