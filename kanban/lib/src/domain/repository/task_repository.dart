import 'package:kanban/src/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> createTask(Task newTask);

  Stream<List<Task>> readTasks();

  Future<List<Task>> getTasks();

  Future<void> updateTask(Task task);

  Future<void> deleteTask(Task task);
}
