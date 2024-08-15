import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

Map<String, List<Task>> parseListIntoMap(
  List<Task> taskList,
  List<Board> boards,
) {
  Map<String, List<Task>> map = {};

  for (Board board in boards) {
    map[board.title] = [];
  }

  for (Task task in taskList) {
    map[task.status]?.add(task);
  }

  return map;
}
