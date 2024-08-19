import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/features/kanban/data/models/task_model.dart';

abstract class TaskDataSource {
  TaskDataSource({required this.taskCollectionReference});
  final CollectionReference taskCollectionReference;

  Future<List<TaskModel>> getTaskList();
  Stream<List<TaskModel>> readTasks();
  Future<void> createTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(TaskModel task);
}

class TaskDataSourceImpl extends TaskDataSource {
  TaskDataSourceImpl({required super.taskCollectionReference});

  @override
  Future<List<TaskModel>> getTaskList() async {
    final tasks = await taskCollectionReference.get();

    return tasks.docs.map((e) => TaskModel.fromJson(e)).toList();
  }

  @override
  Future<void> createTask(TaskModel task) async {
    if (task.title.isEmpty) return;

    await taskCollectionReference.add(TaskModel.fromEntity(task).toJson);
  }

  @override
  Stream<List<TaskModel>> readTasks() =>
      taskCollectionReference.snapshots().map(_querySnapshotToModel);

  List<TaskModel> _querySnapshotToModel(QuerySnapshot snapshot) =>
      snapshot.docs.map((doc) => TaskModel.fromJson(doc)).toList();

  @override
  Future<void> updateTask(TaskModel task) async {
    if (task.title.isEmpty) return;

    await taskCollectionReference.doc(task.id).set(
          task.toJson,
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> deleteTask(TaskModel task) async {
    assert(task.id != null);
    assert(task.id!.isNotEmpty);

    await taskCollectionReference.doc(task.id).delete();
  }
}
