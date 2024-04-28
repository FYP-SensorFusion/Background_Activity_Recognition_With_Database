import 'package:lifespark/models/depression_detection_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import '../models/anxiety_detection_model.dart';
import '../models/depression_detection_model.dart';
import '../models/depression_detection_api_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbname = "Anxiety_Depression_Detection";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbname),
        onCreate: (db, version) async {
          await db.execute(
              "CREATE TABLE Anxiety(id INTEGER PRIMARY KEY, date TEXT NOT NULL, anxietyScore DOUBLE NOT NULL, anxietyDescription TEXT NOT NULL);"
          );
          await db.execute(
              "CREATE TABLE Depression(id INTEGER PRIMARY KEY, date TEXT NOT NULL, depressionScore DOUBLE NOT NULL, depressionDescription TEXT NOT NULL);"
          );
          await db.execute(
              "CREATE TABLE DepressionApi(id INTEGER PRIMARY KEY, date TEXT NOT NULL, description TEXT NOT NULL, result TEXT NOT NULL);"
          );
        }, version: _version);
  }

  static Future<int> addAnxietyScore(AnxietyModel model) async {
    final db = await _getDB();
    return await db.insert("Anxiety", model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addDepressionScore(DepressionModel model) async {
    final db = await _getDB();
    return await db.insert("Depression", model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addDepressionApiScore(DepressionApiModel model) async {
    final db = await _getDB();
    return await db.insert("DepressionApi", model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
