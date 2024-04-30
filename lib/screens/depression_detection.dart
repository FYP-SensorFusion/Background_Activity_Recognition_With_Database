import 'package:lifespark/models/depression_detection_model.dart';
import 'package:lifespark/services/anxiety_depression_database_helper.dart';
import 'package:flutter/material.dart';

import '../color_utils.dart';

class DepressionDetection extends StatefulWidget {
  @override
  _DepressionDetectionState createState() => _DepressionDetectionState();
}

class _DepressionDetectionState extends State<DepressionDetection> {
  List<String> questions = [
    "Little interest or pleasure in doing things",
    "Feeling down, depressed or hopeless",
    "Trouble falling asleep, staying asleep, or sleeping too much",
    "Feeling tired or having little energy",
    "Poor appetite or overeating",
    "Feeling bad about yourself - or that you’re a failure or have let yourself or your family down",
    "Trouble concentrating on things, such as reading the newspaper or watching television",
    "Moving or speaking so slowly that other people could have noticed. Or, the opposite - being so fidgety or restless that you have been moving around a lot more than usual",
    "Thoughts that you would be better off dead or of hurting yourself in some way",
  ];

  late List<double?> depressionScores;
  late int currentQuestionIndex;

  @override
  void initState() {
    super.initState();
    currentQuestionIndex = 0; // Initialize currentQuestionIndex
    depressionScores =
        List.filled(questions.length, null); // Initialize depressionScores
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
                'PHQ-9 Depression Test',
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
                      groupValue: depressionScores[currentQuestionIndex],
                      onChanged: (double? value) {
                        setState(() {
                          depressionScores[currentQuestionIndex] = value;
                        });
                      },
                    ),
                    RadioListTile<double>(
                      title: Text('More than half the days'),
                      value: 2,
                      groupValue: depressionScores[currentQuestionIndex],
                      onChanged: (double? value) {
                        setState(() {
                          depressionScores[currentQuestionIndex] = value;
                        });
                      },
                    ),
                    RadioListTile<double>(
                      title: Text('Several days'),
                      value: 1,
                      groupValue: depressionScores[currentQuestionIndex],
                      onChanged: (double? value) {
                        setState(() {
                          depressionScores[currentQuestionIndex] = value;
                        });
                      },
                    ),
                    RadioListTile<double>(
                      title: Text('Not at all'),
                      value: 0,
                      groupValue: depressionScores[currentQuestionIndex],
                      onChanged: (double? value) {
                        setState(() {
                          depressionScores[currentQuestionIndex] = value;
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
                            if (depressionScores[currentQuestionIndex] ==
                                null) {
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
                                  depressionScores.reduce((a, b) => a! + b!) ??
                                      0.0;
                              String result;
                              if (score < 5) {
                                result = "Minimal depression";
                              } else if (score < 10) {
                                result = "Mild depression";
                              } else if (score < 15) {
                                result = "Moderate depression";
                              } else if (score < 20) {
                                result = "Moderately severe depression";
                              } else {
                                result = "Severe depression.";
                              }
                              Navigator.pop(context);

                              DepressionModel depressionModel = DepressionModel(
                                  date: DateTime.now(),
                                  depressionScore: score,
                                  depressionDescription: result);
                              DatabaseHelper.addDepressionScore(
                                  depressionModel);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('PHQ-9 Test Result',
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
                                              fontSize: 48
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
                                          ),),
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
        title: const Text('Depression Test'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/purple-sky.png'),
                fit: BoxFit.fill),
          ),
        ),
      ),
    );
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
