import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> createTask(Task newTask);

  Stream<List<Task>> readTasks();

  Future<List<Task>> getTaskList();

  Future<void> updateTask(Task task);

  Future<void> deleteTask(Task task);
}
