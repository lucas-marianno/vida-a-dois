import '../constants/enum/task_importance.dart';

class Task {
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

  Task({
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

  factory Task.copyFrom(Task task) => Task(
        id: task.id,
        title: task.title,
        description: task.description,
        assingneeUID: task.assingneeUID,
        assingneeInitials: task.assingneeInitials,
        taskImportance: task.taskImportance,
        status: task.status,
        dueDate: task.dueDate,
        createdBy: task.createdBy,
        createdDate: task.createdDate,
      );

  Map<String, dynamic> get asMap => {
        'id': id,
        'title': title,
        'description': description,
        'assingneeUID': assingneeUID,
        'assingneeInitials': assingneeInitials,
        'taskImportance': taskImportance,
        'status': status,
        'dueDate': dueDate,
        'createdBy': createdBy,
        'createdDate': createdDate,
      };

  @override
  String toString() => asMap.toString();

  @override
  bool operator ==(covariant Task other) => toString() == other.toString();

  @override
  int get hashCode => toString().hashCode;
}
