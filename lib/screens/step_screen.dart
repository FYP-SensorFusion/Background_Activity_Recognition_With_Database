import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class StepScreen extends StatefulWidget {
  const StepScreen({super.key});

  @override
  State<StepScreen> createState() => _StepScreen();
}

class _StepScreen extends State<StepScreen> {
  List<AccelerometerEvent> _accelerometerValues = [];
  int stepCount = 0;
  double previousY = 0.0;
  double previousZ = 0.0;
  DateTime? _lastStepTime;
  String status = "STEADY"; // Add this line
  List<double> timeDifferences = [];

  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

  @override
  void initState() {
    super.initState();

    _accelerometerSubscription = accelerometerEvents.listen((event) {
      setState(() {
        _accelerometerValues = [event];
        computeStepCount(event);
      });
    });
  }

  void computeStepCount(AccelerometerEvent event) {
    double magnitude =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    var now = DateTime.now();

    // If the time since the last step is more than a threshold, set status to STEADY.
    if (_lastStepTime != null && now.difference(_lastStepTime!).inSeconds > 2) {
      status = "STEADY";
    }

    // Detect a step when the magnitude of the acceleration crosses a threshold.
    if (magnitude > 11.5 && (event.y > previousY || event.z > previousZ)) {
      stepCount++;

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
        if (meanTimeDifference < 100) {
          status = "RUNNING";
        } else {
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
