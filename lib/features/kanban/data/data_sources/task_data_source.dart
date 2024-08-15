import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/features/kanban/data/models/task_model.dart';

/// [TaskDataSource] provides Firebase integration for CRUD operations
class TaskDataSource {
  TaskDataSource({required this.taskCollectionReference});
  final CollectionReference taskCollectionReference;

  Future<void> createTask(TaskModel? task) async {
    if (task == null || task.title.isEmpty) return;

    await taskCollectionReference.add(TaskModel.fromEntity(task).toJson);
  }

  Stream<List<TaskModel>> get readTasks {
    return taskCollectionReference.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return TaskModel.fromJson(doc);
        }).toList();
      },
    );
  }

  Future<void> updateTask(TaskModel task) async {
    if (task.title.isEmpty) return;

    await taskCollectionReference.doc(task.id).set(
          TaskModel.fromEntity(task).toJson,
          SetOptions(merge: true),
        );
  }

  Future<void> deleteTask(TaskModel? task) async {
    if (task == null || task.title.isEmpty) return;

    await taskCollectionReference.doc(task.id).delete();
  }

  /// Updates every [TaskModel] that has a [TaskModel.status] as [status] to [newStatus].
  Future<void> updateTasksStatusToNewStatus(
    String status,
    String newStatus,
  ) async {
    final allTasks = await taskCollectionReference.get();
    final updatedTasks = allTasks.docs
        .map((e) {
          TaskModel task = TaskModel.fromJson(e);
          if (task.status == status) {
            task.status = newStatus;
            return task;
          }
        })
        .nonNulls
        .toList();

    await Future.wait([for (TaskModel task in updatedTasks) updateTask(task)]);
  }

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
