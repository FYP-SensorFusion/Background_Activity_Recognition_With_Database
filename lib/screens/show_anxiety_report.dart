import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../color_utils.dart';
import '../models/anxiety_detection_model.dart';
import '../services/anxiety_depression_database_helper.dart';

class AnxietyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AnxietyModel>>(
      future: DatabaseHelper.getAllAnxietyScores(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Anxiety Reports',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: hexStringToColor("EAC1FF"))),
                ),
              ),
              ...snapshot.data!.map((report) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(report.date);
                return Card(
                  child: ListTile(
                    title: Text(
                        'Date: $formattedDate\nScore: ${report.anxietyScore}\nDescription: ${report.anxietyDescription}',
                        style:
                            TextStyle(fontSize: 12, fontFamily: 'MySansSerif')),
                  ),
                );
              }).toList(),
            ],
          );
        }
      },
    );
  }
}
