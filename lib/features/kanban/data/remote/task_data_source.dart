import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/features/kanban/core/constants/firebase/firebase_constants.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

/// [TaskDataSource] provides Firebase integration for CRUD operations
abstract class TaskDataSource {
  static final CollectionReference _taskReference =
      FireStoreConstants.taskCollectionReference;

  static Future<void> createTask(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _taskReference.add(task.toJson);
  }

  static Stream<List<Task>> get readTasks {
    return _taskReference.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Task.fromJson(doc);
        }).toList();
      },
    );
  }

  static Future<void> updateTask(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _taskReference.doc(task.id).set(
          task.toJson,
          SetOptions(merge: true),
        );
  }

  static Future<void> deleteTask(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _taskReference.doc(task.id).delete();
  }

  /// Updates every [Task] that has a [Task.status] as [status] to [newStatus].
  static Future<void> updateTasksStatusToNewStatus(
    String status,
    String newStatus,
  ) async {
    final allTasks = await _taskReference.get();
    final updatedTasks = allTasks.docs
        .map((e) {
          Task task = Task.fromJson(e);
          if (task.status == status) {
            task.status = newStatus;
            return task;
          }
        })
        .nonNulls
        .toList();

    await Future.wait([for (Task task in updatedTasks) updateTask(task)]);
  }

  static Future<void> deleteAllTasksWithStatus(String status) async {
    final allTasks = await _taskReference.get();
    final allTasksWithStatus = allTasks.docs
        .map((e) {
          Task task = Task.fromJson(e);
          return task.status == status ? task : null;
        })
        .nonNulls
        .toList();

    await Future.wait([for (Task task in allTasksWithStatus) deleteTask(task)]);
  }
}
