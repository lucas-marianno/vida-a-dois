import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/util/flatten_task_map.dart';

bool compareTaskMaps(
    Map<String, List<Task>> taskMap1, Map<String, List<Task>> taskMap2) {
  if (!_hasSameKeys(taskMap1, taskMap2)) return false;
  return _hasSameValues(taskMap1, taskMap2);
}

bool _hasSameKeys(Map map1, Map map2) {
  final map1Keys = map1.keys.toList().toString();
  final map2Keys = map2.keys.toList().toString();

  return map1Keys == map2Keys;
}

bool _hasSameValues(
    Map<String, List<Task>> map1, Map<String, List<Task>> map2) {
  return flattenTaskMap(map1) == flattenTaskMap(map2);
}
