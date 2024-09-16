import 'package:flutter_test/flutter_test.dart';

import 'package:kanban/core/logger/logger.dart';

import 'package:kanban/src/domain/entities/board_entity.dart';
import 'package:kanban/src/domain/entities/task_entity.dart';
import 'package:kanban/src/domain/usecases/task/get_task_stream.dart';

import 'package:mockito/mockito.dart' as mockito;
import '../../../../../helper/mock_generator.mocks.dart';

void main() {
  initLogger(Log());

  final mockTaskRepository = MockTaskRepository();
  final mockBoardRepository = MockBoardRepository();
  final getTasksUseCase =
      GetTasksUseCase(mockTaskRepository, mockBoardRepository);

  final List<Task> mockTasks = [
    const Task(id: '1', title: 'Task 1', status: 'To Do'),
    const Task(id: '2', title: 'Task 2', status: 'In Progress'),
    const Task(id: '3', title: 'Task 3', status: 'Done'),
  ];

  final List<Board> mockBoards = [
    const Board(title: 'To Do', index: 0),
    const Board(title: 'In Progress', index: 1),
    const Board(title: 'Done', index: 2),
  ];

  test('should emit a map of tasks organized by boards on initial load',
      () async {
    // Arrange
    mockito
        .when(mockTaskRepository.getTasks())
        .thenAnswer((_) async => mockTasks);

    mockito
        .when(mockBoardRepository.getBoards())
        .thenAnswer((_) async => mockBoards);
    mockito
        .when(mockTaskRepository.readTasks())
        .thenAnswer((_) => Stream.value(mockTasks));
    mockito
        .when(mockBoardRepository.readBoards())
        .thenAnswer((_) => Stream.value(mockBoards));

    final expectedMap = {
      'To Do': [mockTasks[0]],
      'In Progress': [mockTasks[1]],
      'Done': [mockTasks[2]],
    };

    // Act
    final result = getTasksUseCase();

    // Assert
    expect(await result.first, expectedMap);
  });

  test('should emit a new map when tasks stream changes', () async {
    // Arrange
    final updatedTasks = [
      const Task(id: '1', title: 'Task 1', status: 'To Do'),
      const Task(
          id: '2', title: 'Task 2', status: 'Done'), // Task 2 status changed
      const Task(id: '3', title: 'Task 3', status: 'Done'),
    ];

    mockito
        .when(mockTaskRepository.getTasks())
        .thenAnswer((_) async => mockTasks);
    mockito
        .when(mockBoardRepository.getBoards())
        .thenAnswer((_) async => mockBoards);

    mockito
        .when(mockTaskRepository.readTasks())
        .thenAnswer((_) => Stream.fromIterable([mockTasks, updatedTasks]));
    mockito
        .when(mockBoardRepository.readBoards())
        .thenAnswer((_) => Stream.value(mockBoards));

    final expectedInitialMap = {
      'To Do': [mockTasks[0]],
      'In Progress': [mockTasks[1]],
      'Done': [mockTasks[2]],
    };

    final expectedUpdatedMap = {
      'To Do': [updatedTasks[0]],
      'In Progress': [],
      'Done': [updatedTasks[1], updatedTasks[2]],
    };

    // Act
    final taskStream = getTasksUseCase();

    // Assert
    expect(taskStream, emitsInOrder([expectedInitialMap, expectedUpdatedMap]));
  });

  test('should emit a new map when boards stream changes', () async {
    // Arrange
    final updatedBoards = [
      const Board(title: 'To Do', index: 0),
      const Board(title: 'In Progress', index: 1),
      const Board(title: 'Review', index: 2), // Board changed to 'Review'
    ];

    mockito
        .when(mockTaskRepository.getTasks())
        .thenAnswer((_) async => mockTasks);
    mockito
        .when(mockBoardRepository.getBoards())
        .thenAnswer((_) async => mockBoards);

    mockito
        .when(mockTaskRepository.readTasks())
        .thenAnswer((_) => Stream.value(mockTasks));
    mockito
        .when(mockBoardRepository.readBoards())
        .thenAnswer((_) => Stream.fromIterable([mockBoards, updatedBoards]));

    final expectedInitialMap = {
      'To Do': [mockTasks[0]],
      'In Progress': [mockTasks[1]],
      'Done': [mockTasks[2]],
    };

    final expectedUpdatedMap = {
      'To Do': [mockTasks[0]],
      'In Progress': [mockTasks[1]],
      'Review': [],
    };

    // Act
    final taskStream = getTasksUseCase();

    // Assert
    expect(taskStream, emitsInOrder([expectedInitialMap, expectedUpdatedMap]));
  });

  test('should not emit a new map if there are no changes in tasks or boards',
      () async {
    // Arrange
    mockito
        .when(mockTaskRepository.getTasks())
        .thenAnswer((_) async => mockTasks);
    mockito
        .when(mockBoardRepository.getBoards())
        .thenAnswer((_) async => mockBoards);

    mockito
        .when(mockTaskRepository.readTasks())
        .thenAnswer((_) => Stream.value(mockTasks));
    mockito
        .when(mockBoardRepository.readBoards())
        .thenAnswer((_) => Stream.value(mockBoards));

    final expectedMap = {
      'To Do': [mockTasks[0]],
      'In Progress': [mockTasks[1]],
      'Done': [mockTasks[2]],
    };

    // Act
    final taskStream = getTasksUseCase();

    // Assert
    expect(taskStream, emitsInOrder([expectedMap, emitsDone]));
  });
}
