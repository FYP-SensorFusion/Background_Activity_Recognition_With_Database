import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../models/step_count_model.dart';
import '../services/step_database_helper.dart';

class StepScreen extends StatefulWidget {
  const StepScreen({super.key});

  @override
  State<StepScreen> createState() => _StepScreen();
}

class _StepScreen extends State<StepScreen> with WidgetsBindingObserver {
  List<AccelerometerEvent> _accelerometerValues = [];
  int stepCount = 0;
  double previousY = 0.0;
  double previousZ = 0.0;
  DateTime? _lastStepTime;
  String status = "STEADY"; // Add this line
  List<double> timeDifferences = [];
  List<DateTime> stepTimes = [];
  bool isCheckingSteps = true;

  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    DateTime now = DateTime.now();

    // Fetch the step count for today's date when the screen is opened
    DatabaseHelper.getStepCountForDate(DateTime(now.year, now.month, now.day))
        .then((stepCountModel) {
      if (stepCountModel != null) {

        if (mounted) {
          setState(() {
            stepCount = stepCountModel.stepCount;
            print("stepcount $stepCount");
          });
        }
      }
    });

    _accelerometerSubscription = accelerometerEvents.listen((event) {
      if (mounted) {
        setState(() {
          _accelerometerValues = [event];
          computeStepCount(event);
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // print("changed");
    super.dispose();
    print("changed");
    DateTime now = DateTime.now();
    print(stepCount);
    DatabaseHelper.addStepCount(StepCountModel(
        stepCount: stepCount, date: DateTime(now.year, now.month, now.day)));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    DateTime now = DateTime.now();
    // Check if the current time is midnight
    if (now.hour == 0 && now.minute == 0 && now.second == 0) {
      // Update the step count in the database
      print("Midnight, updating step count");
      DatabaseHelper.addStepCount(StepCountModel(
          stepCount: stepCount, date: DateTime(now.year, now.month, now.day-1)));
    }
  }


  void computeStepCount(AccelerometerEvent event) {
    double magnitude =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    var now = DateTime.now();

    // If the time since the last step is more than a threshold, set status to STEADY.
    if (_lastStepTime != null && now.difference(_lastStepTime!).inSeconds > 2) {
      status = "STEADY";
      isCheckingSteps = true;
      stepTimes = [];
      timeDifferences = [];
    }

    // Detect a step when the magnitude of the acceleration crosses a threshold.
    if (magnitude > 12 && (event.y > previousY || event.z > previousZ)) {
      // Add the current time to the list of step times
      stepTimes.add(now);

      // Remove any step times that are more than 2 seconds old
      stepTimes.removeWhere((time) => now.difference(time).inSeconds > 2);

      // Check the time to determine if the user is running or walking.
      if (_lastStepTime != null) {
        var timeDifference = now.difference(_lastStepTime!).inMilliseconds;

        // Add the time difference to the list
        timeDifferences.add(timeDifference.toDouble());

        // Keep only the last 10 time differences
        if (timeDifferences.length > 10) {
          timeDifferences.removeAt(0);
        }

        // Calculate the mean time difference
        var meanTimeDifference =
            timeDifferences.reduce((a, b) => a + b) / timeDifferences.length;

        // If the mean time difference is less than a threshold, the user is running.
        // If there are at least 20 steps in the first 2 seconds if he is running , count it as walking
        // If there are at least 8 steps in the first 2 seconds if he is walking
        if (meanTimeDifference < 100) {
          if (isCheckingSteps && stepTimes.length >= 20) {
            status = "RUNNING";
            stepCount += stepTimes.length;
            isCheckingSteps = false;
          } else if (!isCheckingSteps) {
            stepCount++;
            status = "RUNNING";
          }
        } else if (isCheckingSteps && stepTimes.length >= 10) {
          status = "WALKING";
          stepCount += stepTimes.length;
          isCheckingSteps = false;
        } else if (!isCheckingSteps) {
          stepCount++;
          status = "WALKING";
        }
      }

      _lastStepTime = now;
    }

    previousY = event.y;
    previousZ = event.z;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
        image: const DecorationImage(
          opacity: 0.5,
          image: AssetImage("assets/images/purple-sky.png"),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(16.0),
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
          children: <Widget>[
            const SizedBox(height: 10),
            if (_accelerometerValues.isNotEmpty) ...[
              const Text(
                'Steps:',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                '$stepCount',
                style: const TextStyle(fontSize: 48, color: Colors.white),
              ),
              Text(
                'Status: $status',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              Icon(
                status == "RUNNING"
                    ? Icons.directions_run
                    : status == "WALKING"
                        ? Icons.directions_walk
                        : Icons.accessibility_new,
                size: 50,
              ),
            ] else ...[
              const Text('No data available', style: TextStyle(fontSize: 16)),
            ]
          ],
        ),
      ),
    );
  }
}
