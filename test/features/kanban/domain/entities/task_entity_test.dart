import 'package:flutter_test/flutter_test.dart';
import 'package:kanban/src/domain/constants/enum/task_importance.dart';
import 'package:kanban/src/domain/entities/task_entity.dart';

void main() {
  final dueDate = DateTime.parse('2024-08-15 09:59:55.288283');
  final createdDate = DateTime.parse('2023-09-16 10:01:16.906093');

  group('equality operator', () {
    final task1 = Task(
      id: 'abcde123456',
      title: 'do something',
      description: 'how to to something',
      assingneeUID: '987654321abc',
      assingneeInitials: 'LM',
      importance: TaskImportance.normal,
      status: 'todo',
      deadline: dueDate,
      createdBy: '123456abc',
      createdDate: createdDate,
    );
    final task1clone = Task(
      id: 'abcde123456',
      title: 'do something',
      description: 'how to to something',
      assingneeUID: '987654321abc',
      assingneeInitials: 'LM',
      importance: TaskImportance.normal,
      status: 'todo',
      deadline: dueDate,
      createdBy: '123456abc',
      createdDate: createdDate,
    );
    final task2 = Task(
      id: 'abc',
      title: 'do something else',
      description: 'how to not to do something',
      assingneeUID: '987654321abc',
      assingneeInitials: 'JJ',
      importance: TaskImportance.normal,
      status: 'done',
      deadline: DateTime.now(),
      createdBy: '123456abc',
      createdDate: DateTime.now(),
    );

    test('should return [true] if tasks have the same content', () {
      // act
      final result = task1 == task1clone;

      // assert
      expect(result, true);
    });

    test('should return [false] if tasks have nearly identical content', () {
      // arrange
      final nearClone = task1clone.copyWith(title: '${task1.title}a');
      // act
      final result = task1 == nearClone;

      // assert
      expect(result, false);
    });

    test('should return [false] if tasks have different content', () {
      // act
      final result = task1 == task2;

      // assert
      expect(result, false);
    });
  });

  test('.toString should return a valid parsed string', () {
    // arrange
    final task = Task(
      id: 'abcde123456',
      title: 'do something',
      description: 'how to to something',
      assingneeUID: '987654321abc',
      assingneeInitials: 'LM',
      importance: TaskImportance.normal,
      status: 'todo',
      deadline: dueDate,
      createdBy: '123456abc',
      createdDate: createdDate,
    );

    final asString = {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'assingneeUID': task.assingneeUID,
      'assingneeInitials': task.assingneeInitials,
      'importance': task.importance,
      'status': task.status,
      'dueDate': task.deadline,
      'createdBy': task.createdBy,
      'createdDate': task.createdDate,
    }.toString();

    // act
    final result = task.toString();

    // assert
    expect(result, asString);
  });

  group('hashcode', () {
    final task1 = Task(
      id: 'abcde123456',
      title: 'do something',
      description: 'how to to something',
      assingneeUID: '987654321abc',
      assingneeInitials: 'LM',
      importance: TaskImportance.normal,
      status: 'todo',
      deadline: dueDate,
      createdBy: '123456abc',
      createdDate: createdDate,
    );
    final task1clone = Task(
      id: 'abcde123456',
      title: 'do something',
      description: 'how to to something',
      assingneeUID: '987654321abc',
      assingneeInitials: 'LM',
      importance: TaskImportance.normal,
      status: 'todo',
      deadline: dueDate,
      createdBy: '123456abc',
      createdDate: createdDate,
    );
    final task1nearclone = Task(
      id: 'abcde1234567',
      title: 'do something',
      description: 'how to to something',
      assingneeUID: '987654321abc',
      assingneeInitials: 'LM',
      importance: TaskImportance.normal,
      status: 'todo',
      deadline: dueDate,
      createdBy: '123456abc',
      createdDate: createdDate,
    );

    test('equal objects should have the same hashcode', () {
      final result = task1.hashCode == task1clone.hashCode;
      expect(result, true);
    });
    test('different objects should have different hashcodes', () {
      final result = task1.hashCode == task1nearclone.hashCode;
      expect(result, false);
    });
  });
}
