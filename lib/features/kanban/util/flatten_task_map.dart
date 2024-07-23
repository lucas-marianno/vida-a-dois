import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

String flattenTaskMap(Map<String, List<Task>> map) {
  StringBuffer answer = StringBuffer();
  for (List list in map.values) {
    for (Task e in list) {
      answer.write(e.toJson);
    }
  }
  return answer.toString();
}
