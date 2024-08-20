import 'package:vida_a_dois/features/kanban/data/data_sources/task_data_source.dart';
import 'package:vida_a_dois/features/kanban/data/models/task_model.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository {
  TaskRepositoryImpl(this.taskDataSource);
  final TaskDataSource taskDataSource;

  @override
  Future<void> createTask(Task newTask) async {
    await taskDataSource.createTask(TaskModel.fromEntity(newTask));
  }

  @override
  Stream<List<Task>> readTasks() {
    return taskDataSource.readTasks();
  }

  @override
  Future<void> updateTask(Task task) async {
    await taskDataSource.updateTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(Task task) async {
    await taskDataSource.deleteTask(TaskModel.fromEntity(task));
  }

  @override
  Future<List<Task>> getTaskList() async {
    return (await taskDataSource.getTaskList())
        .map((model) => model.toEntity())
        .toList();
  }
}
