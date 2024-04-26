// activity_model.dart
class ActivityModel {
  final int? id;
  final String type;
  final DateTime startTime;
  final int duration;
  final DateTime lastUpdatedTime;

  ActivityModel({required this.type, required this.startTime, required this.duration, required this.lastUpdatedTime, this.id});

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
      id: json['id'],
      type: json['type'],
      startTime: DateTime.parse(json['startTime']),
      duration: json['duration'],
      lastUpdatedTime: DateTime.parse(json['lastUpdatedTime'])
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'startTime': startTime.toIso8601String(),
    'duration': duration,
    'lastUpdatedTime': lastUpdatedTime.toIso8601String()
  };
}
