import 'package:background_bctivity_recognition_with_database/screens/activities_screen.dart';
import 'package:background_bctivity_recognition_with_database/screens/activity_report.dart';
import 'package:background_bctivity_recognition_with_database/services/activity_recognition_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (await _arePermissionsGranted()) {
  FlutterBackgroundService.initialize(onStart);
  }
  runApp(const MyApp());
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });

  // bring to foreground
  service.setForegroundMode(true);

  setupActivityRecognition();
}

Future<bool> _arePermissionsGranted() async {
  // Define the permissions you want to check
  List<Permission> permissions = [
    Permission.location,
    Permission.activityRecognition,
  ];

  // Check the status of each permission
  for (var permission in permissions) {
    if (await permission.status.isDenied) {
      return false;
    }
  }

  // If all permissions are granted, return true
  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Background Activity Recognition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Background Activity Recognition'),
    );
  }
}

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
              heroTag: "activity_screan",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ActivitiesScreen()),
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
