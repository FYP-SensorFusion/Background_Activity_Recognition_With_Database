import 'package:lifespark/screens/activities_screen.dart';
import 'package:lifespark/screens/activity_report_screen.dart';
import 'package:lifespark/screens/profile_screen.dart';
import 'package:lifespark/screens/signin_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../check_date.dart';
import '../services/activity_database_helper.dart';
import '../widgets/app_carousel_card.dart';
import '../widgets/health_tip_card_widget.dart';
import '../widgets/sleep_duration_Card.dart';
import 'anxiety_detection.dart';
import 'depression_detection.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _tipList = [
    {
      'tip':
          "Take a brisk 10-minute walk to boost your mood and energy levels.",
      'icon': Icons.directions_walk
    },
    {
      'tip':
          "Drink plenty of water throughout the day to stay hydrated and focused.",
      'icon': Icons.local_drink
    },
    {
      'tip':
          "Practice mindfulness meditation for 5 minutes to reduce stress and anxiety.",
      'icon': Icons.psychology
    },
    {
      'tip':
          "Stretch your body for 5-10 minutes to improve flexibility and relieve tension.",
      'icon': Icons.accessibility
    },
    {
      'tip':
          "Get some sunlight exposure to regulate your sleep cycle and improve mood.",
      'icon': Icons.sunny
    },
    {
      'tip':
          "Eat a balanced diet rich in fruits, vegetables, and whole grains for sustained energy.",
      'icon': Icons.food_bank
    },
    {
      'tip':
          "Listen to calming music or nature sounds to reduce stress and improve sleep quality.",
      'icon': Icons.music_note
    },
    {
      'tip':
          "Take deep breaths throughout the day to promote relaxation and focus.",
      'icon': Icons.wind_power
    },
    {
      'tip': "Limit screen time before bed to promote better sleep hygiene.",
      'icon': Icons.nights_stay
    },
    {
      'tip':
          "Spend time in nature to reduce stress and improve mental well-being.",
      'icon': Icons.park
    },
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
        title: const Text(
          "Life Spark",
          style: TextStyle(
              fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Pacifico'),
        ), // Use widget.title for app name
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/purple-sky.png'),
                fit: BoxFit.fill),
          ),
        ),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/black-1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 300.0,
              child: CarouselSlider(
                items: _tipList
                    .map((tipData) => HealthTipCard(
                          tip: tipData['tip'] as String, // Access tip from map
                          iconData: tipData['icon'] as IconData,
                        )) // Access icon from map                      ))
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
      ),
    );
  }
}
