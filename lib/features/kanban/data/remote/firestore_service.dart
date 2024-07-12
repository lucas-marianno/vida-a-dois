import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/core/constants/enum/task_status.dart';
import 'package:kanban/core/constants/firebase/firebase_constants.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

abstract class FirestoreService {
  static final _firestoreMockCollection = FirebaseFirestore.instance
      .collection(FireStoreConstants.mockKanbanCollection);

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getMockKanbanStatusColumns() {
    return _firestoreMockCollection.orderBy('position').snapshots();
  }

  static Stream<List<Task>> getMockStatusColumnContent(TaskStatus columnId) {
    return _statusColumnReference(columnId.name).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Task.fromJson(doc),
              )
              .toList(),
        );
  }

  static void deleteTask(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _statusColumnReference(task.status.name).doc(task.id).delete();
  }

  static void editTask(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _statusColumnReference(task.status.name).doc(task.id).set(
          task.toJson(),
          SetOptions(merge: true),
        );
  }

  static void addTaskToColumn(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _statusColumnReference(task.status.name).add(task.toJson());
  }

  static CollectionReference _statusColumnReference(String columnId) =>
      _firestoreMockCollection.doc(columnId).collection('tasks');
}
