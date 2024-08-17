import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/features/kanban/data/models/task_model.dart';

abstract class TaskDataSource {
  TaskDataSource({required this.taskCollectionReference});
  final CollectionReference taskCollectionReference;

  Future<List<TaskModel>> getTaskList();
  Stream<List<TaskModel>> readTasks();
  Future<void> createTask(TaskModel? task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(TaskModel? task);
  Future<void> deleteAllTasksWithStatus(String status);
}

// TODO: remove all of this logic into UseCases (vide BoardDataSource and BoardRepository)
class TaskDataSourceImpl extends TaskDataSource {
  TaskDataSourceImpl({required super.taskCollectionReference});

  @override
  Future<List<TaskModel>> getTaskList() async {
    final tasks = await taskCollectionReference.get();

    return tasks.docs.map((e) => TaskModel.fromJson(e)).toList();
  }

  @override
  Future<void> createTask(TaskModel? task) async {
    if (task == null || task.title.isEmpty) return;

    await taskCollectionReference.add(TaskModel.fromEntity(task).toJson);
  }

  @override
  Stream<List<TaskModel>> readTasks() {
    return taskCollectionReference.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return TaskModel.fromJson(doc);
        }).toList();
      },
    );
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    if (task.title.isEmpty) return;

    await taskCollectionReference.doc(task.id).set(
          TaskModel.fromEntity(task).toJson,
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> deleteTask(TaskModel? task) async {
    if (task == null || task.title.isEmpty) return;

    await taskCollectionReference.doc(task.id).delete();
  }

  @override
  Future<void> deleteAllTasksWithStatus(String status) async {
    final allTasks = await taskCollectionReference.get();
    final allTasksWithStatus = allTasks.docs
        .map((e) {
          TaskModel task = TaskModel.fromJson(e);
          return task.status == status ? task : null;
        })
        .nonNulls
        .toList();

    await Future.wait(
        [for (TaskModel task in allTasksWithStatus) deleteTask(task)]);
  }
}
