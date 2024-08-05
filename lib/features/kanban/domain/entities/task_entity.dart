import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/enum/task_importance.dart';

class Task {
  String? id;
  String title;
  String? description;
  String? assingneeUID;
  TaskImportance taskImportance;
  String status;
  Timestamp? dueDate;
  String? createdBy;
  Timestamp? createdDate;

  Task({
    this.id,
    required this.title,
    this.description,
    this.assingneeUID,
    this.taskImportance = TaskImportance.normal,
    required this.status,
    this.dueDate,
    this.createdBy,
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
      // assingneeUID: json['assingnedTo'],
      assingneeUID: json['assingneeUID'],
      taskImportance: TaskImportance.fromString(json['taskImportance']),
      status: json['status'],
      dueDate: json['dueDate'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
    );
  }

  Map<String, dynamic> get toJson {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assingneeUID': assingneeUID,
      'taskImportance': taskImportance.name,
      'status': status,
      'dueDate': dueDate,
      'createdBy': createdBy,
      'createdDate': createdDate,
    };
  }

  /// [equalsTo] makes a deep comparison between two [Task] objects
  /// and returns `true` if all parameters match.
  bool equalsTo(Task task) => '$toJson' == '${task.toJson}';

  Task copy() => Task.fromMap(toJson);
}
