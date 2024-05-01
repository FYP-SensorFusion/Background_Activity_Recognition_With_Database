  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

  class SleepDurationCard extends StatelessWidget {
    final int sleepDuration;

    const SleepDurationCard({Key? key, required this.sleepDuration})
        : super(key: key);

    @override
    Widget build(BuildContext context) {
      final isGoodSleep = sleepDuration >= 420;
      final message = isGoodSleep
          ? "You had a good\nnight's sleep!"
          : "Consider getting\nmore rest tonight.";

      final durationHours = formatDuration(sleepDuration); // Convert minutes to hours

      return Container(
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(left:10 ,right:24 , top:10 , bottom:10 ),
        decoration: BoxDecoration(
          image: const DecorationImage(
            opacity: 0.5,
            image: AssetImage("assets/images/purple-sky.png"),
            fit: BoxFit.fill,
          ),
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
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                isGoodSleep
                    ? "You slept $durationHours hours"
                    : "You slept only $durationHours.",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
