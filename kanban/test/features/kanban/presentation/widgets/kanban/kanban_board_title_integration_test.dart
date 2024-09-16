import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/logger/logger.dart';
import 'package:kanban/src/domain/entities/board_entity.dart';
import 'package:kanban/src/domain/repository/board_repository.dart';
import 'package:kanban/src/domain/repository/task_repository.dart';
import 'package:kanban/src/injection_container.dart';

import 'package:kanban/src/presentation/pages/kanban_page.dart';

import 'package:kanban/src/presentation/widgets/kanban/kanban_board.dart';
import 'package:kanban/src/presentation/widgets/kanban/kanban_tile.dart';

import '../../../../../helper/fake_board_repository.dart';
import '../../../../../helper/fake_task_repository.dart';
import '../../../../../helper/testable_app.dart';

Future<void> main() async {
  initLogger(Log(level: Level.warning));
  late final Widget app;

  final l10n = await L10n.from('en');

  setUpLocator(FakeBoardRepository(), FakeTaskRepository());
  final boardRepo = locator<BoardRepository>() as FakeBoardRepository;
  final taskRepo = locator<TaskRepository>() as FakeTaskRepository;

  setUpAll(() {
    boardRepo.clearPersistence();
    taskRepo.clearPersistence();

    TestWidgetsFlutterBinding.ensureInitialized();

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
    await boardRepo.updateBoards([const Board(title: 'to do', index: 0)]);
  });

  testWidgets('should find an empty kanban board', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(KanbanPage), findsOneWidget);
    expect(find.byType(KanbanBoard), findsOneWidget);
    expect(find.byType(KanbanTile), findsNothing);
  });

  testWidgets('should rename board', (tester) async {
    // open app
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // should find a kanban board
    final boardFinder = find.byType(KanbanBoard);
    expect(boardFinder, findsOneWidget);
    final boardInitialName =
        tester.widget<KanbanBoard>(boardFinder).board.title;

    // find 'more' button
    final moreButton = find.byIcon(Icons.more_vert);
    expect(moreButton, findsOneWidget);

    // tap 'more' button
    await tester.runAsync(() async => tester.tap(moreButton));
    await tester.pumpAndSettle();

    // find 'rename' context button
    final renameContextButton = find.text(l10n.rename);
    expect(renameContextButton, findsOneWidget);

    // tap 'rename' context button
    await tester.runAsync(() async => tester.tap(renameContextButton));
    await tester.pumpAndSettle();

    // find a text field
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    // enter new board name
    const boardNewName = 'Board new name';
    await tester.enterText(textField, boardNewName);
    await tester.pumpAndSettle();

    // tap confirm button
    final confirmButton = find.byIcon(Icons.check);
    await tester.runAsync(() async => await tester.tap(confirmButton));
    await tester.pumpAndSettle();

    // expect to find renamed board
    expect(textField, findsNothing);
    expect(find.byType(KanbanBoard), findsOneWidget);
    expect(find.text(boardInitialName), findsNothing);
    expect(find.text(boardNewName), findsOneWidget);
  });
  testWidgets('should delete a board from dropdown context', (tester) async {
    // open app
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // find board more button
    final boardMoreButton = find.descendant(
      of: find.byType(KanbanBoard),
      matching: find.byIcon(Icons.more_vert),
    );
    expect(boardMoreButton, findsOneWidget);

    // tap 'more' button
    await tester.runAsync(() async => tester.tap(boardMoreButton));
    await tester.pumpAndSettle();

    // find 'delete' context button
    final deleteContextButton = find.text(l10n.delete);
    expect(deleteContextButton, findsOneWidget);

    // tap 'delete' context button
    await tester.runAsync(() async => tester.tap(deleteContextButton));
    await tester.pumpAndSettle();

    // should find a confirmation dialog
    final confirmationDialog = find.text('${l10n.delete} board?');
    expect(confirmationDialog, findsOneWidget);

    // tap ok
    final okButton = find.text(l10n.ok);
    await tester.runAsync(() async => await tester.tap(okButton));
    await tester.pumpAndSettle();

    // should find one less kanban board
    expect(find.byType(KanbanBoard), findsNothing);
  });
}
