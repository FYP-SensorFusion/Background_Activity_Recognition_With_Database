  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

  class SleepDurationCard extends StatelessWidget {
    final int sleepDuration;

    const SleepDurationCard({Key? key, required this.sleepDuration})
        : super(key: key);

    @override
    Widget build(BuildContext context) {
      final isGoodSleep = sleepDuration > 420;
      final message = isGoodSleep
          ? "You had a good night's sleep!"
          : "Consider getting more rest tonight.";

      final durationHours = formatDuration(sleepDuration); // Convert minutes to hours

      return Container(
        height: 150.0,
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: isGoodSleep ? Colors.green : Colors.red,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                isGoodSleep
                    ? "You slept $durationHours hours"
                    : "You slept only $durationHours.",
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
