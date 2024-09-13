import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/core/logger/logger.dart';
import 'package:kanban/src/data/cloud_firestore/firestore_references.dart';
import 'package:kanban/src/data/models/task_model.dart';

abstract class TaskDataSource {
  final FirestoreReferences firestoreReferences;
  TaskDataSource({required this.firestoreReferences});

  Future<List<TaskModel>> getTaskList();
  Stream<List<TaskModel>> readTasks();

  /// Cretes a new task in the data source.
  ///
  /// The field `id` is not taken into consideration, since it will be
  /// creating a new entry with a new random generated id.
  ///
  /// If you want to set an specific `id`, use [updateTask] instead.
  Future<void> createTask(TaskModel task);

  /// Updates a task in the data source.
  ///
  /// It will find a entry with the provided `id` and merge it's data.
  /// If the entry doesn't exist, a new entry will be created.
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(TaskModel task);
}

class TaskDataSourceImpl extends TaskDataSource {
  final CollectionReference taskCollectionReference;
  TaskDataSourceImpl({required super.firestoreReferences})
      : taskCollectionReference = firestoreReferences.taskCollectionRef;

  @override
  Future<List<TaskModel>> getTaskList() async {
    final tasks = await taskCollectionReference.get();

    final parsedResponse =
        tasks.docs.map((e) => TaskModel.fromJson(e)).toList();

    logger.trace('$TaskDataSourceImpl: $getTaskList\n$parsedResponse');
    return parsedResponse;
  }

  @override
  Future<void> createTask(TaskModel task) async {
    logger.trace('$TaskDataSourceImpl: $createTask\n$task');
    if (task.title.isEmpty) return;

    await taskCollectionReference.add(TaskModel.fromEntity(task).toJson);
  }

  @override
  Stream<List<TaskModel>> readTasks() {
    logger.trace('$TaskDataSourceImpl: $readTasks');
    return taskCollectionReference.snapshots().map(_querySnapshotToModel);
  }

  List<TaskModel> _querySnapshotToModel(QuerySnapshot snapshot) =>
      snapshot.docs.map((doc) => TaskModel.fromJson(doc)).toList();

  @override
  Future<void> updateTask(TaskModel task) async {
    logger.trace('$TaskDataSourceImpl: $updateTask\n$task');
    if (task.title.isEmpty) return;

    await taskCollectionReference.doc(task.id).set(
          task.toJson,
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> deleteTask(TaskModel task) async {
    logger.trace('$TaskDataSourceImpl: $deleteTask\n$task');
    assert(task.id != null);
    assert(task.id!.isNotEmpty);

    await taskCollectionReference.doc(task.id).delete();
  }
}
