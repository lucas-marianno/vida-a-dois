import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/task/task_bloc.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_tile.dart';

import '../../../../helper/mock_blocs.dart';

void main() {
  final multiBloc = MultiMockBloc();

  final mockTask = Task(title: 'do something', status: 'todo');
  final tile = KanbanTile(
    task: mockTask,
    tileWidth: 50,
    horizontalScrollController: ScrollController(),
  );

  final kanbanTile =
      MaterialApp(home: multiBloc.provideWithBlocs(Material(child: tile)));

  final taskBloc = multiBloc.task;

  testWidgets('should trigger a ReadTaskEvent when tapped', (tester) async {
    // arrange
    Task? eventTask;
    taskBloc.on<ReadTaskEvent>((event, emit) => eventTask = event.task);
    await tester.pumpWidget(kanbanTile);

    // act
    final foundTile = find.byType(KanbanTile);
    await tester.tap(foundTile);

    // assert
    expect(eventTask, mockTask);
  });
  testWidgets('should open taskForm when tapped', skip: true, (tester) async {
    // arrange
    // Task? eventTask;
    // taskBloc.on<ReadTaskEvent>((event, emit) => eventTask = event.task);
    await tester.pumpWidget(kanbanTile);

    // find kanban tile
    final foundTile = find.byType(KanbanTile);

    // send tap
    await tester.tap(foundTile);

    // TODO: must learn/implement taskBloc test first
    // it will never return anything because it is an empty mock bloc
    // expect form shown

    // final foundTaskForm = find.byType(TaskForm);

    // expect(foundTaskForm, findsOneWidget);
  });
}
