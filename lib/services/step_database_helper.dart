// database_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/step_count_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "StepCount.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE StepCount(id INTEGER PRIMARY KEY, stepCount INTEGER NOT NULL, date TEXT NOT NULL);");
    }, version: _version);
  }

  static Future<int> addStepCount(StepCountModel stepCount) async {
    final db = await _getDB();
    try {

      // Query the database for a record with today's date
      final List<Map<String, dynamic>> rows = await db.query(
        "StepCount",
        where: "date = ?",
        whereArgs: [stepCount.date.toIso8601String()],
      );
      print(rows);
      if (rows.isNotEmpty) {
        StepCountModel item = StepCountModel.fromJson(rows.first);
        // If a record exists, update it
        print("Updating step count: $stepCount.date");
        return await db.update(
          "StepCount",
          {'stepCount': stepCount.stepCount}, // Only update the stepCount field
          where: 'date = ? AND id = ?',
          whereArgs: [stepCount.date.toIso8601String(), item.id],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        // If no record exists, insert a new one
        print("Adding step count: $stepCount");
        return await db.insert(
          "StepCount",
          stepCount.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print(e);
    }
    return 0;
  }

  static Future<int> deleteStepCount(int id) async {
    final db = await _getDB();
    return await db.delete(
      "StepCount",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<StepCountModel?> getStepCountForDate(DateTime date) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> rows = await db.query(
      "StepCount",
      where: "date = ?",
      whereArgs: [date.toIso8601String()],
    );

    if (rows.isEmpty) {
      return null;
    }
    return StepCountModel.fromJson(rows.first);
  }
}
