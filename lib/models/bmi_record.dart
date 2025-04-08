import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'bmi_record.g.dart';

@HiveType(typeId: 1)
enum Gender {
  @HiveField(0)
  male,
  @HiveField(1)
  female,
}

@HiveType(typeId: 0)
class BMIRecord {
  @HiveField(0)
  final double height;

  @HiveField(1)
  final double weight;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final Gender gender;

  @HiveField(4)
  final double bmiValue;

  @HiveField(5)
  final DateTime date;

  BMIRecord({
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
    required this.bmiValue,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  factory BMIRecord.calculate({
    required double height,
    required double weight,
    required int age,
    required Gender gender,
  }) {
    final heightInMeters = height / 100;
    final bmi = weight / (heightInMeters * heightInMeters);

    return BMIRecord(
      height: height,
      weight: weight,
      age: age,
      gender: gender,
      bmiValue: bmi,
    );
  }

  String get category {
    if (bmiValue < 18.5) {
      return 'Underweight';
    } else if (bmiValue < 25) {
      return 'Normal';
    } else if (bmiValue < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  Color getCategoryColor() {
    if (bmiValue < 18.5) {
      return Colors.blue.shade100;
    } else if (bmiValue < 25) {
      return Colors.green.shade100;
    } else if (bmiValue < 30) {
      return Colors.orange.shade100;
    } else {
      return Colors.red.shade100;
    }
  }

  double get percentilePosition {
    if (bmiValue < 10) return 0;
    if (bmiValue > 40) return 100;
    return ((bmiValue - 10) / (40 - 10)) * 100;
  }

  String getRecommendation() {
    if (bmiValue < 18.5) {
      return 'You are underweight. Consider consulting with a nutritionist for a healthy diet plan to gain weight.';
    } else if (bmiValue < 25) {
      return 'You have a normal body weight. Good job! Maintain a balanced diet and regular exercise.';
    } else if (bmiValue < 30) {
      return 'You are overweight. Consider incorporating more physical activity and a balanced diet to reach a healthier weight.';
    } else {
      return 'You are obese. It is advisable to consult with a healthcare professional for a personalized weight management plan.';
    }
  }
}
