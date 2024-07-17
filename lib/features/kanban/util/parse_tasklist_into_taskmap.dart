import 'package:kanban/features/kanban/domain/entities/column_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

Map<String, List<Task>> parseListIntoMap(
  List<Task> taskList,
  List<ColumnEntity> columnsList,
) {
  Map<String, List<Task>> map = {};

  for (ColumnEntity column in columnsList) {
    map[column.title] = [];
  }

  for (Task task in taskList) {
    map[task.status]?.add(task);
  }

  return map;
}
