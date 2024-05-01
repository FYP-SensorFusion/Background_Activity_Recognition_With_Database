// step_count_model.dart
class StepCountModel {
  final int? id;
  final int stepCount;
  final DateTime date;

  StepCountModel({required this.stepCount, required this.date, this.id});

  factory StepCountModel.fromJson(Map<String, dynamic> json) => StepCountModel(
      id: json['id'],
      stepCount: json['stepCount'],
      date: DateTime.parse(json['date'])
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'stepCount': stepCount,
    'date': date.toIso8601String()
  };
}
