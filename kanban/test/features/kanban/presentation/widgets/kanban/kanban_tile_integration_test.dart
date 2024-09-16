import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban/core/logger/logger.dart';

import 'package:kanban/src/data/models/board_model.dart';
import 'package:kanban/src/data/models/task_model.dart';
import 'package:kanban/src/domain/constants/enum/task_importance.dart';
import 'package:kanban/src/domain/repository/board_repository.dart';
import 'package:kanban/src/domain/repository/task_repository.dart';
import 'package:kanban/src/injection_container.dart';
import 'package:kanban/src/presentation/extensions/task_importance_ui_extension.dart';
import 'package:kanban/src/presentation/pages/kanban_page.dart';
import 'package:kanban/src/presentation/widgets/kanban/kanban_board.dart';
import 'package:kanban/src/presentation/widgets/kanban/kanban_tile.dart';

import '../../../../../helper/fake_board_repository.dart';
import '../../../../../helper/fake_task_repository.dart';
import '../../../../../helper/testable_app.dart';

void main() async {
  initLogger(Log(level: Level.warning));
  setUpLocator(FakeBoardRepository(), FakeTaskRepository());
  late final Widget app;
  final mockTask = TaskModel(title: 'task title', status: 'to do');
  final boardRepo = locator<BoardRepository>() as FakeBoardRepository;
  final taskRepo = locator<TaskRepository>() as FakeTaskRepository;

  setUpAll(() {
    boardRepo.clearPersistence();
    taskRepo.clearPersistence();

    app = TestableApp(
      const KanbanPage(),
      languageCode: 'en',
      boardBloc: locator(),
      taskBloc: locator(),
    );
  });

  setUp(() async {
    boardRepo.clearPersistence();
    taskRepo.clearPersistence();
    await boardRepo.updateBoards([BoardModel(title: 'to do', index: 0)]);
    await taskRepo.createTask(mockTask);
  });

  testWidgets('test setup', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(KanbanPage), findsOneWidget);
    expect(find.byType(KanbanBoard), findsOneWidget);

    final taskTile = find.byType(KanbanTile);
    expect(taskTile, findsOneWidget);
    expect(
      find.descendant(of: taskTile, matching: find.text(mockTask.title)),
      findsOneWidget,
    );
  });

  testWidgets('should push `TaskBoard` when tapped', (tester) async {
    // run app
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // find tile
    final taskTile = find.byType(KanbanTile);
    expect(taskTile, findsOneWidget);

    // tap tile
    await tester.tap(taskTile);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('taskForm')), findsOneWidget);
  });

  testWidgets('should update taskImportance to `HIGH`', (tester) async {
    // run app
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // find tile
    final taskTile = find.byType(KanbanTile);
    expect(taskTile, findsOneWidget);

    // find task importance pop up button
    final taskImportanceButton = find.descendant(
      of: taskTile,
      matching: find.byKey(const Key('taskImportancePopupButton')),
    );
    expect(taskImportanceButton, findsOneWidget);

    // assert it has the correct icon
    final initialIcon = tester
        .widget<Icon>(find.descendant(
            of: taskImportanceButton, matching: find.byType(Icon)))
        .icon;
    expect(initialIcon, TaskImportance.normal.icon);

    // tap importance btn
    await tester.tap(taskImportanceButton);
    await tester.pumpAndSettle();

    // select high importance
    final highImportance = find.byIcon(TaskImportance.high.icon);
    expect(highImportance, findsOneWidget);
    await tester.tap(highImportance);
    await tester.pumpAndSettle();

    // assert icon has changed
    final currentIcon = tester
        .widget<Icon>(find.descendant(
            of: taskImportanceButton, matching: find.byType(Icon)))
        .icon;
    expect(currentIcon, TaskImportance.high.icon);
    expect(currentIcon, isNot(initialIcon));
  });

  testWidgets('should update taskImportance to `LOW`', (tester) async {
    // run app
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // find tile
    final taskTile = find.byType(KanbanTile);
    expect(taskTile, findsOneWidget);

    // find task importance pop up button
    final taskImportanceButton = find.descendant(
      of: taskTile,
      matching: find.byKey(const Key('taskImportancePopupButton')),
    );
    expect(taskImportanceButton, findsOneWidget);

    // assert it has the correct icon
    final initialIcon = tester
        .widget<Icon>(find.descendant(
            of: taskImportanceButton, matching: find.byType(Icon)))
        .icon;
    expect(initialIcon, TaskImportance.normal.icon);

    // tap importance btn
    await tester.tap(taskImportanceButton);
    await tester.pumpAndSettle();

    // select low importance
    final highImportance = find.byIcon(TaskImportance.low.icon);
    expect(highImportance, findsOneWidget);
    await tester.tap(highImportance);
    await tester.pumpAndSettle();

    // assert icon has changed
    final currentIcon = tester
        .widget<Icon>(find.descendant(
            of: taskImportanceButton, matching: find.byType(Icon)))
        .icon;
    expect(currentIcon, TaskImportance.low.icon);
    expect(currentIcon, isNot(initialIcon));
  });
}
