import 'package:flutter_test/flutter_test.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';
import 'package:vida_a_dois/features/kanban/util/flatten_task_map.dart';

void main() {
  const task = Task(
    id: '123',
    title: 'do something',
    status: 'to do',
  );

  final map1 = {
    'To do': [task, task],
    'In Progess': [task],
    'Done': [task, task, task],
  };
  test('should return a flattened empty map', () {
    // arrange
    final map = {'to do': <Task>[]};
    const flattened = '';

    // act
    final result = flattenTaskMap(map);

    // assert
    expect(result, flattened);
  });

  test('should return a flattened task map', () {
    // arrange
    const flattened =
        "{id: 123, title: do something, description: null, assingneeUID: null, assingneeInitials: null, taskImportance: normal, status: to do, dueDate: null, createdBy: null, createdDate: null}{id: 123, title: do something, description: null, assingneeUID: null, assingneeInitials: null, taskImportance: normal, status: to do, dueDate: null, createdBy: null, createdDate: null}{id: 123, title: do something, description: null, assingneeUID: null, assingneeInitials: null, taskImportance: normal, status: to do, dueDate: null, createdBy: null, createdDate: null}{id: 123, title: do something, description: null, assingneeUID: null, assingneeInitials: null, taskImportance: normal, status: to do, dueDate: null, createdBy: null, createdDate: null}{id: 123, title: do something, description: null, assingneeUID: null, assingneeInitials: null, taskImportance: normal, status: to do, dueDate: null, createdBy: null, createdDate: null}{id: 123, title: do something, description: null, assingneeUID: null, assingneeInitials: null, taskImportance: normal, status: to do, dueDate: null, createdBy: null, createdDate: null}";

    // act
    final result = flattenTaskMap(map1);

    // expect
    expect(result, flattened);
  });
}
