import '../../core/constants/enum/task_importance.dart';

class TaskEntity {
  String? id;
  String title;
  String? description;
  String? assingneeUID;
  String? assingneeInitials;
  TaskImportance taskImportance;
  String status;
  DateTime? dueDate;
  String? createdBy;
  DateTime? createdDate;

  TaskEntity({
    this.id,
    required this.title,
    this.description,
    this.assingneeUID,
    this.assingneeInitials,
    this.taskImportance = TaskImportance.normal,
    required this.status,
    this.dueDate,
    this.createdBy,
    this.createdDate,
  });
}
