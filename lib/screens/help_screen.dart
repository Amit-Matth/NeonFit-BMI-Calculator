import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/sound_service.dart';
import '/services/theme_service.dart';
import 'package:provider/provider.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final enableAnimations = themeService.enableAnimations;
    final primaryGradient = themeService.primaryGradient;

    Widget content = Scaffold(
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
            'BMI Information',
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeaderImage(context, themeService),
          const SizedBox(height: 32),
          _buildSectionTitle('What is BMI?', primaryGradient[0], themeService),
          const SizedBox(height: 16),
          _buildTextContent(
            themeService,
            'Body Mass Index (BMI) is a value derived from the mass (weight) and height of a person. The BMI is defined as the body mass divided by the square of the body height, and is expressed in units of kg/m².',
            'It is a simple and widely used tool to identify weight categories that may lead to health problems.',
          ),
          const SizedBox(height: 32),
          _buildSectionTitle(
              'BMI Categories', primaryGradient[0], themeService),
          const SizedBox(height: 16),
          _buildCategoriesTable(context, themeService),
          const SizedBox(height: 24),
          _buildTextContent(
            themeService,
            'These categories are the standard weight status categories associated with BMI ranges for adults. They are the same for men and women of all ages.',
            'Note that BMI is just one of many factors related to health. It does not directly measure body fat or account for factors such as muscle mass, bone density, or overall body composition.',
          ),
          const SizedBox(height: 32),
          _buildSectionTitle(
              'Limitations of BMI', primaryGradient[0], themeService),
          const SizedBox(height: 16),
          _buildTextContent(
            themeService,
            'While BMI can be a useful tool, it has several limitations:',
            '',
          ),
          _buildBulletPoint(
              'May overestimate body fat in athletes and muscular individuals',
              themeService),
          _buildBulletPoint(
              'May underestimate body fat in older persons or those who have lost muscle',
              themeService),
          _buildBulletPoint(
              'Does not distinguish between excess fat, muscle, or bone mass',
              themeService),
          _buildBulletPoint(
              'Does not directly indicate health of an individual',
              themeService),
          const SizedBox(height: 32),
          _buildSectionTitle(
              'How to Use This App', primaryGradient[0], themeService),
          const SizedBox(height: 16),
          _buildTextContent(
            themeService,
            'Using the NeonFit BMI Calculator is simple:',
            '',
          ),
          _buildNumberedPoint(1, 'Select your gender', themeService),
          _buildNumberedPoint(
              2, 'Input your height (feet and inches)', themeService),
          _buildNumberedPoint(3, 'Set your weight (in kg)', themeService),
          _buildNumberedPoint(4, 'Enter your age', themeService),
          _buildNumberedPoint(
              5,
              'Press the "Calculate" button to get your BMI result',
              themeService),
          _buildNumberedPoint(
              6,
              'Save your result to track your progress over time',
              themeService),
          const SizedBox(height: 40),
          _buildDisclaimerBox(themeService),
          const SizedBox(height: 40),
        ],
      ),
    );

    if (enableAnimations) {
      return content.animate().fadeIn(
            duration: const Duration(milliseconds: 300),
          );
    }
    return content;
  }

  Widget _buildHeaderImage(BuildContext context, ThemeService themeService) {
    final gradientColors = themeService.primaryGradient;
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradientColors[0].withAlpha((255 * 0.8).round()),
            gradientColors[1].withAlpha((255 * 0.8).round()),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withAlpha((255 * 0.3).round()),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          ...List.generate(
            20,
            (index) => Positioned(
              left: (index * 19) % MediaQuery.of(context).size.width,
              top: (index * 8) % 160,
              child: Container(
                width: 4 + (index % 4),
                height: 4 + (index % 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((255 * (0.4 - (index % 3) * 0.1)).round().clamp(0, 255)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'Body Mass Index (BMI)',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Understanding your health metrics',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha((255 * 0.8).round()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
      String title, Color color, ThemeService themeService) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTextContent(
      ThemeService themeService, String paragraph1, String paragraph2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          paragraph1,
          style: TextStyle(
            fontSize: 16,
            color: themeService.currentTextColor,
            height: 1.5,
          ),
        ),
        if (paragraph2.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            paragraph2,
            style: TextStyle(
              fontSize: 16,
              color: themeService.currentTextColor.withAlpha((255 * 0.7).round()),
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoriesTable(
      BuildContext context, ThemeService themeService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: themeService.currentCardColor,
        border: Border.all(
          color:
              themeService.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: themeService.currentTextColor.withAlpha((255 * 0.6).round()),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'BMI Range',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: themeService.currentTextColor.withAlpha((255 * 0.6).round()),
                  ),
                ),
              ),
            ],
          ),
          Divider(
              height: 24,
              color: themeService.currentTextColor.withAlpha((255 * 0.3).round())),
          _buildCategoryRow(
              'Underweight', 'Below 18.5', Colors.blue, themeService),
          const SizedBox(height: 12),
          _buildCategoryRow(
              'Normal weight', '18.5 - 24.9', Colors.green, themeService),
          const SizedBox(height: 12),
          _buildCategoryRow(
              'Overweight', '25.0 - 29.9', Colors.amber, themeService),
          const SizedBox(height: 12),
          _buildCategoryRow(
              'Obesity', '30.0 and above', Colors.orange, themeService),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(String category, String range, MaterialColor color,
      ThemeService themeService) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                category,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: themeService.currentTextColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            range,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text, ThemeService themeService) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 16,
              color: themeService.currentTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: themeService.currentTextColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedPoint(
      int number, String text, ThemeService themeService) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Color.lerp(themeService.currentCardColor,
                  themeService.currentBackgroundColor, 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: themeService.currentTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: themeService.currentTextColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerBox(ThemeService themeService) {
    final accentColor = Colors.amber;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: themeService.currentCardColor.withAlpha((255 * 0.8).round()),
        border: Border.all(
          color: accentColor.withAlpha((255 * (themeService.isDarkMode ? 0.5 : 0.7)).round()),
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
                'Disclaimer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'The BMI calculator is provided for informational purposes only and is not a substitute for professional medical advice. Always consult with a healthcare professional before making health decisions based on BMI results.',
            style: TextStyle(
              fontSize: 14,
              color: themeService.currentTextColor.withAlpha((255 * 0.8).round()),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
