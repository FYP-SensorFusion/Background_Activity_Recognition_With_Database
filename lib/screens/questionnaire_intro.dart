import 'package:flutter/material.dart';
import 'package:lifespark/color_utils.dart';

Future<void> showBiWeeklyQuestionnaire(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Bi-weekly Questionnaire',
          style: TextStyle(
            color: hexStringToColor(
                "FFFFFF"), // Change this to your desired color
            fontFamily: 'SansSerif', // Change this to your desired font family
          ),
        ),
        content: Text(
          'This is a questionnaire to check your mental health\n\n'
          'GAN-7 (Generalized Anxiety Disorder-7) is a seven-item questionnaire designed to assess the severity of generalized anxiety disorder,\n\n'
          'PHQ-9 (Patient Health Questionnaire-9) is for measuring the severity of depression. It is a self-administered questionnaire with nine items that ask about how often you have experienced certain depression symptoms over the past two weeks.',
          style: TextStyle(
            color: hexStringToColor(
                "FFFFFF"), // Change this to your desired color
            fontFamily: 'SansSerif', // Change this to your desired font family
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Proceed',
              style: TextStyle(
                color: hexStringToColor(
                    "FFFFFF"), // Change this to your desired color
                fontFamily:
                    'SansSerif', // Change this to your desired font family
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
