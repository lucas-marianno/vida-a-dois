import 'package:cloud_firestore/cloud_firestore.dart';

import 'person_entity.dart';

import '../../../../core/constants/enum/task_importance.dart';
import '../../../../core/constants/enum/task_status.dart';

class Task {
  final String title;
  final String? description;
  final Person? assingnedTo;
  final TaskImportance taskImportance;
  final TaskStatus status;
  final Timestamp? dueDate;
  final Timestamp? createdDate;

  const Task({
    required this.title,
    this.description,
    this.assingnedTo,
    this.taskImportance = TaskImportance.normal,
    required this.status,
    this.dueDate,
    this.createdDate,
  });

  static List<String> get atributes => [
        'title',
        'description',
        'assingnedTo',
        'taskImportance',
        'status',
        'dueDate',
        'createdDate',
      ];
}
