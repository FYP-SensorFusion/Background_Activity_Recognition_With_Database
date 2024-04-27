import 'package:background_activity_recognition_with_database/screens/activities_screen.dart';
import 'package:background_activity_recognition_with_database/screens/activity_report_screen.dart';
import 'package:background_activity_recognition_with_database/screens/signin_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:background_activity_recognition_with_database/screens/anxiety_detection.dart';
import 'package:background_activity_recognition_with_database/screens/depression_detection.dart';

import '../check_date.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _tipList = [
    "Take a brisk 10-minute walk to boost your mood and energy levels.",
    "Drink plenty of water throughout the day to stay hydrated and focused.",
    "Practice mindfulness meditation for 5 minutes to reduce stress and anxiety.",
    "Stretch your body for 5-10 minutes to improve flexibility and relieve tension.",
    "Get some sunlight exposure to regulate your sleep cycle and improve mood.",
  ];
  int _currentTipIndex = 0;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await hasTwoWeeksPassedSinceLastTest()) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AnxietyDetection(
                onTestFinished: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DepressionDetection()),
                  );
                  saveTestDate();
                },
              )),
        );
      }
    });
    // _changeTip(); // Start tip carousel on load
  }

  void _changeTip() async {
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      _currentTipIndex = (_currentTipIndex + 1) % _tipList.length;
    });
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

  // Function to build a tip card with full-screen height
  Widget _buildTipCard(String tip) {
    return Container(
      // Set full screen height with some padding (outer container)
      height: MediaQuery.of(context).size.height -
          kToolbarHeight -
          kBottomNavigationBarHeight -
          32.0, // Adjust padding
      margin: const EdgeInsets.all(24.0), // Padding for outer container
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(16.0), // Border radius for outer container
        color:
            Colors.teal.shade100, // Light teal background for outer container
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade100, // Subtle shadow
            blurRadius: 1.0, // Blur radius
            spreadRadius: 1.0, // Spread radius
          ),
        ],
      ),
      child: Padding(
        // Add padding around the content
        padding: const EdgeInsets.all(24.0), // Adjust padding for inner content
        child: Container(
          // Transparent container for inner content
          decoration: BoxDecoration(
            color: Colors
                .transparent, // Remove background color for inner container
          ),
          child: Center(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 20.0, // Increase text size
                color: Colors.teal.shade900, // Dark teal text
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Life Spark"), // Use widget.title for app name
        centerTitle: true,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
        ],// App bar color,
      ),
      body: Center(
        child: SizedBox(
          height: 500.0,
          child: CarouselSlider(
            items: _tipList.map((tip) => _buildTipCard(tip)).toList(),
            options: CarouselOptions(
              height: 500.0, // Set carousel height
              viewportFraction: 1, // Show 80% of each card
              enableInfiniteScroll: true, // Loop through tips
              autoPlay: true, // Automatic rotation
              autoPlayInterval:
                  const Duration(seconds: 5), // Change time interval
              autoPlayAnimationDuration:
                  const Duration(milliseconds: 800), // Smooth transition
            ),
          ),
        ),
      ),
    );
  }
}
