import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class WeightAgeWidget extends StatelessWidget {
  final double weight;
  final int age;
  final Function(double) onWeightChanged;
  final Function(int) onAgeChanged;

  const WeightAgeWidget({
    Key? key,
    required this.weight,
    required this.age,
    required this.onWeightChanged,
    required this.onAgeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Weight input
        Expanded(
          child: _InputCard(
            label: 'WEIGHT',
            value: weight.toStringAsFixed(1),
            unit: 'kg',
            onIncrement: () => onWeightChanged(weight + 0.5),
            onDecrement: () => onWeightChanged(weight > 0.5 ? weight - 0.5 : 0),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Age input
        Expanded(
          child: _InputCard(
            label: 'AGE',
            value: age.toString(),
            unit: 'yrs',
            onIncrement: () => onAgeChanged(age + 1),
            onDecrement: () => onAgeChanged(age > 1 ? age - 1 : 1),
          ),
        ),
      ],
    );
  }
}

class _InputCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _InputCard({
    Key? key,
    required this.label,
    required this.value,
    required this.unit,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final primaryColor = themeService.primaryColor;
    final accentColor = themeService.accentColor;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1D1D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Label
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Value and unit
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Plus and minus buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CircularButton(
                icon: Icons.remove,
                onPressed: onDecrement,
                primaryColor: primaryColor,
                accentColor: accentColor,
              ),
              
              _CircularButton(
                icon: Icons.add,
                onPressed: onIncrement,
                primaryColor: primaryColor,
                accentColor: accentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color primaryColor;
  final Color accentColor;

  const _CircularButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.primaryColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [primaryColor, accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: themeService.neonShadow,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black,
            size: 24,
          ),
        ),
      ),
    );
  }
}
