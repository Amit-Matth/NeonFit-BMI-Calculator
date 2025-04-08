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

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)

### Installation

1. Clone this repository:
   ```
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```
   cd flutter_bmi_calculator
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Generate Hive adapters:
   ```
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. Run the app:
   ```
   flutter run
   ```

### Building for Web

1. Use the included build script:
   ```
   ./build_web.sh
   ```

2. Or manually build:
   ```
   flutter build web --web-renderer canvaskit --release
   ```

3. The built web app will be located in the `build/web` directory.

## Deployment

### Using Docker

1. Build the Flutter web app:
   ```
   ./build_web.sh
   ```

2. Build the Docker image:
   ```
   docker build -t neonfit-bmi-calculator .
   ```

3. Run the Docker container:
   ```
   docker run -p 8080:80 neonfit-bmi-calculator
   ```

4. Access the app at `http://localhost:8080`

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

## License

This project is licensed under the MIT License - see the LICENSE file for details.