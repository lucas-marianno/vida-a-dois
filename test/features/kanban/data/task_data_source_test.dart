import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vida_a_dois/features/kanban/data/cloud_firestore/firestore_references.dart';
import 'package:vida_a_dois/features/kanban/data/data_sources/task_data_source.dart';
import 'package:vida_a_dois/features/kanban/data/models/task_model.dart';

/// abstract class TaskDataSource {
///   final FirestoreReferences firestoreReferences;
///   TaskDataSource({required this.firestoreReferences});
///
///   Future<List<TaskModel>> getTaskList();
///   Stream<List<TaskModel>> readTasks();
///   Future<void> createTask(TaskModel task);
///   Future<void> updateTask(TaskModel task);
///   Future<void> deleteTask(TaskModel task);
/// }
void main() {
  final fakeFirestore = FakeFirebaseFirestore();
  late final FirestoreReferences firestoreRef;
  late final TaskDataSource taskDS;

  setUpAll(() {
    final fakeAuth = MockFirebaseAuth();

    firestoreRef = FirestoreReferencesImpl(
      firestoreInstance: fakeFirestore,
      firebaseAuth: fakeAuth,
    );
    taskDS = TaskDataSourceImpl(firestoreReferences: firestoreRef);
  });

  setUp(() {
    fakeFirestore.clearPersistence();
  });

  test('should get an empty task list', () async {
    final response = await taskDS.getTaskList();

    expect(response, isA<List<TaskModel>>());
    expect(response.isEmpty, true);
  });

  test('should stream an empty task list', () async {
    final taskStream = taskDS.readTasks();

    expect(taskStream, isA<Stream<List<TaskModel>>>());

    taskStream.listen((data) {
      expect(data.isEmpty, true);
    });
  });

  test('should create a new task', () async {
    final newTask = TaskModel(title: 'task title', status: 'todo');

    await taskDS.createTask(newTask);

    final response = await taskDS.getTaskList();

    expect(response.length == 1, true);
    expect(response.first == newTask, true);
  });
}
