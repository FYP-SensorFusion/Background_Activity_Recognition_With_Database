import 'package:lifespark/screens/navigator_screen.dart';
import 'package:lifespark/screens/signin_screen.dart';
import 'package:lifespark/screens/step_screen.dart';
import 'package:lifespark/services/activity_recognition_function.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usage_stats/usage_stats.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyCxxWO7_2n24I0okFrzI979GrcPX_Dco1I",
    authDomain: "healthspike-86c82.firebaseapp.com",
    databaseURL: "https://healthspike-86c82-default-rtdb.firebaseio.com",
    projectId: "healthspike-86c82",
    storageBucket: "healthspike-86c82.appspot.com",
    messagingSenderId: "701517480193",
    appId: "1:701517480193:web:1acad2d558c13a08cedb00",
    measurementId: "G-106SNJYJE8",
  ));
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
  final status_usage_stat = await UsageStats.checkUsagePermission()??false;


  // Check the status of each permission
  for (var permission in permissions) {
    if (await permission.status.isDenied) {
      return false;
    }
  }

  if(!status_usage_stat){
    UsageStats.grantUsagePermission();
  }

  // If all permissions are granted, return true
  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Add this line
      title: 'Flutter Background Activity Recognition',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.antonioTextTheme(textTheme).copyWith(
          bodyMedium: GoogleFonts.oswald(textStyle: textTheme.bodyMedium),
          bodySmall: GoogleFonts.oswald(textStyle: textTheme.bodyMedium),
        ),
      ),
      home: SignInScreen(),
      // home: NavigatorPage(title: "title"),
      // home: AppCarouselCard(),
    );
  }
}
