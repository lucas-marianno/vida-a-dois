import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> createTask(TaskEntity newTask);

  Stream<List<TaskEntity>> get readTasks;

  Future<void> updateTask(TaskEntity task);

  Future<void> updateTaskImportance(
      TaskEntity task, TaskImportance taskImportance);

  Future<void> updateTaskAssignee(TaskEntity task, String assigneeUID);

  Future<void> updateTaskStatus(TaskEntity task, String newStatus);

  Future<void> deleteTask(TaskEntity task);
}
