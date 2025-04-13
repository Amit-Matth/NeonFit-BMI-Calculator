# NeonFit BMI Calculator

A neon-themed Flutter BMI calculator with interactive elements, animation effects, and history tracking.

## Features

- **Sleek Neon Design**: Dark theme with vibrant neon accents
- **Interactive Input Controls**: Sliders with custom thumbs, plus/minus buttons
- **BMI Calculation**: Accurate BMI calculation based on height, weight, age, and gender
- **Result Visualization**: Colorful visualizations of BMI category and health insights
- **History Tracking**: Save and view past BMI calculations
- **Customizable Settings**: Toggle dark mode, animations, sound effects, and unit systems
- **Responsive Layout**: Works on mobile, tablet, and web

## Architecture

The app uses:

- **Provider** for state management
- **Hive** for local data persistence
- **SharedPreferences** for user settings
- **flutter_animate** for smooth animations
- **Google Fonts** for typography

## Project Structure

- `lib/models/` - Data models including BmiRecord
- `lib/screens/` - App screens (home, results, history, settings, help)
- `lib/services/` - Services for database and theme management
- `lib/widgets/` - Reusable UI components
- `lib/main.dart` - App entry point and routing
