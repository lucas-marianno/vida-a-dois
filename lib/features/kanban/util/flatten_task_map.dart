import 'dart:convert';

import 'package:vida_a_dois/features/kanban/data/models/task_model.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';

String flattenTaskMap(Map<String, List<Task>> map) {
  StringBuffer answer = StringBuffer();
  for (List list in map.values) {
    for (Task e in list) {
      answer.write(TaskModel.fromEntity(e).toJson);
    }
  }
  return answer.toString();
}

String flattenTaskMapToJsonString(Map<String, List<Task>> map) {
  Map<String, dynamic> json = {};
  for (String key in map.keys) {
    json[key] = [];
    for (Task e in map[key]!) {
      json[key].add(TaskModel.fromEntity(e).toJson);
    }
  }

  return jsonEncode(json);
}

Map<String, List<Task>> unflattenTaskMapFromJsonString(String jsonString) {
  final json = jsonDecode(jsonString) as Map<String, dynamic>;

  Map<String, List<Task>> decoded = {};
  for (String key in json.keys) {
    decoded[key] = <Task>[];
    for (var element in json[key]) {
      decoded[key]!.add(TaskModel.fromMap(element).toEntity());
    }
  }
  return decoded;
}
