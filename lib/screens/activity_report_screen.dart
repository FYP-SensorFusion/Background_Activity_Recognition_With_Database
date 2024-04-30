import 'package:firebase_auth/firebase_auth.dart';
import 'package:graphic/graphic.dart';
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
                child: Text(
                  showLastmonthActivities
                      ? 'Last Month Activities'
                      : 'All Time Activities',
                  style: const TextStyle(
                      color: Colors.white), // White text for title
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                });
              },
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal, // App bar color
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/black-1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          Container(
            height: 300,
            width: 300,
            child: FutureBuilder<Map<String, int>> (
              future: activities,
              builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final dataC = snapshot.data!;
                    print(dataC);
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Chart(
                        data: dataC.entries.map((entry) => {'activity': entry.key, 'minutes': entry.value}).toList(),
                        variables: {
                          'activity': Variable(
                            accessor: (Map map) => map['activity'] as String,
                          ),
                          'minutes': Variable(
                            accessor: (Map map) => map['minutes'] as num,
                          ),
                        },
                        marks: [IntervalMark()],
                        axes: [
                          Defaults.horizontalAxis,
                          Defaults.verticalAxis,
                        ],
                      ),
                    );
                  }
                  else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          FutureBuilder<Map<String, int>>(
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
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10.0), // Add border radius
                          image: const DecorationImage(
                            opacity: 0.6,
                            image: AssetImage("assets/images/purple-sky.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
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
                                        color: Colors
                                            .white, // Set text color to white
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      activityType,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors
                                            .white, // Set text color to white
                                      ),
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
                                        color: Colors
                                            .white, // Set text color to white
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      formatDuration(totalDuration),
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors
                                            .white, // Set text color to white
                                      ),
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
        ]),
      ),
    );
  }
}
