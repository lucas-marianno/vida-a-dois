import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/features/kanban/core/constants/firebase/firebase_constants.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

/// [TaskDataSource] provides CRUD functionality.
abstract class TaskDataSource {
  static final _firestore = FireStoreConstants.mockCollectionReference;

  static final CollectionReference _taskReference =
      _firestore.doc('columns').collection('tasks');

  static void createTask(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    _taskReference.add(task.toJson);
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

  static void updateTask(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _taskReference.doc(task.id).set(
          task.toJson,
          SetOptions(merge: true),
        );
  }

  static void deleteTask(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _taskReference.doc(task.id).delete();
  }
}
