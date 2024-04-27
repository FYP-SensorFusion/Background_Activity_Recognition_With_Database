import 'package:background_activity_recognition_with_database/models/depression_detection_model.dart';
import 'package:background_activity_recognition_with_database/services/anxiety_depression_database_helper.dart';
import 'package:flutter/material.dart';

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
    depressionScores = List.filled(questions.length, null); // Initialize depressionScores
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
              title: Text('Depression Test'),
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
                                  content: Text(
                                      'Please select an answer before proceeding.'),
                                ),
                              );
                            } else
                            if (currentQuestionIndex < questions.length - 1) {
                              setState(() {
                                currentQuestionIndex++;
                              });
                            } else {
                              double score = depressionScores.reduce((a,
                                  b) => a! + b!) ?? 0.0;
                              String result;
                              if (score < 5) {
                                result = "You do not have depression";
                              } else if (score < 10) {
                                result = "You have mild depression";
                              } else if (score < 15) {
                                result = "You have moderate depression";
                              } else if (score < 20) {
                                result =
                                "You have moderately severe depression";
                              } else {
                                result = "You have severe depression.";
                              }
                              Navigator.pop(context);

                              DepressionModel depressionModel = DepressionModel(
                                  date: DateTime.now(),
                                  depressionScore: score,
                                  depressionDescription: result
                              );
                              DatabaseHelper.addDepressionScore(depressionModel);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Test Result'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Your score is $score.'),
                                          Text(result),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
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
        title: Text('Depression Test'),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final double score;
  final String result;

  ResultScreen(
      {Key? key,
        required this.score,
        required this.result})
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