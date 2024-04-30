import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../color_utils.dart';
import '../models/anxiety_detection_model.dart';
import '../services/anxiety_depression_database_helper.dart';

class AnxietyDetection extends StatefulWidget {
  final VoidCallback onTestFinished;
  AnxietyDetection({required this.onTestFinished});
  @override
  _AnxietyDetectionState createState() => _AnxietyDetectionState();
}

class _AnxietyDetectionState extends State<AnxietyDetection> {
  List<String> questions = [
    "Feeling nervous, anxious or on edge",
    "Not being able to stop or control worrying",
    "Worrying too much about different things",
    "Trouble relaxing",
    "Being so restless that it is hard to sit still",
    "Becoming easily annoyed or irritable",
    "Feeling afraid as if something awful might happen",
  ];

  late List<double?> anxietyScores;
  late int currentQuestionIndex;

  @override
  void initState() {
    super.initState();
    currentQuestionIndex = 0; // Initialize currentQuestionIndex
    anxietyScores =
        List.filled(questions.length, null); // Initialize anxietyScores
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTestDialog(context);
    });
  }

  void _showTestDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'GAD-7 Anxiety Test',
                style: TextStyle(
                  color: hexStringToColor(
                      "FFFFFF"),
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    LinearProgressIndicator(
                      value: currentQuestionIndex / (questions.length - 1),
                    ),
                    ListTile(title: Text(questions[currentQuestionIndex])),
                    RadioListTile<double>(
                      title: Text('Nearly every day'),
                      value: 3,
                      groupValue: anxietyScores[currentQuestionIndex],
                      onChanged: (double? value) {
                        setState(() {
                          anxietyScores[currentQuestionIndex] = value;
                        });
                      },
                    ),
                    RadioListTile<double>(
                      title: Text('More than half the days'),
                      value: 2,
                      groupValue: anxietyScores[currentQuestionIndex],
                      onChanged: (double? value) {
                        setState(() {
                          anxietyScores[currentQuestionIndex] = value;
                        });
                      },
                    ),
                    RadioListTile<double>(
                      title: Text('Several days'),
                      value: 1,
                      groupValue: anxietyScores[currentQuestionIndex],
                      onChanged: (double? value) {
                        setState(() {
                          anxietyScores[currentQuestionIndex] = value;
                        });
                      },
                    ),
                    RadioListTile<double>(
                      title: Text('Not at all'),
                      value: 0,
                      groupValue: anxietyScores[currentQuestionIndex],
                      onChanged: (double? value) {
                        setState(() {
                          anxietyScores[currentQuestionIndex] = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: currentQuestionIndex > 0
                              ? () {
                                  setState(() {
                                    currentQuestionIndex--;
                                  });
                                }
                              : null,
                          child: Text('Back'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (anxietyScores[currentQuestionIndex] == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.black87,
                                  content: Text(
                                      'Please select an answer before proceeding.',
                                    style: TextStyle(
                                      color: Colors.white
                                    ),),
                                ),
                              );
                            } else if (currentQuestionIndex <
                                questions.length - 1) {
                              setState(() {
                                currentQuestionIndex++;
                              });
                            } else {
                              double score =
                                  anxietyScores.reduce((a, b) => a! + b!) ??
                                      0.0;
                              String result;
                              if (score < 5) {
                                result = "Minimal anxiety";
                              } else if (score < 10) {
                                result = "Mild anxiety";
                              } else if (score < 15) {
                                result = "Moderate anxiety";
                              } else {
                                result = "Severe anxiety.";
                              }
                              Navigator.pop(context);

                              AnxietyModel anxietyModel = AnxietyModel(
                                  date: DateTime.now(),
                                  anxietyScore: score,
                                  anxietyDescription: result);
                              DatabaseHelper.addAnxietyScore(anxietyModel);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('GAD-7 Test Result',
                                      style: TextStyle(
                                        color: hexStringToColor(
                                            "FFFFFF"),
                                      ),),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('score: $score.',
                                            style: TextStyle(
                                              color: hexStringToColor(
                                                  "FFFFFF"),
                                              fontSize: 48
                                            ),),
                                          Text(result,
                                            style: TextStyle(
                                              color: hexStringToColor(
                                                  "FFFFFF"),
                                            ),),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK',
                                          style: TextStyle(
                                            color: hexStringToColor(
                                                "FFFFFF"),
                                            fontSize: 48
                                          ),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          submitTest();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text(
                              currentQuestionIndex < questions.length - 1
                                  ? 'Next'
                                  : 'Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anxiety Test'),
      ),
    );
  }

  void submitTest() {
    widget.onTestFinished();
  }
}

class ResultScreen extends StatelessWidget {
  final double score;
  final String result;

  ResultScreen({Key? key, required this.score, required this.result})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Your score is $score.'),
            Text(result),
          ],
        ),
      ),
    );
  }
}
