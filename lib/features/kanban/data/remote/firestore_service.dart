import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/core/constants/firebase/firebase_constants.dart';
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

  // static Map<TaskStatus, Stream<List<Task>>> getTaskStreams() {
  //   Map<TaskStatus, Stream<List<Task>>> taskStreams = {};

  //   for (TaskStatus s in TaskStatus.values) {
  //     taskStreams.addAll({s, getTasksStream()}
  //         as Map<TaskStatus, Stream<List<Task>>>);
  //   }

  //   return taskStreams;
  // }

  /// Stream<Map<String, List<Task>>>
  static Stream<Map<String, List<Task>>> getTasksStream(
    List<ColumnEntity> columnsList,
  ) {
    Map<String, List<Task>> mappedTasks = {};

    for (ColumnEntity column in columnsList) {
      mappedTasks[column.title] = [];
    }

    Stream<List<Task>> stream = _firestoreMockCollection
        .doc('columns')
        .collection('tasks')
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Task.fromJson(doc);
        }).toList();
      },
    );

    return stream.map(
      (taskList) {
        for (Task task in taskList) {
          mappedTasks[task.status]!.add(task);
        }
        return mappedTasks;
      },
    );
  }

  // static Future<List<List<Task>>> getTasks(List<ColumnEntity> columns) async {
  //   // final a = columns.map((c) async => (await _firestoreMockCollection
  //   //         .doc(c.id!.name)
  //   //         .collection('tasks')
  //   //         .get())
  //   //     .docs
  //   //     .map((doc) => Task.fromJson(doc)));

  //   final List<List<Task>> kanban = [];

  //   for (ColumnEntity c in columns) {
  //     kanban.add((await _firestoreMockCollection
  //             .doc(c.title.name)
  //             .collection('tasks')
  //             .get())
  //         .docs
  //         .map((doc) => Task.fromJson(doc))
  //         .toList());
  //   }

  //   return kanban;
  // }

  static Stream<List<ColumnEntity>> getColumnsStream() {
    final stream =
        _firestoreMockCollection.doc('columns').snapshots().map((snapshot) {
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

    await _statusColumnReference(task.status).doc(task.id).delete();
  }

  static void updateTask(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _statusColumnReference(task.status).doc(task.id).set(
          task.toJson,
          SetOptions(merge: true),
        );
  }

  static void addTaskToColumn(Task? task) async {
    if (task == null || task.title.isEmpty) return;

    await _statusColumnReference(task.status).add(task.toJson);
  }

  static CollectionReference _statusColumnReference(String columnId) =>
      _firestoreMockCollection.doc(columnId).collection('tasks');
}
