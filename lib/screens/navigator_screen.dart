import 'package:background_activity_recognition_with_database/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:background_activity_recognition_with_database/screens/activities_screen.dart';
import 'package:background_activity_recognition_with_database/screens/activity_report_screen.dart';

class NavigatorPage extends StatefulWidget {
  NavigatorPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _currentIndex = 0; // Index for the selected tab

  final List<Widget> _screens = [
    MyHomePage(title: "Life Spark"),
    ActivitiesScreen(), // Replace with your actual screens
    ActivityReportScreen(),
    ActivityReportScreen(),
    ActivityReportScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Activity Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Depression Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User Profile',
          ),
        ],
        selectedItemColor: Colors.teal.shade900,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.teal.shade100,
      ),
    );
  }
}
