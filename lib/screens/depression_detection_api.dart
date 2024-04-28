import 'package:flutter/material.dart';
import 'package:lifespark/screens/show_anxiety_report.dart';
import 'package:lifespark/screens/show_depression_api_report.dart';
import 'package:lifespark/screens/show_depression_report.dart';
import 'package:lifespark/screens/signin_screen.dart';
import 'package:lifespark/widgets/reusable_widget.dart';
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
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Depression Report'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/purple-sky.png'),
                  fit: BoxFit.fill),
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/black-1.png"),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(20.0)
                  ),
                  reusableTextField(
                      'Tell us about your day?',
                      Icons.lightbulb_sharp,
                      false,
                      TextEditingController(text: userInput)),
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
                  Container(
                    child: ElevatedButton(
                      child: Text(showDepressionApiRecords
                          ? 'Hide Daily Reports'
                          : 'Show Daily Reports'),
                      onPressed: () {
                        setState(() {
                          showDepressionApiRecords = !showDepressionApiRecords;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20), // Add space
                  showDepressionApiRecords ? DepressionApiList() : Container(),
                  SizedBox(height: 20), // Add space
                  ElevatedButton(
                    child: Text(showDepressionRecords
                        ? 'Hide Depression Reports'
                        : "Show Depression Reports"),
                    onPressed: () {
                      setState(() {
                        showDepressionRecords = !showDepressionRecords;
                      });
                    },
                  ),
                  SizedBox(height: 20), // Add space
                  showDepressionRecords ? DepressionList() : Container(),
                  SizedBox(height: 20), // Add space
                  ElevatedButton(
                    child: Text(showAnxietyRecords
                        ? 'Hide Anxiety Reports'
                        : "Show Anxiety Reports"),
                    onPressed: () {
                      setState(() {
                        showAnxietyRecords = !showAnxietyRecords;
                      });
                    },
                  ),
                  SizedBox(height: 20), // Add space
                  showAnxietyRecords ? AnxietyList() : Container(),
                  showAnxietyRecords ? AnxietyList() : Container(),
                ],
              ),
            ),
          ),
        ));
  }
}
