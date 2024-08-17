import 'package:kanban/features/kanban/data/models/task_model.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

/// [compateTasks] returns `true` if both tasks have the exact same content
bool compareTasks(Task task1, Task task2) {
  final taskA = TaskModel.fromEntity(task1).toJson.toString();
  final taskB = TaskModel.fromEntity(task2).toJson.toString();
  return taskA == taskB;
}
