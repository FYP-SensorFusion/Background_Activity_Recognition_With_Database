import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for formatting date/time
import '../models/activity_model.dart';
import '../services/activity_database_helper.dart';

class ActivityScreen extends StatefulWidget {
  final ActivityModel? activity;
  const ActivityScreen({Key? key, this.activity}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState(activity);
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ActivityModel? activity;
  final typeController = TextEditingController();
  final durationController = TextEditingController();
  final startTimeController = TextEditingController();
  _ActivityScreenState(this.activity) {
  }

  @override
  void initState() {
    super.initState();
    if (widget.activity != null) {
      typeController.text = widget.activity!.type;
      durationController.text = widget.activity!.duration.toString();
      startTimeController.text =
          DateFormat('yyyy-MM-dd HH:mm').format(widget.activity!.startTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text(widget.activity == null ? 'Add an Activity' : 'Edit Activity'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Center(
                child: Text(
                  'What are you doing?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: TextFormField(
                controller: typeController,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Type',
                  labelText: 'Activity Type',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 0.75,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: TextField(
                controller: durationController,
                keyboardType: TextInputType.number, // Numeric input
                decoration: const InputDecoration(
                  hintText: 'Enter duration (minutes)',
                  labelText: 'Activity Duration',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 0.75,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            TextField(
              controller: startTimeController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
                labelText: 'Start Time',
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0.75,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              onTap: () async {
                final selectedTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023, 1, 1),
                  lastDate: DateTime.now(),
                );
                if (selectedTime != null) {
                  final selectedTimeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                  );
                  if (selectedTimeOfDay != null) {
                    var startTime = DateTime(
                      selectedTime.year,
                      selectedTime.month,
                      selectedTime.day,
                      selectedTimeOfDay.hour,
                      selectedTimeOfDay.minute,
                    );
                    startTimeController.text =
                        DateFormat('yyyy-MM-dd HH:mm').format(startTime);
                  }
                }
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    final type = typeController.value.text;
                    final enteredDuration = durationController.value.text;
                    final startTimeString = startTimeController.value.text;
                    final startTime = DateTime.parse(startTimeString);
                    final updatedDateTime = DateTime.now();

                    if (type.isEmpty || enteredDuration.isEmpty) {
                      return;
                    }

                    // Validate duration (optional)
                    int? duration;
                    try {
                      duration = int.parse(enteredDuration);
                    } catch (e) {
                      return;
                    }

                    final ActivityModel model = ActivityModel(
                        type: type,
                        startTime: startTime,
                        duration: duration,
                        lastUpdatedTime: updatedDateTime);
                    if (activity == null) {
                      await DatabaseHelper.addActivity(model);
                    } else {
                      await DatabaseHelper.updateActivity(model);
                    }

                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 0.75,
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    widget.activity == null ? 'Save' : 'Edit',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
