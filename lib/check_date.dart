import 'package:shared_preferences/shared_preferences.dart';

void saveTestDate() async {
  final prefs = await SharedPreferences.getInstance();
  final testDate = DateTime.now();
  await prefs.setInt('lastTestDate', testDate.millisecondsSinceEpoch);
}

Future<bool> hasDayPassedSinceLastTest() async {
  final prefs = await SharedPreferences.getInstance();
  final lastTestDateMillis = prefs.getInt('lastTestDate');
  if (lastTestDateMillis == null) {
    return true;
  }
  final lastTestDate = DateTime.fromMillisecondsSinceEpoch(lastTestDateMillis);
  final difference = DateTime.now().difference(lastTestDate);
  return difference.inDays >= 1;
}

Future<bool> hasTwoWeeksPassedSinceLastTest() async {
  final prefs = await SharedPreferences.getInstance();
  final lastTestDateMillis = prefs.getInt('lastTestDate');
  if (lastTestDateMillis == null) {
    return true;
  }
  final lastTestDate = DateTime.fromMillisecondsSinceEpoch(lastTestDateMillis);
  final difference = DateTime.now().difference(lastTestDate);
  return difference.inDays >= 14; // Change this to check for two weeks instead of one day
}
