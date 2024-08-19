import 'package:flutter_test/flutter_test.dart';
import 'package:kanban/features/kanban/domain/constants/enum/task_importance.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/util/compare_task.dart';

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
  final task1clone = Task(
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

  test('should return [true] if tasks have the same content', () {
    // act
    final result = compareTasks(task1, task1clone);

    // assert
    expect(result, true);
  });

  test('should return [false] if tasks have nearly identical content', () {
    // arrange
    final nearClone = task1clone..title = task1clone.title += 'a';
    // act
    final result = compareTasks(task1, nearClone);

    // assert
    expect(result, false);
  });

  test('should return [false] if tasks have different content', () {
    // act
    final result = compareTasks(task1, task2);

    // assert
    expect(result, false);
  });
}
