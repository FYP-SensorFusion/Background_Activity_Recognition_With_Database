// This function sets up the activity recognition stream
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import '../models/activity_model.dart';
import 'activity_database_helper.dart';

Future<void> setupActivityRecognition() async {
  print("start Activity Recognition ==================");
  FlutterActivityRecognition.instance.activityStream
      .listen((Activity activity) async {
    print(
        "Activity Update Received: ${activity.type}"); // print the activity type
    print(
        "Confidence: ${activity.confidence}"); // print the confidence of the detected activity

    ActivityModel? lastActivity = await DatabaseHelper.getLastUpdatedActivity();
    print("${activity.type.toString().split('.').last}");
    print(" ${lastActivity?.toJson()}");
    if (activity.type.toString().split('.').last != "UNKNOWN") {
      if (lastActivity == null ||
          lastActivity.type != activity.type.toString().split('.').last) {
        var newActivityModel = ActivityModel(
          type: activity.type.toString().split('.').last,
          startTime: DateTime.now(),
          duration: 0,
          lastUpdatedTime: DateTime.now(),
        );
        await DatabaseHelper.addActivity(newActivityModel);
      } else {
        final now = DateTime.now();
        final durationInmuinites = now
            .difference(lastActivity.startTime)
            .inSeconds
            .round(); // Round up to seconds
        print("now: $now");
        print("round :${lastActivity.startTime}");
        print("duration$durationInmuinites");
        var activityModel = ActivityModel(
          id: lastActivity.id,
          type: lastActivity.type,
          startTime: lastActivity.startTime,
          duration: durationInmuinites,
          lastUpdatedTime: DateTime.now(),
        );
        await DatabaseHelper.updateActivity(activityModel);
        print("updated in the database");
      }
    }
  });
}
