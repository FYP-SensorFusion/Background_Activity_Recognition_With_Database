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
            "CREATE TABLE Activity(id INTEGER PRIMARY KEY, type TEXT NOT NULL, startTime TEXT NOT NULL, duration INTEGER NOT NULL, lastUpdatedTime TEXT NOT NULL);"),
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

  static Future<List<ActivityModel>?> getLastDayActivities() async {
    final db = await _getDB();
    final now = DateTime.now();
    final lastdate = now.subtract(Duration(days: 1));

    // Order by latest end time (assuming a field named 'endTime' exists)
    final List<Map<String, dynamic>> maps = await db.query(
      "Activity",
      where: 'type != ? AND startTime >= ? AND startTime < ?',
      whereArgs: [
        "UNKNOWN",
        lastdate.toIso8601String(),
        now.toIso8601String(),
      ],
      orderBy: 'startTime DESC',
    );
    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => ActivityModel.fromJson(maps[index]));
  }

  static Future<int> getLastDaySleepingDuration() async {
    final db = await _getDB();
    final now = DateTime.now();
    final lastDate = now.subtract(Duration(days: 1));

    final result = await db.rawQuery('''
    SELECT SUM(duration) AS total_duration
    FROM Activity
    WHERE type = ? AND startTime >= ? AND startTime < ?
  ''', [
      "SLEEPING",
      lastDate.toIso8601String(),
      now.toIso8601String(),
    ]);

    final totalDuration = result.first['total_duration'] as int?;
    return totalDuration ?? 0; // Return 0 if result is null
  }

  static Future<Map<String, int>> getActivitiesForGivenDuration(
      int duration) async {
    final db = await _getDB();
    final now = DateTime.now();
    final lastdate = now.subtract(Duration(days: duration));

    final maps = await db.rawQuery('''
      SELECT type, SUM(duration) AS total_duration
      FROM Activity
      WHERE type != ? AND startTime >= ? AND startTime < ?
      GROUP BY type
    ''', [
      "UNKNOWN",
      lastdate.toIso8601String(),
      now.toIso8601String(),
    ]);
    return Map.fromIterable(maps,
        key: (item) => item['type'] as String,
        value: (item) => item['total_duration'] as int);
  }

  static Future<Map<String, int>> getTotalDurationForAllActivities() async {
    final db = await _getDB();

    final maps = await db.rawQuery('''
    SELECT type, SUM(duration) AS total_duration
    FROM Activity
    WHERE type != ?
    GROUP BY type
  ''', ["UNKNOWN"]);

    return Map.fromIterable(maps,
        key: (item) => item['type'] as String,
        value: (item) => item['total_duration'] as int);
  }
}
