import 'package:flutter_test/flutter_test.dart';
import 'package:vida_a_dois/features/kanban/domain/constants/enum/task_importance.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';
import 'package:vida_a_dois/features/kanban/util/compare_task_maps.dart';

void main() {
  final dueDate = DateTime.parse('2024-08-15 09:59:55.288283');
  final createdDate = DateTime.parse('2023-09-16 10:01:16.906093');

  final task1 = Task(
    id: 'abcde123456',
    title: 'do something',
    description: 'how to to something',
    assingneeUID: '987654321abc',
    assingneeInitials: 'LM',
    taskImportance: TaskImportance.normal,
    status: 'todo',
    dueDate: dueDate,
    createdBy: '123456abc',
    createdDate: createdDate,
  );
  final task1NearClone = Task(
    id: 'abcde123456a',
    title: 'do something',
    description: 'how to to something',
    assingneeUID: '987654321abc',
    assingneeInitials: 'LM',
    taskImportance: TaskImportance.normal,
    status: 'todo',
    dueDate: dueDate,
    createdBy: '123456abc',
    createdDate: createdDate,
  );

  final task2 = Task(
    id: 'abc',
    title: 'do something else',
    description: 'how to not to do something',
    assingneeUID: '987654321abc',
    assingneeInitials: 'JJ',
    taskImportance: TaskImportance.normal,
    status: 'done',
    dueDate: DateTime.now(),
    createdBy: '123456abc',
    createdDate: DateTime.now(),
  );

  final task3 = Task(
    id: 'abcdffe123456',
    title: 'do not do something',
    description: 'how to to something',
    assingneeUID: '987654321abc',
    assingneeInitials: 'LM',
    taskImportance: TaskImportance.normal,
    status: 'todo',
    dueDate: dueDate,
    createdBy: '123456abc',
    createdDate: createdDate,
  );

  final map1 = {
    'To do': [task1, task1],
    'In Progess': [task2],
    'Done': [task3, task3, task3],
  };
  final map1NearClone = {
    'To do': [task1, task1NearClone],
    'In Progess': [task2],
    'Done': [task3, task3, task3],
  };
  final map1DiffKeys = {
    'not to do': [task1, task1],
    'In Progess': [task2],
    'Done': [task3, task3, task3],
  };
  final map1DiffVals = {
    'To do': [task2, task2],
    'In Progess': [task1],
    'Done': [task3, task3, task3],
  };
  final map1clone = {
    'To do': [task1, task1],
    'In Progess': [task2],
    'Done': [task3, task3, task3],
  };

  test('should return [false] if maps have different [keys]', () {
    // act
    final result = compareTaskMaps(map1, map1DiffKeys);

    // assert
    expect(result, false);
  });
  test('should return [false] if maps have different [values]', () {
    // act
    final result = compareTaskMaps(map1, map1DiffVals);

    // assert
    expect(result, false);
  });
  test('should return [false] even if maps have abismal difference', () {
    // act
    final result = compareTaskMaps(map1, map1NearClone);

    // assert
    expect(result, false);
  });
  test('should return [true] if maps have identical keys and values', () {
    // act
    final result = compareTaskMaps(map1, map1clone);

    // assert
    expect(result, true);
  });
}
