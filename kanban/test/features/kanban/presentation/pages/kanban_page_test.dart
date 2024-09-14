import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kanban/core/logger/logger.dart';
import 'package:kanban/src/domain/entities/board_entity.dart';
import 'package:kanban/src/domain/entities/task_entity.dart';

import 'package:kanban/src/injection_container.dart';
import 'package:kanban/src/presentation/bloc/board/board_bloc.dart';
import 'package:kanban/src/presentation/bloc/task/task_bloc.dart';
import 'package:kanban/src/presentation/pages/kanban_page.dart';
import 'package:kanban/src/presentation/widgets/kanban/kanban_board.dart';
import 'package:kanban/src/presentation/widgets/kanban/kanban_tile.dart';

import 'package:mockito/mockito.dart';
import '../../../../helper/fake_board_repository.dart';
import '../../../../helper/mock_generator.mocks.dart';
import '../../../../helper/testable_app.dart';

void main() async {
  initLogger(Log(level: Level.all));

  final boardRepo = FakeBoardRepository();
  final taskRepo = MockTaskRepository();

  setUpLocator(boardRepo, taskRepo);

  late final Widget app;
  late final BoardBloc boardBloc;
  late final TaskBloc taskBloc;

  setUpAll(() {
    // // board repo stub
    // when(boardRepo.readBoards()).thenAnswer((_) => Stream.value([]));
    // when(boardRepo.getBoards()).thenAnswer((_) async => []);

    // task repo stub
    when(taskRepo.readTasks()).thenAnswer((_) => Stream.value([]));
    when(taskRepo.getTaskList()).thenAnswer((_) async => []);

    boardBloc = locator<BoardBloc>();
    taskBloc = locator<TaskBloc>();
    app = TestableApp(
      const KanbanPage(),
      boardBloc: boardBloc,
      taskBloc: taskBloc,
    );
  });

  testWidgets('should find an empty kanban page', (tester) async {
    await tester.pumpWidget(app);
    await tester.pump();

    expect(find.byType(KanbanPage), findsOneWidget);
    expect(find.byType(KanbanBoard), findsNothing);
    expect(find.byType(KanbanTile), findsNothing);
    expect(find.byKey(const Key('noBoardsYetDialog')), findsOneWidget);
  });
}
