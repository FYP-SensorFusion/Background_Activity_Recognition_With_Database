import 'package:device_apps/device_apps.dart';
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
  late List<String> installedApps;

  final excludedApps = [
    "background_bctivity_recognition_with_database",
    "lifespark"
  ]; // List of apps to exclude

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      installedApps = await getInstalledApps();
      getMostUsedApps();
    });
  }
  Future<List<String>> getInstalledApps() async {
    List installedApps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: true,
    );
    List<String> applicationNames = [];
    for (final app in installedApps) {
      applicationNames.add(app.appName.toLowerCase().replaceAll(" ", ""));
    }
    return applicationNames;
  }

  void getMostUsedApps() async {
    try {
      DateTime now = DateTime.now();
      DateTime oneMinuteAgo = now.subtract(const Duration(hours: 24));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(oneMinuteAgo, now);
      // Sort apps by usage time in descending order
      infoList.sort((a, b) => b.usage.inSeconds - a.usage.inSeconds);

      // Filter out excluded apps and get the top 5 (including replacements)
      List<AppUsageInfo> topFive = _getTopFiveExcluding(infoList);
      if (mounted) {setState(() => _mostUsedApps = topFive);}
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  List<AppUsageInfo> _getTopFiveExcluding(List<AppUsageInfo> allApps) {
    List<AppUsageInfo> filteredApps = allApps
        .where((app) => installedApps.contains(app.appName))
        .toList(); // Filter excluded apps
    // If filtered list has less than 3 apps, add the remaining top apps from the original list
    if (filteredApps.length < 5) {
      int remaining = 5 - filteredApps.length;
      filteredApps.addAll(allApps
          .sublist(0, remaining)
          .where((app) => !filteredApps.contains(app.appName)));
    }
    return filteredApps.sublist(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 28),
      decoration: BoxDecoration(
        image: const DecorationImage(
          opacity: 0.6,
          image: AssetImage("assets/images/purple-sky.png"),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          // Header container
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage("assets/images/purple-sky.png"),
                fit: BoxFit.fill,
              ),
              color: Colors.purple.shade200, // Use a darker teal for contrast
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
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          // Existing carousel content
          _mostUsedApps.isEmpty
              ? const Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : CarouselSlider(
                  items: _mostUsedApps
                      .map((appInfo) => _buildAppCard(appInfo))
                      .toList(),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.15,
                    // Adjust height as needed
                    viewportFraction: 0.8,
                    // Adjust visibility of each app card
                    enableInfiniteScroll: true,
                    // Since we have 5 apps
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
            "#$index ${appInfo.appName.toUpperCase()}", // Combine position and app name
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0), // Add some spacing
          Text(
            "${duration.inMinutes}m ${duration.inSeconds % 60}s",
            // Format duration (minutes and seconds)
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
