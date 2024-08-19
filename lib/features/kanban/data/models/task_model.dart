import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/features/kanban/domain/constants/enum/task_importance.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

class TaskModel extends Task {
  TaskModel({
    super.id,
    required super.title,
    super.description,
    super.assingneeUID,
    super.assingneeInitials,
    super.taskImportance = TaskImportance.normal,
    required super.status,
    super.dueDate,
    super.createdBy,
    super.createdDate,
  });

  factory TaskModel.fromJson(QueryDocumentSnapshot<Object?> json) {
    final taskId = json.reference.id;

    return TaskModel.fromMap(json.data() as Map<String, dynamic>)..id = taskId;
  }

  factory TaskModel.fromMap(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      assingneeUID: json['assingneeUID'],
      assingneeInitials: json['assingneeInitials'],
      taskImportance: TaskImportance.fromString(json['taskImportance']),
      status: json['status'],
      dueDate: (json['dueDate'] as Timestamp?)?.toDate(),
      createdBy: json['createdBy'],
      createdDate: (json['createdDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> get toJson {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assingneeUID': assingneeUID,
      'assingneeInitials': assingneeInitials,
      'taskImportance': taskImportance.name,
      'status': status,
      'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate!),
      'createdBy': createdBy,
      'createdDate':
          createdDate == null ? null : Timestamp.fromDate(createdDate!),
    };
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
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
  }

  Task toEntity() => this;

  /// [equalsTo] makes a deep comparison between two [Task] objects
  /// and returns `true` if all parameters match.
  bool equalsTo(TaskModel task) => '$toJson' == '${task.toJson}';

  TaskModel copy() => TaskModel.fromMap(toJson);
}
