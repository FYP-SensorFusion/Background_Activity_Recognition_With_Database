import 'package:flutter/material.dart';
class HealthTipCard extends StatelessWidget {
  final String tip;
  final IconData iconData;

  const HealthTipCard({Key? key, required this.tip, required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          kToolbarHeight -
          kBottomNavigationBarHeight -
          32.0,
      margin: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        image: const DecorationImage(
          opacity: 0.6,
          image: AssetImage("assets/images/purple-sky.png"),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack( // Use Stack for overlapping elements
        children: [
          // Header container
          Positioned( // Position header at top
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.all(16.0), // Add some padding
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/purple-sky.png'),
                    fit: BoxFit.fill),
                color: Colors.purple, // Use a darker teal for contrast
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: const Row( // Add a Row for horizontal layout
                mainAxisAlignment: MainAxisAlignment.center, // Center the text
                children: [
                  Text(
                    'Health Tips',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                    ),

                  ),
                ],
              ),
            ),
          ),
          // Tip and icon container with padding
          Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 24.0, right: 24.0,), // Adjust padding as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to left
              children: [
                Column( // Combine icon and tip within Row
                  children: [
                    Icon(
                      iconData,
                      color: Colors.white,
                      size: 48.0, // Adjust icon size as needed
                    ),
                    const SizedBox(width: 16.0), // Add spacing between icon and text
                    Container( // Wrap text for better overflow handling
                      child: Text(
                        tip,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center, // Justify alignment for better text layout
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
