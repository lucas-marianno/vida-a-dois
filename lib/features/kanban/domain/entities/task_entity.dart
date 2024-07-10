import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/enum/assignee.dart';

import '../../../../core/constants/enum/task_importance.dart';
import '../../../../core/constants/enum/task_status.dart';

class Task {
  String title;
  String? description;
  Assignee? assingnedTo;
  TaskImportance taskImportance;
  TaskStatus status;
  Timestamp? dueDate;
  Timestamp? createdDate;

  Task({
    required this.title,
    this.description,
    this.assingnedTo,
    this.taskImportance = TaskImportance.normal,
    required this.status,
    this.dueDate,
    this.createdDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title.toString(),
      'description': description.toString(),
      'assingnedTo': assingnedTo.toString(),
      'taskImportance': taskImportance.toString(),
      'status': status.toString(),
      'dueDate': dueDate.toString(),
      'createdDate': createdDate.toString(),
    };
  }
}
