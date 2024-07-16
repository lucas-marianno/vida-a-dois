import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/core/constants/enum/task_status.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

class ColumnEntity {
  TaskStatus id;
  int position;
  List<Task>? taskList;

  ColumnEntity({
    required this.id,
    required this.position,
    this.taskList,
  });

  final String collection = 'tasks';

  factory ColumnEntity.fromJson(QueryDocumentSnapshot<Object?> json) {
    return ColumnEntity(
      id: TaskStatus.fromString(json.reference.id),
      position: json['position'],
    );
  }

  Map<String, dynamic> get toJson {
    return {
      'id': id,
      'position': position,
      'taskList': taskList,
    };
  }
}
