import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/features/kanban/core/constants/firebase/firebase_constants.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

/// TODO: refactor
///
/// In theory, this should be renamed KanbanRepository
///
/// This class should provide abstraction to the database, whether it is
/// firebase, mysql or even SharedPreferences
abstract class FirestoreService {
  static final _firestoreMockCollection = FirebaseFirestore.instance
      .collection(FireStoreConstants.mockKanbanCollection);

  static final DocumentReference _columnsReference =
      _firestoreMockCollection.doc('columns');

  static final CollectionReference _taskReference =
      _columnsReference.collection('tasks');

  static Stream<List<Task>> getTasksStream() {
    return _taskReference.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Task.fromJson(doc);
        }).toList();
      },
    );
  }

  static Map<String, List<Task>> organizeList(
    List<Task> taskList,
    List<ColumnEntity> columnsList,
  ) {
    Map<String, List<Task>> organized = {};

    for (ColumnEntity column in columnsList) {
      organized[column.title] = [];
    }

    for (Task task in taskList) {
      organized[task.status]!.add(task);
    }

    return organized;
  }

  static Stream<List<ColumnEntity>> getColumnsStream() {
    final stream = _columnsReference.snapshots().map((snapshot) {
      final List<ColumnEntity> a = [];
      for (int i = 0; i < snapshot['status'].length; i++) {
        a.add(ColumnEntity(title: snapshot['status'][i], index: i));
      }
      return a;
    });
    return stream;
  }

  static void deleteTask(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _taskReference.doc(task.id).delete();
  }

  static void updateTask(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _taskReference.doc(task.id).set(
          task.toJson,
          SetOptions(merge: true),
        );
  }

  static void addTaskToColumn(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    _taskReference.add(task.toJson);
  }
}
