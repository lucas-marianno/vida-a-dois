// CRUD
import 'package:kanban/features/auth/data/auth_data.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/features/kanban/data/data_sources/task_data_source.dart';
import 'package:kanban/features/kanban/data/models/task_model.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository {
  TaskRepositoryImpl({required this.taskDataSource});
  final TaskDataSource taskDataSource;

  @override
  Future<void> createTask(Task newTask) async {
    final currentUserUID = AuthData.currentUser!.uid;
    await taskDataSource
        .createTask(TaskModel.fromEntity(newTask)..createdBy = currentUserUID);
  }

  @override
  Stream<List<Task>> get readTasks => taskDataSource.readTasks;

  @override
  Future<void> updateTask(Task task) async {
    await taskDataSource.updateTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> updateTaskImportance(
    Task task,
    TaskImportance taskImportance,
  ) async {
    if (task.taskImportance == taskImportance) return;

    final newTask = TaskModel.fromEntity(task).copy()
      ..taskImportance = taskImportance;

    await taskDataSource.updateTask(newTask);
  }

  @override
  Future<void> updateTaskAssignee(Task task, String assigneeUID) async {
    if (task.assingneeUID == assigneeUID) return;

    final newTask = TaskModel.fromEntity(task).copy()
      ..assingneeUID = assigneeUID;

    await taskDataSource.updateTask(newTask);
  }

  @override
  Future<void> updateTaskStatus(Task task, String newStatus) async {
    if (task.status == newStatus) return;

    await taskDataSource
        .updateTask(TaskModel.fromEntity(task)..status = newStatus);
  }

  @override
  Future<void> deleteTask(Task task) async {
    await taskDataSource.deleteTask(TaskModel.fromEntity(task));
  }
}
