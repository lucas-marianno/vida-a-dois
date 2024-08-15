import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

Map<String, List<TaskEntity>> parseListIntoMap(
  List<TaskEntity> taskList,
  List<BoardEntity> boards,
) {
  Map<String, List<TaskEntity>> map = {};

  for (BoardEntity board in boards) {
    map[board.title] = [];
  }

  for (TaskEntity task in taskList) {
    map[task.status]?.add(task);
  }

  return map;
}
