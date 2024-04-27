import 'package:flutter/material.dart';
import '../models/depression_detection_api_model.dart';
import 'package:http/http.dart' as http;

import '../services/anxiety_depression_database_helper.dart';

class DepressionDetectionAPI extends StatefulWidget {
  const DepressionDetectionAPI({super.key});

  @override
  State<DepressionDetectionAPI> createState() => _DepressionDetectionAPIState();
}

class _DepressionDetectionAPIState extends State<DepressionDetectionAPI> {
  String url = '';
  var data;
  String output = 'Initial Output';

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        String userInput = '';
        return AlertDialog(
          title: Text('How was your day?'),
          content: TextField(
            onChanged: (value) => userInput = value,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () async {
                url = 'http://10.0.2.2:5000/?query=$userInput';
                data = await fetchData(url);
                // Create a new DepressionApiModel instance
                DepressionApiModel model = DepressionApiModel(
                  id: null, // You can set this to null if your database auto-increments the ID
                  date: DateTime.now(),
                  description: userInput,
                  result: data,
                );
                // Save the data to the database
                await DatabaseHelper.addDepressionApiScore(model);
                // Close the current dialog
                Navigator.of(context).pop();
                // Show a new dialog with the result
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Result'),
                      content: Text(data),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMyDialog();
    });
  }

  Future<String> fetchData(String url) async {
    final uri = Uri.parse(url);
    final query = uri.queryParameters['query'];

    if (query == null) {
      throw Exception('Missing required query parameter "query" in the URL.');
    }

    final response = await http.post(uri, body: {'query': query});
    print("Response.body = ${response.body}");
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Flask App'),
      ),
    );
  }
}
