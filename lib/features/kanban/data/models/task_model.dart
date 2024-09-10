import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vida_a_dois/features/kanban/domain/constants/enum/task_importance.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';

class TaskModel extends Task {
  TaskModel({
    super.id,
    required super.title,
    super.description,
    super.assingneeUID,
    super.assingneeInitials,
    super.importance,
    required super.status,
    super.deadline,
    super.createdBy,
    super.createdDate,
  });

  factory TaskModel.fromJson(QueryDocumentSnapshot<Object?> json) {
    final taskId = json.reference.id;

    return TaskModel.fromMap(json.data() as Map<String, dynamic>)
        .copyWith(id: taskId);
  }

  factory TaskModel.fromMap(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      assingneeUID: json['assingneeUID'],
      assingneeInitials: json['assingneeInitials'],
      importance: TaskImportance.fromString(json['importance']),
      status: json['status'],
      deadline: (json['dueDate'] as Timestamp?)?.toDate(),
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
      'importance': importance.name,
      'status': status,
      'dueDate': deadline == null ? null : Timestamp.fromDate(deadline!),
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
      importance: task.importance,
      status: task.status,
      deadline: task.deadline,
      createdBy: task.createdBy,
      createdDate: task.createdDate,
    );
  }

  Task toEntity() => this;

  /// [equalsTo] makes a deep comparison between two [Task] objects
  /// and returns `true` if all parameters match.
  bool equalsTo(TaskModel task) => '$toJson' == '${task.toJson}';

  @override
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? assingneeUID,
    String? assingneeInitials,
    TaskImportance? importance,
    String? status,
    DateTime? dueDate,
    String? createdBy,
    DateTime? createdDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assingneeUID: assingneeUID ?? this.assingneeUID,
      assingneeInitials: assingneeInitials ?? this.assingneeInitials,
      importance: importance ?? this.importance,
      status: status ?? this.status,
      deadline: dueDate ?? deadline,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
