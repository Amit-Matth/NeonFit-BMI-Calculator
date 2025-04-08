import 'package:hive/hive.dart';
import '/models/bmi_record.dart';

class BmiService {
  static final BmiService _instance = BmiService._internal();

  factory BmiService() => _instance;

  BmiService._internal();

  Box<BMIRecord> get _bmiRecordsBox => Hive.box<BMIRecord>('bmi_Records');

  List<BMIRecord> getAllRecords() {
    final records = _bmiRecordsBox.values.toList();
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  BMIRecord? getRecord(int id) {
    try {
      return _bmiRecordsBox.get(id);
    } catch (_) {
      return null;
    }
  }

  Future<int> addRecord(BMIRecord record) async {
    final id = await _bmiRecordsBox.add(record);
    return id;
  }

  Future<void> clearRecords() async {
    await _bmiRecordsBox.clear();
  }

  Map<String, dynamic> calculateBMI({
    required String gender,
    required int heightFeet,
    required int heightInches,
    required double weight,
    required int age,
  }) {
    final double heightInInches =
        (heightFeet * 12).toDouble() + heightInches.toDouble();
    final double heightInMeters = heightInInches * 0.0254;

    final double bmiValue = weight / (heightInMeters * heightInMeters);

    String category;
    String message;
    String color;
    int percentilePosition;

    if (bmiValue < 18.5) {
      category = 'Underweight';
      message =
          'You are underweight. Focus on nutrient-rich foods to gain weight healthily.';
      color = '#3B82F6';
      percentilePosition = 15;
    } else if (bmiValue < 25) {
      category = 'Normal';
      message = 'Your BMI is normal. Good job maintaining a healthy weight!';
      color = '#10B981';
      percentilePosition = 50;
    } else if (bmiValue < 30) {
      category = 'Overweight';
      message =
          'You are overweight. Consider a balanced diet and regular exercise.';
      color = '#F59E0B';
      percentilePosition = 75;
    } else if (bmiValue < 35) {
      category = 'Obese';
      message =
          'You fall in the obese category. Consult a healthcare provider for guidance.';
      color = '#F97316';
      percentilePosition = 90;
    } else {
      category = 'Severely Obese';
      message =
          'You fall in the severely obese category. Please consult a doctor for professional advice.';
      color = '#EF4444';
      percentilePosition = 95;
    }

    return {
      'bmiValue': bmiValue,
      'category': category,
      'color': color,
      'message': message,
      'percentilePosition': percentilePosition,
    };
  }
}
