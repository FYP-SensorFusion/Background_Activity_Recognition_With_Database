import 'package:background_bctivity_recognition_with_database/screens/activities_screen.dart';
import 'package:background_bctivity_recognition_with_database/screens/activity_report.dart';
import 'package:background_bctivity_recognition_with_database/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  void requestPermissions() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.activityRecognition,
    ].request();

    print(statuses[Permission.location]);
    print(statuses[Permission.activityRecognition]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Activity Recognition'),
          centerTitle: true,
        ),
        body: Container(),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "sign_out",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  SignInScreen()),
                );
              },
              child: const Icon(Icons.logout),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: "activity_screen",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActivitiesScreen()),
                );
              },
              child: const Icon(Icons.view_list),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: "activity_report",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActivityReportScreen()),
                );
                // Add logic to handle the activity report button
                // Redirect to the report screen or perform any other action
              },
              child: const Icon(Icons.analytics),
            ),
          ],
        ),
      ),
    );
  }
}