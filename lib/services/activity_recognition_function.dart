// This function sets up the activity recognition stream
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'dart:developer' as dev;

import '../models/activity_model.dart';
import 'activity_database_helper.dart';

Future<void> setupActivityRecognition() async {
  print("called setupActivityRecognition ==================");
  FlutterActivityRecognition.instance.activityStream.listen((Activity activity) async {
    print("Activity Update Received: ${activity.type}"); // print the activity type
    print("Confidence: ${activity.confidence}"); // print the confidence of the detected activity

    ActivityModel? lastActivity = await DatabaseHelper.getLastUpdatedActivity();

    if (lastActivity == null || lastActivity.type != activity.type.toString()) {
      var newActivityModel = ActivityModel(
        type: activity.type.toString(),
        startTime: DateTime.now(),
        duration: "0",
        lastUpdatedTime: DateTime.now(),
      );
      await DatabaseHelper.addActivity(newActivityModel);
    } else {
      var activityModel = ActivityModel(
        id: lastActivity.id,
        type: lastActivity.type,
        startTime: lastActivity.startTime,
        duration: DateTime.now().difference(lastActivity.startTime!).toString(),
        lastUpdatedTime: DateTime.now(),
      );
      await DatabaseHelper.updateActivity(activityModel);
    }
    print("updated in the database");
  });
}
