import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/enum/assignee.dart';

import '../../../../core/constants/enum/task_importance.dart';
import '../../../../core/constants/enum/task_status.dart';

class Task {
  String? id;
  String title;
  String? description;
  Assignee assingnedTo;
  TaskImportance taskImportance;
  TaskStatus status;
  Timestamp? dueDate;
  Timestamp? createdDate;

  Task({
    this.id,
    required this.title,
    this.description,
    this.assingnedTo = Assignee.anyone,
    this.taskImportance = TaskImportance.normal,
    this.status = TaskStatus.todo,
    this.dueDate,
    this.createdDate,
  });

  factory Task.fromJson(Map<String, dynamic> json, String documentId) {
    return Task(
      id: documentId,
      title: json['title'],
      description: json['description'],
      assingnedTo: Assignee.fromString(json['assingnedTo']),
      taskImportance: TaskImportance.fromString(json['taskImportance']),
      status: TaskStatus.fromString(json['taskStatus']),
      dueDate: json['dueDate'],
      createdDate: json['createdDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title.toString(),
      'description': description.toString(),
      'assingnedTo': assingnedTo.name,
      'taskImportance': taskImportance.name,
      'status': status.name,
      'dueDate': dueDate,
      'createdDate': createdDate,
    };
  }
}
