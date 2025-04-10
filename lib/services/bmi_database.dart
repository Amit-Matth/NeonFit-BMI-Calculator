import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/bmi_record.dart';

class BMIDatabase {
  static const String _boxName = 'bmi_records';
  late Box<BMIRecord> _box;

  // Singleton pattern
  static final BMIDatabase _instance = BMIDatabase._internal();

  factory BMIDatabase() {
    return _instance;
  }

  BMIDatabase._internal();

  // Initialize the database
  Future<void> init() async {
    await Hive.initFlutter();

    // Register the adapter
    Hive.registerAdapter(BMIRecordAdapter());
    Hive.registerAdapter(GenderAdapter());

    // Open the box
    _box = await Hive.openBox<BMIRecord>(_boxName);
  }

  // Add a new BMI record
  Future<void> addRecord(BMIRecord record) async {
    await _box.add(record);
  }

  // Get all BMI records
  List<BMIRecord> getAllRecords() {
    return _box.values.toList();
  }

  // Get BMI records sorted by date (newest first)
  List<BMIRecord> getRecordsSortedByDate() {
    final records = getAllRecords();
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  // Get the latest BMI record
  BMIRecord? getLatestRecord() {
    final records = getRecordsSortedByDate();
    return records.isNotEmpty ? records.first : null;
  }

  // Delete a BMI record
  Future<void> deleteRecord(int index) async {
    await _box.deleteAt(index);
  }

  // Clear all BMI records
  Future<void> clearRecords() async {
    await _box.clear();
  }

  // Count of BMI records
  int get recordCount => _box.length;
}
