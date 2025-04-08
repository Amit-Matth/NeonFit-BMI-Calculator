import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/services/theme_service.dart';
import 'package:provider/provider.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final isDarkMode = themeService.isDarkMode;
    final enableAnimations = themeService.enableAnimations;
    final primaryGradient = themeService.primaryGradient;

    Widget content = Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: primaryGradient,
          ).createShader(bounds),
          child: const Text(
            'BMI Information',
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Hero image
          _buildHeaderImage(context, primaryGradient),

          const SizedBox(height: 32),

          // What is BMI section
          _buildSectionTitle('What is BMI?', primaryGradient[0]),
          const SizedBox(height: 16),
          _buildTextContent(
            'Body Mass Index (BMI) is a value derived from the mass (weight) and height of a person. The BMI is defined as the body mass divided by the square of the body height, and is expressed in units of kg/m².',
            'It is a simple and widely used tool to identify weight categories that may lead to health problems.',
          ),

          const SizedBox(height: 32),

          // BMI Categories section
          _buildSectionTitle('BMI Categories', primaryGradient[0]),
          const SizedBox(height: 16),
          _buildCategoriesTable(context),

          const SizedBox(height: 24),

          _buildTextContent(
            'These categories are the standard weight status categories associated with BMI ranges for adults. They are the same for men and women of all ages.',
            'Note that BMI is just one of many factors related to health. It does not directly measure body fat or account for factors such as muscle mass, bone density, or overall body composition.',
          ),

          const SizedBox(height: 32),

          // BMI Limitations section
          _buildSectionTitle('Limitations of BMI', primaryGradient[0]),
          const SizedBox(height: 16),
          _buildTextContent(
            'While BMI can be a useful tool, it has several limitations:',
            '',
          ),

          // Limitations list
          _buildBulletPoint(
              'May overestimate body fat in athletes and muscular individuals'),
          _buildBulletPoint(
              'May underestimate body fat in older persons or those who have lost muscle'),
          _buildBulletPoint(
              'Does not account for sex and age differences in body fat distribution'),
          _buildBulletPoint(
              'Does not distinguish between excess fat, muscle, or bone mass'),
          _buildBulletPoint(
              'Does not directly indicate health of an individual'),

          const SizedBox(height: 32),

          // How to use this app section
          _buildSectionTitle('How to Use This App', primaryGradient[0]),
          const SizedBox(height: 16),
          _buildTextContent(
            'Using the NeonFit BMI Calculator is simple:',
            '',
          ),

          // How to use steps
          _buildNumberedPoint(1, 'Select your gender'),
          _buildNumberedPoint(2, 'Input your height (feet and inches)'),
          _buildNumberedPoint(3, 'Set your weight (in kg or lb)'),
          _buildNumberedPoint(4, 'Enter your age'),
          _buildNumberedPoint(
              5, 'Press the "Calculate" button to get your BMI result'),
          _buildNumberedPoint(
              6, 'Save your result to track your progress over time'),

          const SizedBox(height: 40),

          // Disclaimer
          _buildDisclaimerBox(),

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

  Widget _buildHeaderImage(BuildContext context, List<Color> gradientColors) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradientColors[0].withOpacity(0.8),
            gradientColors[1].withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Particle effects
          ...List.generate(
            20,
            (index) => Positioned(
              left: (index * 19) % MediaQuery.of(context).size.width,
              top: (index * 8) % 160,
              child: Container(
                width: 4 + (index % 4),
                height: 4 + (index % 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4 - (index % 3) * 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
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
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
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

  Widget _buildTextContent(String paragraph1, String paragraph2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          paragraph1,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        if (paragraph2.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            paragraph2,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[300],
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoriesTable(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          // Table header
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
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
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),

          const Divider(height: 24, color: Colors.grey),

          // Table rows
          _buildCategoryRow('Underweight', 'Below 18.5', Colors.blue),
          const SizedBox(height: 12),

          _buildCategoryRow('Normal weight', '18.5 - 24.9', Colors.green),
          const SizedBox(height: 12),

          _buildCategoryRow('Overweight', '25.0 - 29.9', Colors.amber),
          const SizedBox(height: 12),

          _buildCategoryRow('Obesity', '30.0 and above', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(String category, String range, MaterialColor color) {
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
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

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedPoint(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[850]!.withOpacity(0.5),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
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
                color: Colors.amber[400],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Disclaimer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'The BMI calculator is provided for informational purposes only and is not a substitute for professional medical advice. Always consult with a healthcare professional before making health decisions based on BMI results.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
