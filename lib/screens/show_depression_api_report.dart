import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifespark/color_utils.dart';

import '../models/depression_detection_api_model.dart';
import '../services/anxiety_depression_database_helper.dart';

class DepressionApiList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DepressionApiModel>>(
      future: DatabaseHelper.getAllDepressionApiScores(),
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
                  child: Text('Depression Records',
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
                    subtitle: Text(
                        'Date: $formattedDate\nDescription: ${report.description}\nResult: ${report.result}',
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
