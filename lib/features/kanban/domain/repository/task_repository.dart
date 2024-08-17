import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> createTask(Task newTask);

  Stream<List<Task>> readTasks();

  Future<void> updateTask(Task task);

  /// Updates every [Task] that has a [Task.status] as [status] to [newStatus].
  Future<void> updateTasksStatusToNewStatus(String status, String newStatus);

  Future<void> deleteTask(Task task);
}
