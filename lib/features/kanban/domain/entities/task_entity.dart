import '../constants/enum/task_importance.dart';

class Task {
  final String? id;
  final String title;
  final String? description;
  final String? assingneeUID;
  final String? assingneeInitials;
  final TaskImportance importance;
  final String status;
  final DateTime? deadline;
  final String? createdBy;
  final DateTime? createdDate;

  const Task({
    this.id,
    required this.title,
    this.description,
    this.assingneeUID,
    this.assingneeInitials,
    this.importance = TaskImportance.normal,
    required this.status,
    this.deadline,
    this.createdBy,
    this.createdDate,
  });

  Task copyWith({
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
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assingneeUID: assingneeUID ?? this.assingneeUID,
      assingneeInitials: assingneeInitials ?? this.assingneeInitials,
      importance: importance ?? this.importance,
      status: status ?? this.status,
      deadline: dueDate ?? this.deadline,
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
        'importance': importance,
        'status': status,
        'dueDate': deadline,
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
