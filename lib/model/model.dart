import 'package:get/get.dart';

class Task {
  String title;
  String description;
  String dueDate;
  RxBool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    bool isCompleted = false,
  }) : isCompleted = RxBool(isCompleted);
// This is data in KEY and VAlUE
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'isCompleted': isCompleted.value,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'],
      isCompleted: json['isCompleted'],
    );
  }
}
