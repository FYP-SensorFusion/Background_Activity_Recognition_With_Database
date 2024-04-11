// database_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/activity_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Activities.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Activity(id INTEGER PRIMARY KEY, type TEXT NOT NULL, startTime TEXT NOT NULL, duration TEXT NOT NULL, lastUpdatedTime TEXT NOT NULL);"),
        version: _version);
  }

  static Future<int> addActivity(ActivityModel activity) async {
    final db = await _getDB();
    return await db.insert("Activity", activity.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateActivity(ActivityModel activity) async {
    final db = await _getDB();
    return await db.update("Activity", activity.toJson(),
        where: 'id = ?',
        whereArgs: [activity.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteActivity(ActivityModel activity) async {
    final db = await _getDB();
    return await db.delete(
      "Activity",
      where: 'id = ?',
      whereArgs: [activity.id],
    );
  }

  static Future<ActivityModel?> getLastUpdatedActivity() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> rows =
        await db.query("Activity", orderBy: 'lastUpdatedTime DESC', limit: 1);

    if (rows.isEmpty) {
      return null;
    }
    return ActivityModel.fromJson(rows.first);
  }

  static Future<List<ActivityModel>?> getAllActivities() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Activity");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => ActivityModel.fromJson(maps[index]));
  }
}
