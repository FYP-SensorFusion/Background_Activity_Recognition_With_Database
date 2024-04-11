import 'package:flutter/material.dart';

import '../models/activity_model.dart';
import '../services/activity_database_helper.dart';


class ActivityScreen extends StatelessWidget {
  final ActivityModel? activity;
  const ActivityScreen({
    super.key,
    this.activity
  });

  @override
  Widget build(BuildContext context) {
    final typeController = TextEditingController();
    final durationController = TextEditingController();

    if(activity != null){
      typeController.text = activity!.type;
      durationController.text = activity!.duration;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text( activity == null
            ? 'Add a Activity'
            : 'Edit Activity'
        ),
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
                        ))),
              ),
            ),
            TextFormField(
              controller: durationController,
              decoration: const InputDecoration(
                  hintText: 'Type here the duration',
                  labelText: 'Activity Duration',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 0.75,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ))),
              keyboardType: TextInputType.multiline,
              onChanged: (str) {},
              maxLines: 5,
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
                      final duration = durationController.value.text;
                      final updatedDateTime = DateTime.now();

                      if (type.isEmpty || duration.isEmpty) {
                        return;
                      }

                      final ActivityModel model = ActivityModel(type: type, startTime: updatedDateTime, duration: duration, lastUpdatedTime: updatedDateTime);
                      if(activity == null){
                        await DatabaseHelper.addActivity(model);
                      }else{
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
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                )))),
                    child: Text( activity == null
                        ? 'Save' : 'Edit',
                      style: const TextStyle(fontSize: 20),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
