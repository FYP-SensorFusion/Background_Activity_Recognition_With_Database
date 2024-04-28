import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../color_utils.dart';
import '../models/depression_detection_model.dart';
import '../services/anxiety_depression_database_helper.dart';

class DepressionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DepressionModel>>(
      future: DatabaseHelper.getAllDepressionScores(),
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
            childAspectRatio: 1, // Aspect ratio of the cards
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
                          'PHQ-9 Score:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MySansSerif',
                          ),
                        ),
                        Text(
                          ' ${report.depressionScore}',
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
                          '${report.depressionDescription}',
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
