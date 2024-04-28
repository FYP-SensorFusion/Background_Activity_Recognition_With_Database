import 'package:intl/intl.dart';

class DepressionModel {
  final int? id;
  final DateTime date;
  final double depressionScore;
  final String depressionDescription;

  DepressionModel({this.id, required this.date, required this.depressionScore, required this.depressionDescription});

  factory DepressionModel.fromJson(Map<String, dynamic> json) => DepressionModel(
      id: json['id'],
      date: DateFormat('yyyy-MM-dd').parse(json['date']),
      depressionScore: json['depressionScore'].toDouble(),
      depressionDescription: json['depressionDescription'].toString()
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'depressionScore': depressionScore,
    'depressionDescription': depressionDescription
  };
}