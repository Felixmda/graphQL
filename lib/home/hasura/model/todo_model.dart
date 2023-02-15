// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Todo {
  Todo({
     this.id,
    required this.task,
    required this.completed,
  });

  int? id;
  String task;
  bool completed;

  factory Todo.fromRawJson(String str) => Todo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json["id"] ?? '',
    task: json["task"],
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "id": id ?? '',
    "task": task,
    "completed": completed,
  };
}
