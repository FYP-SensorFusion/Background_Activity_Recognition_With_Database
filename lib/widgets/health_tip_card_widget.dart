import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HealthTipCard extends StatelessWidget {
  final String tip;

  const HealthTipCard({Key? key, required this.tip}) : super(key: key);

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
      child: Column( // Changed from Padding to Column
        children: [
          // Header container
          Container(
            padding: const EdgeInsets.all(16.0), // Add some padding
            decoration: BoxDecoration(
              color: Colors.teal.shade700, // Use a darker teal for contrast
              borderRadius: const BorderRadius.only(
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
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Existing card content
          Expanded( // Use Expanded to fill remaining space
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    tip,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.teal.shade900,
                    ),
                    textAlign: TextAlign.center, // Center align the text
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
