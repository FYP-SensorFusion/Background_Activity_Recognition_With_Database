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
          return GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2, // Number of columns
            childAspectRatio: 0.5, // Aspect ratio of the cards
            children: <Widget>[
              ...snapshot.data!.map((report) {
                String formattedDate =
                DateFormat('yyyy-MM-dd').format(report.date);
                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          'Date:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MySansSerif',
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[150],
                            fontFamily: 'MySansSerif',
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Result:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MySansSerif',
                          ),
                        ),
                        Text(
                          ' ${report.result}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[150],
                            fontFamily: 'MySansSerif',
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MySansSerif',
                          ),
                        ),
                        Text(
                          '${report.description}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[150],
                            fontFamily: 'MySansSerif',
                          ),
                        ),
                      ],
                    ),
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
