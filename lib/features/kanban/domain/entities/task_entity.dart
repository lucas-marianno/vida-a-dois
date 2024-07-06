import 'person_entity.dart';

import '../../../../core/constants/enum/task_importance.dart';
import '../../../../core/constants/enum/task_status.dart';

class Task {
  final String? id;
  final String title;
  final String? description;
  final Person? assingnedTo;
  final TaskImportance taskImportance;
  final TaskStatus status;
  final DateTime? dueDate;
  final DateTime? createdDate;

  const Task({
    this.id,
    required this.title,
    this.description,
    this.assingnedTo,
    this.taskImportance = TaskImportance.normal,
    required this.status,
    this.dueDate,
    this.createdDate,
  });
}
