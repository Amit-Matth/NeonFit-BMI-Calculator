import 'package:flutter/material.dart';
import 'package:neon_bmi_calculator/models/bmi_record.dart';

class GenderSelectWidget extends StatelessWidget {
  final Gender selectedGender;
  final Function(Gender) onGenderChanged;

  const GenderSelectWidget({
    Key? key,
    required this.selectedGender,
    required this.onGenderChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color getGenderColor(Gender gender) {
      if (gender == Gender.male) return Colors.blue;
      return Colors.pink;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: Gender.values.map((gender) {
            final isSelected = selectedGender == gender;
            final iconData = gender == Gender.male ? Icons.male : Icons.female;
            final genderLabel =
                gender.name[0].toUpperCase() + gender.name.substring(1);
            final selectedColor = getGenderColor(gender);

            return GestureDetector(
              onTap: () => onGenderChanged(gender),
              child: Column(
                children: [
                  // Top Label Row
                  SizedBox(
                    width: 115,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: isSelected ? selectedColor : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          iconData,
                          color: isSelected ? selectedColor : Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          genderLabel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Circle Icon with Background
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 125,
                    height: 100,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? selectedColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: selectedColor.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? selectedColor
                            : isDark
                                ? Colors.grey[800]
                                : Colors.grey[300],
                      ),
                      child: Icon(
                        iconData,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
