import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/core/constants/firebase/firebase_constants.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

abstract class FirestoreService {
  static final _firestoreMockCollection = FirebaseFirestore.instance
      .collection(FireStoreConstants.mockKanbanCollection);

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMockKanbanColumns() {
    return _firestoreMockCollection.orderBy('position').snapshots();
  }

  static Stream<List<Task>> getMockColumnContent(String columnId) {
    return _columnReference(columnId).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Task.fromJson(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  static void editTask(Task? task) async {
    // TODO: later on, add verification for 'task.id == null'
    if (task == null || task.title.isEmpty) return;

    final String columnId = task.status.name;

    await _columnReference(columnId).doc(task.id).set(
          task.toJson(),
          SetOptions(merge: true),
        );
  }

  static void addTaskToColumn(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    final String columnId = task.status.name;

    //TODO: retrieve id from uploaded task and store it in task.id
    await _columnReference(columnId).add(task.toJson());
  }

  static CollectionReference _columnReference(String columnId) =>
      _firestoreMockCollection.doc(columnId).collection('tasks');
}
