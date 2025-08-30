import 'package:flutter/material.dart';

// defining task class with its properties
class Task {
  final String id;
  final String name;
  final bool completed;

  Task({required this.id, required this.name, required this.completed});

  // to convert firestore maps into Task Objects
  factory Task.fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      name: data["name"] ?? "",
      completed: data["completed"] ?? false,
    );
  }
}
