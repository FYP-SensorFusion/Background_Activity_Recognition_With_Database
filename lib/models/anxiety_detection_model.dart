import 'package:intl/intl.dart';

class AnxietyModel {
  final int? id;
  final DateTime date;
  final double anxietyScore;
  final String anxietyDescription;

  AnxietyModel({this.id, required this.date, required this.anxietyScore, required this.anxietyDescription});

  factory AnxietyModel.fromJson(Map<String, dynamic> json) => AnxietyModel(
      id: json['id'],
      date: DateFormat('yyyy-MM-dd').parse(json['date']),
      anxietyScore: json['anxietyScore'].toDouble(),
      anxietyDescription: json['anxietyDescription'].toString()
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'anxietyScore': anxietyScore,
    'anxietyDescription': anxietyDescription
  };
}