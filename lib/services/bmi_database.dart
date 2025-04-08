import 'package:hive_flutter/hive_flutter.dart';

import '../models/bmi_record.dart';

class BMIDatabase {
  static const String _boxName = 'bmi_records';
  late Box<BMIRecord> _box;

  static final BMIDatabase _instance = BMIDatabase._internal();

  factory BMIDatabase() {
    return _instance;
  }

  BMIDatabase._internal();

  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(BMIRecordAdapter());
    Hive.registerAdapter(GenderAdapter());

    _box = await Hive.openBox<BMIRecord>(_boxName);
  }

  Future<void> addRecord(BMIRecord record) async {
    await _box.add(record);
  }

  List<BMIRecord> getAllRecords() {
    return _box.values.toList();
  }

  List<BMIRecord> getRecordsSortedByDate() {
    final records = getAllRecords();
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  BMIRecord? getLatestRecord() {
    final records = getRecordsSortedByDate();
    return records.isNotEmpty ? records.first : null;
  }

  Future<void> deleteRecord(int index) async {
    await _box.deleteAt(index);
  }

  Future<void> clearRecords() async {
    await _box.clear();
  }

  int get recordCount => _box.length;
}
