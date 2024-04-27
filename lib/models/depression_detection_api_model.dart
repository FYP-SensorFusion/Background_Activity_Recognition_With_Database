class DepressionApiModel {
  final int? id;
  final DateTime date;
  final String description;
  final String result;

  DepressionApiModel({this.id, required this.date, required this.description, required this.result});

  factory DepressionApiModel.fromJson(Map<String, dynamic> json) => DepressionApiModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      description: json['description'].toString(),
      result: json['result'].toString()
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'description': description,
    'result': result
  };
}