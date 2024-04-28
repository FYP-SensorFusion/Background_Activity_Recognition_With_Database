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
    // print("Response.body = ${response.body}");
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
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 30.0),
                  ),
                  // reusableTextField_API('How has your day been?', Icons.lightbulb_outline_rounded, false, TextEditingController(text: userInput)),
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    child: TextField(
                      controller: TextEditingController(text: userInput),
                      onChanged: (value) {
                        userInput = value;
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      obscureText: false,
                      enableSuggestions: true,
                      autocorrect: true,
                      autofocus: false,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lightbulb_outline_rounded,
                          color: Colors.white70,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => userInput = ''),
                          icon: Icon(Icons.clear),
                        ),
                        labelText: 'How has your day been?',
                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
                      ),
                    ),
                  ),

                  TextButton(
                    child: Text(
                      'Submit',
                    ),
                    onPressed: () async {
                      print('userInput = $userInput');
                      url = 'http://10.0.2.2:5000/?query=$userInput';
                      // url = 'https://dashboard.render.com/d/dpg-con5kigcmk4c739v7lm0-a:5432/?query=$userInput';
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

                      // Check if output is not equal to "There was an error while processing the content."
                      if (output != "There was an error while processing the content.") {
                        String contentOutput = "";
                        if (output == "Depression") {
                          contentOutput = "You show symptoms of Depression";
                        } else if (output == "Not Depression") {
                          contentOutput = "You do not show any symptoms of Depression";
                        } else {
                          contentOutput = "I am unable to show any symptoms";
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(
                                '$contentOutput',
                                style: TextStyle(
                                  fontSize: 24, // Change this to your desired size
                                  color: Colors.white, // Change this to your desired color
                                ),
                                textAlign: TextAlign.center,
                              ),
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
                      }
                    },
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
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
                  SizedBox(height: 10),
                  showDepressionApiRecords ? DepressionApiList() : Container(),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    child: ElevatedButton(
                      child: Text(showDepressionRecords
                          ? 'Hide Depression Reports'
                          : "Show Depression Reports"),
                      onPressed: () {
                        setState(() {
                          showDepressionRecords = !showDepressionRecords;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  showDepressionRecords ? DepressionList() : Container(),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    child: ElevatedButton(
                      child: Text(showAnxietyRecords
                          ? 'Hide Anxiety Reports'
                          : "Show Anxiety Reports"),
                      onPressed: () {
                        setState(() {
                          showAnxietyRecords = !showAnxietyRecords;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  showAnxietyRecords ? AnxietyList() : Container(),
                ],
              ),
            ),
          ),
        ));
  }
}