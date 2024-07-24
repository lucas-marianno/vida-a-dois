import 'package:kanban/features/kanban/core/constants/enum/task_assignee.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/features/kanban/data/remote/task_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

// CRUD
class TaskRepository {
  static Future<void> createTask(Task newTask) async {
    await TaskDataSource.createTask(newTask);
  }

  static Stream<List<Task>> get readTasks => TaskDataSource.readTasks;

  static Future<void> updateTask(Task task) async {
    await TaskDataSource.updateTask(task);
  }

  static Future<void> updateTaskImportance(
    Task task,
    TaskImportance taskImportance,
  ) async {
    if (task.taskImportance == taskImportance) return;

    final newTask = task.copy()..taskImportance = taskImportance;

    await TaskDataSource.updateTask(newTask);
  }

  static Future<void> updateTaskAssignee(
      Task task, TaskAssignee assignee) async {
    if (task.assingnee == assignee) return;

    final newTask = task.copy()..assingnee = assignee;

    await TaskDataSource.updateTask(newTask);
  }

  static Future<void> updateTaskStatus(Task task, String newStatus) async {
    if (task.status == newStatus) return;

    await TaskDataSource.updateTask(task..status = newStatus);
  }

  static Future<void> deleteTask(Task task) async {
    await TaskDataSource.deleteTask(task);
  }
}
