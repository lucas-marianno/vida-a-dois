import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> createTask(Task newTask);

  Stream<List<Task>> get readTasks;

  Future<void> updateTask(Task task);

  Future<void> updateTaskImportance(Task task, TaskImportance taskImportance);

  Future<void> updateTaskAssignee(Task task, String assigneeUID);

  Future<void> updateTaskStatus(Task task, String newStatus);

  Future<void> deleteTask(Task task);
}
