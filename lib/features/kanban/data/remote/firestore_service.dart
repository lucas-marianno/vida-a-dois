import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/core/constants/enum/task_status.dart';
import 'package:kanban/core/constants/firebase/firebase_constants.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

abstract class FirestoreService {
  static final _firestoreMockCollection = FirebaseFirestore.instance
      .collection(FireStoreConstants.mockKanbanCollection);

  static Future<List<ColumnEntity>> getColumns() async {
    return (await _firestoreMockCollection.orderBy('position').get())
        .docs
        .map((doc) => ColumnEntity.fromJson(doc))
        .toList();
  }

  static Future<List<List<Task>>> getTasks(List<ColumnEntity> columns) async {
    // final a = columns.map((c) async => (await _firestoreMockCollection
    //         .doc(c.id!.name)
    //         .collection('tasks')
    //         .get())
    //     .docs
    //     .map((doc) => Task.fromJson(doc)));

    final List<List<Task>> kanban = [];

    for (ColumnEntity c in columns) {
      kanban.add((await _firestoreMockCollection
              .doc(c.id.name)
              .collection('tasks')
              .get())
          .docs
          .map((doc) => Task.fromJson(doc))
          .toList());
    }

    return kanban;
  }

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

  static void updateTask(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _statusColumnReference(task.status.name).doc(task.id).set(
          task.toJson,
          SetOptions(merge: true),
        );
  }

  static void addTaskToColumn(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _statusColumnReference(task.status.name).add(task.toJson);
  }

  static CollectionReference _statusColumnReference(String columnId) =>
      _firestoreMockCollection.doc(columnId).collection('tasks');
}
