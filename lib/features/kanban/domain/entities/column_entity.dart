// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:kanban/core/constants/enum/task_status.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

class ColumnEntity {
  String title;
  int index;
  List<Task>? taskList;

  ColumnEntity({
    required this.title,
    required this.index,
    this.taskList,
  });

  final String collection = 'tasks';

  // factory ColumnEntity.fromJson(QueryDocumentSnapshot<Object?> json) {
  //   return ColumnEntity(
  //     title: TaskStatus.fromString(json.reference.id),
  //     index: json['position'],
  //   );
  // }

  Map<String, dynamic> get toJson {
    return {
      'id': title,
      'position': index,
      'taskList': taskList,
    };
  }
}
