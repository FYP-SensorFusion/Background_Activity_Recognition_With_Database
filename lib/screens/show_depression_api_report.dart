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
            childAspectRatio: 0.9, // Aspect ratio of the cards
            children: <Widget>[
              ...snapshot.data!.map((report) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(report.date);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: 300), // Set your desired height here
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                        child: Card(
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
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[150],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Result:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' ${report.result}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[150],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Description:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${report.description}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[150],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
