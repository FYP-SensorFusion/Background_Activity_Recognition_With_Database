import 'package:flutter/material.dart';
import 'package:lifespark/screens/show_anxiety_report.dart';
import 'package:lifespark/screens/show_depression_api_report.dart';
import 'package:lifespark/screens/show_depression_report.dart';
import '../models/anxiety_detection_model.dart';
import '../models/depression_detection_api_model.dart';
import 'package:http/http.dart' as http;

import '../models/depression_detection_model.dart';
import '../services/anxiety_depression_database_helper.dart';

class DepressionDetectionApi extends StatefulWidget {
  const DepressionDetectionApi({super.key});

  @override
  State<DepressionDetectionApi> createState() => _DepressionDetectionApiState();
}

class _DepressionDetectionApiState extends State<DepressionDetectionApi> {
  String url = '';
  var data;
  String output = '';
  String userInput = '';

  List<DepressionApiModel>? depressionApiReports;
  List<DepressionModel>? depressionReports;
  List<AnxietyModel>? anxietyReports;

  bool showDepressionApiRecords = false;
  bool showDepressionRecords = false;
  bool showAnxietyRecords = false;

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
  void initState() {
    super.initState();
    DatabaseHelper.getAllDepressionApiScores().then((value) {
      setState(() {
        depressionApiReports = value;
      });
    });
    DatabaseHelper.getAllDepressionScores().then((value) {
      setState(() {
        depressionReports = value;
      });
    });
    DatabaseHelper.getAllAnxietyScores().then((value) {
      setState(() {
        anxietyReports = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Depression Report'),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    'Tell us about your day?',
                    style: TextStyle(
                      fontSize: 24, // Change this to your desired size
                      color:
                          Colors.lightBlue, // Change this to your desired color
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextField(
                  controller: TextEditingController(text: userInput),
                  onChanged: (value) {
                    userInput = value;
                  },
                  decoration: InputDecoration(
                    fillColor:
                        Colors.white, // Change this to your desired color
                    filled: true,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => userInput = ''),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black, // Change this to your desired color
                  ),
                ),
                TextButton(
                  child: Text(
                    'Submit',
                  ),
                  onPressed: () async {
                    url = 'http://10.0.2.2:5000/?query=$userInput';
                    output = await fetchData(url);
                    // Create a new DepressionApiModel instance
                    DepressionApiModel model = DepressionApiModel(
                      id: null, // You can set this to null if your database auto-increments the ID
                      date: DateTime.now(),
                      description: userInput,
                      result: output,
                    );
                    // Save the data to the database
                    await DatabaseHelper.addDepressionApiScore(model);
                    setState(() {});
                  },
                ),
                Text(
                  '$output',
                  style: TextStyle(
                    fontSize: 24, // Change this to your desired size
                    color:
                        Colors.lightBlue, // Change this to your desired color
                  ),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  child: Text('Show Depression Records'),
                  onPressed: () {
                    setState(() {
                      showDepressionApiRecords = !showDepressionApiRecords;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('Show Depression Reports'),
                  onPressed: () {
                    setState(() {
                      showDepressionRecords = !showDepressionRecords;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('Show Anxiety Reports'),
                  onPressed: () {
                    setState(() {
                      showAnxietyRecords = !showAnxietyRecords;
                    });
                  },
                ),
                showDepressionApiRecords ? DepressionApiList() : Container(),
                showDepressionRecords ? DepressionList() : Container(),
                showAnxietyRecords ? AnxietyList() : Container(),
              ],
            ),
          ),
        ));
  }
}
