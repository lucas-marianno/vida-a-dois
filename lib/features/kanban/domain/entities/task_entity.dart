import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/enum/task_assignee.dart';
import '../../core/constants/enum/task_importance.dart';

class Task {
  // TODO: add createdBy attribute after firebase auth is implemented
  String? id;
  String title;
  String? description;
  TaskAssignee assingnee;
  TaskImportance taskImportance;
  String status;
  Timestamp? dueDate;
  Timestamp? createdDate;

  Task({
    this.id,
    required this.title,
    this.description,
    this.assingnee = TaskAssignee.anyone,
    this.taskImportance = TaskImportance.normal,
    required this.status,
    this.dueDate,
    this.createdDate,
  });

  factory Task.fromJson(QueryDocumentSnapshot<Object?> json) {
    final taskId = json.reference.id;

    return Task.fromMap(json.data() as Map<String, dynamic>)..id = taskId;
  }

  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      assingnee: TaskAssignee.fromString(json['assingnedTo']),
      taskImportance: TaskImportance.fromString(json['taskImportance']),
      status: json['status'],
      dueDate: json['dueDate'],
      createdDate: json['createdDate'],
    );
  }

  Map<String, dynamic> get toJson {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assingnedTo': assingnee.name,
      'taskImportance': taskImportance.name,
      'status': status,
      'dueDate': dueDate,
      'createdDate': createdDate,
    };
  }

  Task copy() => Task.fromMap(toJson);
}
