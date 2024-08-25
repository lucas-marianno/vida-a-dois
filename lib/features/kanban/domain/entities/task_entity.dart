import '../constants/enum/task_importance.dart';

class Task {
  final String? id;
  final String title;
  final String? description;
  final String? assingneeUID;
  final String? assingneeInitials;
  final TaskImportance taskImportance;
  final String status;
  final DateTime? dueDate;
  final String? createdBy;
  final DateTime? createdDate;

  const Task({
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

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? assingneeUID,
    String? assingneeInitials,
    TaskImportance? taskImportance,
    String? status,
    DateTime? dueDate,
    String? createdBy,
    DateTime? createdDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assingneeUID: assingneeUID ?? this.assingneeUID,
      assingneeInitials: assingneeInitials ?? this.assingneeInitials,
      taskImportance: taskImportance ?? this.taskImportance,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
    );
  }

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
