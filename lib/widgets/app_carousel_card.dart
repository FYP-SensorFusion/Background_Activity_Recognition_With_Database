import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AppCarouselCard extends StatefulWidget {
  @override
  _AppCarouselCardState createState() => _AppCarouselCardState();
}

class _AppCarouselCardState extends State<AppCarouselCard> {
  List<AppUsageInfo> _mostUsedApps = [];
  int _currentAppIndex = 0;

  final excludedApps = [
    "background_bctivity_recognition_with_database",
    "lifespark"
  ]; // List of apps to exclude

  @override
  void initState() {
    super.initState();
    getMostUsedApps();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getMostUsedApps();
  }

  void getMostUsedApps() async {
    try {
      DateTime now = DateTime.now();
      DateTime oneMinuteAgo = now.subtract(Duration(minutes: 1));
      List<AppUsageInfo> infoList =
      await AppUsage().getAppUsage(oneMinuteAgo, now);
      // Sort apps by usage time in descending order
      infoList.sort((a, b) => b.usage.inSeconds - a.usage.inSeconds);

      // Filter out excluded apps and get the top 3 (including replacements)
      List<AppUsageInfo> topThree = _getTopThreeExcluding(infoList);
      setState(() => _mostUsedApps = topThree);
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  List<AppUsageInfo> _getTopThreeExcluding(List<AppUsageInfo> allApps) {
    List<AppUsageInfo> filteredApps = allApps
        .where((app) => !excludedApps.contains(app.appName))
        .toList(); // Filter excluded apps

    // If filtered list has less than 3 apps, add the remaining top apps from the original list
    if (filteredApps.length < 3) {
      int remaining = 3 - filteredApps.length;
      filteredApps.addAll(allApps
          .sublist(0, remaining)
          .where((app) => !filteredApps.contains(app.appName)));
    }

    return filteredApps.sublist(0, 3); // Get the top 3 (including replacements)
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          kToolbarHeight -
          kBottomNavigationBarHeight -
          32.0,
      margin: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.teal.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade100,
            blurRadius: 1.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header container
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.teal.shade700, // Use a darker teal for contrast
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Most Used Apps',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Existing carousel content
          _mostUsedApps.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : CarouselSlider(
            items: _mostUsedApps
                .map((appInfo) => _buildAppCard(appInfo))
                .toList(),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.15,
              // Adjust height as needed
              viewportFraction: 0.8,
              // Adjust visibility of each app card
              enableInfiniteScroll: false,
              // Since we have 3 apps
              autoPlay: true,
              // Enable autoplay
              autoPlayInterval: Duration(seconds: 3),
              // Change interval as needed
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              // Adjust animation duration
              onPageChanged: (index, reason) =>
                  setState(() => _currentAppIndex = index),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAppCard(AppUsageInfo appInfo) {
    final duration =
    Duration(seconds: appInfo.usage.inSeconds); // Convert usage to Duration
    final index =
        _mostUsedApps.indexOf(appInfo) + 1; // Get app position (1-based)

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "#$index ${appInfo.appName}", // Combine position and app name
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.teal.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0), // Add some spacing
          Text(
            "${duration.inMinutes}m ${duration.inSeconds % 60}s",
            // Format duration (minutes and seconds)
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.teal.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
