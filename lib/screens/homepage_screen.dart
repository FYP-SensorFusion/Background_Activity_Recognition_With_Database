import 'package:background_activity_recognition_with_database/screens/activities_screen.dart';
import 'package:background_activity_recognition_with_database/screens/activity_report_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
    _changeTip(); // Start tip carousel on load
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
      height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 32.0, // Adjust padding
      margin: const EdgeInsets.all(24.0), // Padding for outer container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0), // Border radius for outer container
        color: Colors.teal.shade100, // Light teal background for outer container
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade100, // Subtle shadow
            blurRadius: 1.0, // Blur radius
            spreadRadius: 1.0, // Spread radius
          ),
        ],
      ),
      child: Padding(  // Add padding around the content
        padding: const EdgeInsets.all(24.0), // Adjust padding for inner content
        child: Container(  // Transparent container for inner content
          decoration: BoxDecoration(
            color: Colors.transparent, // Remove background color for inner container
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
        title: Text('Life Spark'), // App name
        centerTitle: true,
        backgroundColor: Colors.teal, // App bar color
      ),
      body: Stack(
        // Use Stack for layering widgets
        children: [
          // Centered carousel container with card layout
          Center(
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
          // Fixed bottom button row (unchanged)
          Positioned(
            bottom: 16.0, // Adjust spacing from bottom
            left: 0.0,
            right: 0.0, // Span the entire width
            child: Container(
              // Span the entire width
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Evenly spaced buttons
                children: [
                  // Activity Details button with increased padding on the left
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivitiesScreen()),
                    ),
                    child: Container(
                      padding:
                          const EdgeInsets.all(16.0), // Inner padding for icons
                      child: Icon(
                        Icons.sports_score, // Activity icon
                        size: 32.0, // Increase icon size
                        color: Colors.teal.shade900, // Icon color
                      ),
                    ),
                  ),
                  // Activity Report button
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivityReportScreen()),
                    ),
                    child: Container(
                      padding:
                          const EdgeInsets.all(16.0), // Inner padding for icons
                      child: Icon(
                        Icons.bar_chart, // Activity report icon
                        size: 32.0, // Increase icon size
                        color: Colors.teal.shade900, // Icon color
                      ),
                    ),
                  ),
                  // Depression Report button (assuming you have a depression report screen)
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivityReportScreen()),
                    ),
                    child: Container(
                      padding:
                          const EdgeInsets.all(16.0), // Inner padding for icons
                      child: Icon(
                        Icons.psychology, // Depression report icon
                        size: 32.0, // Increase icon size
                        color: Colors.teal.shade900, // Icon color
                      ),
                    ),
                  ),
                  // User Details button with increased padding on the right
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivityReportScreen()),
                    ),
                    child: Container(
                      padding:
                          const EdgeInsets.all(16.0), // Inner padding for icons
                      child: Icon(
                        Icons.person, // User details icon
                        size: 32.0, // Increase icon size
                        color: Colors.teal.shade900, // Icon color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Flutter Activity Recognition'),
//           centerTitle: true,
//         ),
//         body: Container(),
//         floatingActionButton: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             FloatingActionButton(
//               heroTag: "sign_out",
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) =>  SignInScreen()),
//                 );
//               },
//               child: const Icon(Icons.logout),
//             ),
//             const SizedBox(height: 16),
//             FloatingActionButton(
//               heroTag: "activity_screen",
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ActivitiesScreen()),
//                 );
//               },
//               child: const Icon(Icons.view_list),
//             ),
//             const SizedBox(height: 16),
//             FloatingActionButton(
//               heroTag: "activity_report",
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ActivityReportScreen()),
//                 );
//                 // Add logic to handle the activity report button
//                 // Redirect to the report screen or perform any other action
//               },
//               child: const Icon(Icons.analytics),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

}
