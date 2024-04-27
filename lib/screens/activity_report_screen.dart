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
    activities = DatabaseHelper.getActivitiesforGivenDuration(
        30); // Adjust duration as needed
  }

  void toggleView() {
    setState(() {
      showLastmonthActivities = !showLastmonthActivities;
      if (showLastmonthActivities) {
        activities = DatabaseHelper.getActivitiesforGivenDuration(
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
                                Text(
                                  'Activity Type:',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  activityType.toString().split('.').last,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center row content
                              children: [
                                Text(
                                  'Total Duration:',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  formatDuration(totalDuration),
                                  style: TextStyle(fontSize: 14.0),
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
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(showLastmonthActivities
//           ? 'Last Month Activities'
//           : 'All Time Activities'),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.calendar_today),
//           onPressed: toggleView,
//         ),
//       ],
//     ),
//     body: FutureBuilder<Map<String, int>>(
//       future: activities,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final data = snapshot.data!;
//
//           return Stack(
//             children: [
//               // Background decoration (optional)
//
//               // Container with rounded corners and shadow for the table
//               Center(
//                 child: Container(
//                   padding: EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         spreadRadius: 2.0,
//                         blurRadius: 5.0,
//                       ),
//                     ],
//                     color: Colors.grey[400],
//                   ),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       columns: const [
//                         DataColumn(label: Text('Activity Type')),
//                         DataColumn(label: Text('Duration')),
//                       ],
//                       rows: data.entries.map((entry) {
//                         final activityType = entry.key;
//                         final totalDuration = entry.value;
//                         return DataRow(
//                           cells: [
//                             // Option 1: Wrap Text with colored Text widget
//                             DataCell(
//                               Text(
//                                 activityType.toString().split('.').last,
//                                 style: TextStyle(
//                                   color: (data.entries.toList().indexOf(entry) % 2 == 0)
//                                       ? Colors.grey[800]
//                                       : Colors.black,
//                                 ),
//                               ),
//                             ),
//                             DataCell(Text(formatDuration(totalDuration))),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//         return Center(child: CircularProgressIndicator());
//       },
//     ),
//   );
// }
}
