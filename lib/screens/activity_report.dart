import 'package:flutter/material.dart';
import 'package:background_bctivity_recognition_with_database/services/activity_database_helper.dart';

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
    activities = DatabaseHelper.getActivitiesforGivenDuration(30); // Adjust duration as needed

  }

  void toggleView() {
    setState(() {
      showLastmonthActivities = !showLastmonthActivities;
      if(showLastmonthActivities){
        activities = DatabaseHelper.getActivitiesforGivenDuration(30); // Adjust duration as needed
      }
      else{
        activities = DatabaseHelper.getTotalDurationForAllActivities(); // Adjust duration as needed
      }// Adjust duration as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showLastmonthActivities
            ? 'Last Month Activities'
            : 'All Time Activities'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: toggleView,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, int>>(
        future: activities,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Activity Type')),
                  DataColumn(label: Text('Duration')),
                ],
                rows: data.entries.map((entry) {
                  final activityType = entry.key;
                  final totalDuration = entry.value;
                  return DataRow(cells: [
                    DataCell(Text(activityType.toString().split('.').last)),
                    DataCell(Text(formatDuration(totalDuration))),
                  ]);
                }).toList(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
