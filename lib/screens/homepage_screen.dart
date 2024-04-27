import 'package:lifespark/screens/signin_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/activity_database_helper.dart';
import '../widgets/app_carousel_card.dart';
import '../widgets/health_tip_card_widget.dart';
import '../widgets/sleep_duration_Card.dart';

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
        ], // App bar color,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300.0,
            child: CarouselSlider(
              items: _tipList
                  .map((tip) => HealthTipCard(
                        tip: tip,
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 300.0, // Set carousel height
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
          FutureBuilder<int>(
            future: DatabaseHelper.getLastDaySleepingDuration(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                final sleepDuration = snapshot.data ?? 0;
                return SleepDurationCard(sleepDuration: sleepDuration);
              }
            },
          ),
          SizedBox(
            height: 250.0,
            child: AppCarouselCard(),
          ),
        ],
      ),
    );
  }
}
