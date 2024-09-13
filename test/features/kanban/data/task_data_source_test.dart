import 'dart:convert';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vida_a_dois/core/util/logger.dart';
import 'package:kanban/src/data/cloud_firestore/firestore_references.dart';
import 'package:kanban/src/data/data_sources/task_data_source.dart';
import 'package:kanban/src/data/models/task_model.dart';

void main() {
  initLogger(Log());

  final fakeFirestore = FakeFirebaseFirestore();
  final firestoreRef = FirestoreReferencesImpl(
    firestoreInstance: fakeFirestore,
    firebaseAuth: MockFirebaseAuth(),
  );
  final taskDS = TaskDataSourceImpl(firestoreReferences: firestoreRef);

  group('testing put methods', () {
    late TaskModel task1;
    setUpAll(() {
      task1 = TaskModel(title: 'task one title', status: 'todo');
    });

    setUp(() {
      fakeFirestore.clearPersistence();
    });

    test('should create a new task', () async {
      await taskDS.createTask(task1);

      final taskEntry = _parseDump(fakeFirestore.dump(), firestoreRef);

      final id = taskEntry.keys.first;

      expect(id.isNotEmpty, true);
      expect(taskEntry[id]['id'], task1.id);
      expect(taskEntry[id]['title'], task1.title);
      expect(taskEntry[id]['description'], task1.description);
      expect(taskEntry[id]['assigneeUID'], task1.assingneeUID);
      expect(taskEntry[id]['assingneeInitials'], task1.assingneeInitials);
      expect(taskEntry[id]['importance'], task1.importance.name);
      expect(taskEntry[id]['status'], task1.status);
      expect(taskEntry[id]['dueDate'], task1.deadline);
      expect(taskEntry[id]['createdBy'], task1.createdBy);
      expect(taskEntry[id]['createdDate'], task1.createdDate);
    });
    test('should update an existing task', () async {
      final taskId = await firestoreRef.taskCollectionRef.add(task1.toJson);

      task1 = task1.copyWith(id: taskId.id);
      final task1b = task1.copyWith(title: 'newtitle', description: 'describe');

      await taskDS.updateTask(task1b);

      final taskEntry = _parseDump(fakeFirestore.dump(), firestoreRef);

      final id = taskEntry.keys.first;

      expect(id.isNotEmpty, true);
      expect(taskEntry[id]['id'], task1b.id);
      expect(taskEntry[id]['title'], task1b.title);
      expect(taskEntry[id]['description'], task1b.description);
      expect(taskEntry[id]['assigneeUID'], task1b.assingneeUID);
      expect(taskEntry[id]['assingneeInitials'], task1b.assingneeInitials);
      expect(taskEntry[id]['importance'], task1b.importance.name);
      expect(taskEntry[id]['status'], task1b.status);
      expect(taskEntry[id]['dueDate'], task1b.deadline);
      expect(taskEntry[id]['createdBy'], task1b.createdBy);
      expect(taskEntry[id]['createdDate'], task1b.createdDate);
    });
  });

  group('testing fetch methods', () {
    late final TaskModel task1;
    late final TaskModel task2;
    late final TaskModel task3;
    late final List<TaskModel> taskList;

    setUpAll(() {
      fakeFirestore.clearPersistence();
      task1 = TaskModel(id: 'task1Id', title: 'task one title', status: 'todo');
      task2 = TaskModel(id: 'task2Id', title: 'task two title', status: 'todo');
      task3 = TaskModel(id: 'task3Id', title: 'third task', status: 'done');
      taskList = [task1, task2];
    });

    setUp(() async {
      await taskDS.updateTask(task1);
      await taskDS.updateTask(task2);
    });

    test('should return a `valid List<TaskModel>`', () async {
      final response = await taskDS.getTaskList();

      expect(response, isA<List<TaskModel>>());
      expect(response.length, equals(2));
      expect(response, equals(taskList));
    });

    test('should emit `List<TaskModel>` in order', () async {
      final responseStream = taskDS.readTasks();

      taskDS.updateTask(task3);

      expect(responseStream, isA<Stream<List<TaskModel>>>());
      expect(
          responseStream,
          emitsInOrder([
            taskList,
            [...taskList, task3]
          ]));
    });
  });
  group('testing remove methods', () {
    late TaskModel task1;
    setUpAll(() {
      task1 = TaskModel(title: 'task one title', status: 'todo');
    });

    setUp(() {
      fakeFirestore.clearPersistence();
    });

    test('should delete a task', () async {
      final taskId = await firestoreRef.taskCollectionRef.add(task1.toJson);

      task1 = task1.copyWith(id: taskId.id);

      final taskEntry = _parseDump(fakeFirestore.dump(), firestoreRef);
      final id = taskEntry.keys.first;

      expect(_parseDump(fakeFirestore.dump(), firestoreRef)[id], isNotEmpty);

      await taskDS.deleteTask(task1);

      expect(_parseDump(fakeFirestore.dump(), firestoreRef)[id], isEmpty);
    });
  });

  group('testing combined commands', () {
    test('getting and creating tasks', () async {
      await fakeFirestore.clearPersistence();

      final response1 = await taskDS.getTaskList();
      expect(response1, isEmpty);

      final mockTask = TaskModel(title: 'title', status: 'to do');
      await taskDS.createTask(mockTask);

      final response2 = await taskDS.getTaskList();
      expect(response2, isNotEmpty);
      expect(response2.length, 1);
      expect(response2.first.title, mockTask.title);
      expect(response2.first.status, mockTask.status);
    });
  });
}

Map<String, dynamic> _parseDump(String dump, FirestoreReferences firestoreRef) {
  return jsonDecode(dump)[firestoreRef.kanbanColPath]
          [firestoreRef.boardsDocPath][firestoreRef.taskColPath]
      as Map<String, dynamic>;
}
