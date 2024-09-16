import 'package:flutter_test/flutter_test.dart';
import 'package:kanban/core/logger/logger.dart';
import 'package:kanban/src/domain/entities/task_entity.dart';
import 'package:kanban/src/domain/repository/task_repository.dart';
import 'package:kanban/src/injection_container.dart';

import '../../../../helper/fake_board_repository.dart';
import '../../../../helper/fake_task_repository.dart';

void main() {
  initLogger(Log());

  setUpLocator(FakeBoardRepository(), FakeTaskRepository());
  final taskRepo = locator<TaskRepository>() as FakeTaskRepository;

  setUp(() => taskRepo.clearPersistence());

  test('should get an empty list', () async {
    final response = await taskRepo.getTasks();

    expect(response, isA<List<Task>>());
    expect(response, isEmpty);
  });

  test('should create a new task with a proper ID', () async {
    // arrange
    const newTask = Task(title: 'task1', status: 'to do');

    // act
    await taskRepo.createTask(newTask);

    // assert task
    final response = await taskRepo.getTasks();
    expect(response, isA<List<Task>>());
    expect(response.first.title, newTask.title);
    expect(response.first.status, newTask.status);

    // assert id
    expect(response.first.id, isNotNull);
    expect(response.first.id, isNotEmpty);
    expect(response.first.id, contains(RegExp(r'\d+')));
    expect(response.first.id, contains(RegExp(r'\w+')));
    expect(response.first.id!.length, 20);
  });

  group('testing Read, Update and Delete ', () {
    late Task task1;

    setUp(() async {
      taskRepo.clearPersistence();

      task1 = const Task(title: 'task1', status: 'to do');

      await taskRepo.createTask(task1);
    });

    test('should create a task with a provided ID', () async {
      const taskId = 'abc123';
      const task1 = Task(id: taskId, title: 'title', status: 'to do');
      final initialLength = (await taskRepo.getTasks()).length;
      await taskRepo.updateTask(task1);

      final response = await taskRepo.getTasks();

      expect(response, contains(task1));
      expect(response.length, initialLength + 1);
    });

    test('should update a task', () async {
      final response = await taskRepo.getTasks();
      expect(response, hasLength(1));
      final initialTask = response.first;

      final modifiedTask = initialTask.copyWith(title: 'new different title');
      await taskRepo.updateTask(modifiedTask);

      final response2 = await taskRepo.getTasks();
      expect(response2, hasLength(1));
      expect(response2.first.title, modifiedTask.title);
    });

    test('should delete a task', () async {
      final initial = await taskRepo.getTasks();
      expect(initial, hasLength(1));

      await taskRepo.deleteTask(initial.first);

      expect(await taskRepo.getTasks(), isEmpty);
    });

    test('should emit the current list when a listener is added', () async {
      final initialTaskList = await taskRepo.getTasks();

      expect(taskRepo.readTasks(), emitsInOrder([initialTaskList]));
    });

    test('should emit new lists when they are updated', () async {
      final initialTaskList = await taskRepo.getTasks();
      const task2 = Task(id: 'task2id', title: 'task2', status: 'to do');
      const task3 = Task(id: 'task3id', title: 'task3', status: 'done');
      final expectedEmition = [
        initialTaskList,
        initialTaskList + [task2],
        initialTaskList + [task2] + [task3]
      ];

      expect(taskRepo.readTasks(), emitsInOrder(expectedEmition));

      await taskRepo.updateTask(task2);
      await taskRepo.updateTask(task3);
    });

    test('should emit an empty list', () async {
      final initialTaskList = await taskRepo.getTasks();
      final expectedEmition = [
        initialTaskList,
        [],
      ];

      expect(taskRepo.readTasks(), emitsInOrder(expectedEmition));

      await taskRepo.deleteTask(initialTaskList.first);
    });
  });
}
