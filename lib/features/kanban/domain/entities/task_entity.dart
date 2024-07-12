import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/enum/task_assignee.dart';

import '../../../../core/constants/enum/task_importance.dart';
import '../../../../core/constants/enum/task_status.dart';

class Task {
  String? id;
  String title;
  String? description;
  TaskAssignee assingnee;
  TaskImportance taskImportance;
  TaskStatus status;
  Timestamp? dueDate;
  Timestamp? createdDate;

  Task({
    this.id,
    required this.title,
    this.description,
    this.assingnee = TaskAssignee.anyone,
    this.taskImportance = TaskImportance.normal,
    this.status = TaskStatus.todo,
    this.dueDate,
    this.createdDate,
  });

  factory Task.fromJson(QueryDocumentSnapshot<Object?> json) {
    final taskId = json.reference.id;

    return Task.fromMap(json.data() as Map<String, dynamic>)..id = taskId;
  }

  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      assingnee: TaskAssignee.fromString(json['assingnedTo']),
      taskImportance: TaskImportance.fromString(json['taskImportance']),
      status: TaskStatus.fromString(json['status']),
      dueDate: json['dueDate'],
      createdDate: json['createdDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assingnedTo': assingnee.name,
      'taskImportance': taskImportance.name,
      'status': status.name,
      'dueDate': dueDate,
      'createdDate': createdDate,
    };
  }

  Task copy() => Task.fromMap(toJson());
}
