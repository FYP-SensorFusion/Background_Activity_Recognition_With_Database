import 'package:lifespark/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:lifespark/services/activity_database_helper.dart';

import '../utils.dart';

class ActivityReportScreen extends StatefulWidget {
  @override
  _ActivityReportScreenState createState() => _ActivityReportScreenState();
}

class _ActivityReportScreenState extends State<ActivityReportScreen> {
  Future<Map<String, int>>? activities;
  bool showLastmonthActivities = true;

  @override
  void initState() {
    super.initState();
    activities = DatabaseHelper.getActivitiesForGivenDuration(
        30); // Adjust duration as needed
  }

  void toggleView() {
    setState(() {
      showLastmonthActivities = !showLastmonthActivities;
      if (showLastmonthActivities) {
        activities = DatabaseHelper.getActivitiesForGivenDuration(
            30); // Adjust duration as needed
      } else {
        activities = DatabaseHelper
            .getTotalDurationForAllActivities(); // Adjust duration as needed
      } // Adjust duration as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/purple-sky.png'),
                fit: BoxFit.fill),
          ),
        ),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: toggleView,
            ),
            Expanded(
              child: Center(
                child: Text(showLastmonthActivities
                    ? 'Last Month Activities'
                    : 'All Time Activities'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal, // App bar color
      ),
      body: FutureBuilder<Map<String, int>>(
        future: activities,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: data.entries.map((entry) {
                  final activityType = entry.key;
                  final totalDuration = entry.value;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min, // Avoid cards expanding
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center row content
                              children: [
                                const Text(
                                  'Activity Type:',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  activityType,
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center row content
                              children: [
                                const Text(
                                  'Total Duration:',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  formatDuration(totalDuration),
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
