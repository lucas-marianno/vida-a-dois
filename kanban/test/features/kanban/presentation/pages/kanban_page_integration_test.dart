import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/logger/logger.dart';
import 'package:kanban/src/data/data_sources/board_data_source.dart';
import 'package:kanban/src/data/models/board_model.dart';
import 'package:kanban/src/presentation/pages/kanban_page.dart';
import 'package:vida_a_dois/injection_container.dart';
import 'package:vida_a_dois/core/util/logger.dart';

import 'package:kanban/src/presentation/widgets/kanban/kanban_board.dart';
import 'package:kanban/src/presentation/widgets/kanban/kanban_tile.dart';

import 'package:mockito/mockito.dart' as mockito;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../../../../helper/testable_app.dart';

Future<void> main() async {
  late final Widget app;

  final l10n = await L10n.from('en');
  late final BoardDataSource boardDS;

  setUpAll(() {
    app = TestableApp(KanbanPage());

    boardDS = locator<BoardDataSource>();
  });

  setUp(() async => await fakeFirestore.clearPersistence());

  testWidgets('should find an empty kanban board', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(KanbanPage), findsOneWidget);
    expect(find.byType(KanbanBoard), findsNothing);
    expect(find.byType(KanbanTile), findsNothing);
    expect(find.byKey(const Key('noBoardsYetDialog')), findsOneWidget);
  });

  testWidgets('`create board dialog` should show a `BoardForm`',
      (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final noBoardsDialog = find.byKey(const Key('noBoardsYetDialog'));
    final createBoardButton = find.descendant(
      of: noBoardsDialog,
      matching: find.text(l10n.ok),
    );
    expect(createBoardButton, findsOneWidget);

    await tester.runAsync(() async => await tester.tap(createBoardButton));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('boardForm')), findsOneWidget);
  });

  testWidgets('should show a `BoardForm` when `add board` is tapped',
      (tester) async {
    //arrange
    await boardDS.updateBoards([BoardModel(title: 'title', index: 0)]);

    //run app
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final addBoardButton = find.byKey(const Key('addBoardButton'));
    expect(addBoardButton, findsOneWidget);

    await tester.runAsync(() async => await tester.tap(addBoardButton));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('boardForm')), findsOneWidget);
  });

  testWidgets(
      'should show `NameNotUniqueException` '
      'when creating kanban board with repeated name', (tester) async {
    //arrange
    await boardDS.updateBoards([BoardModel(title: 'title', index: 0)]);

    //run app
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // assert initial conditions
    final boards = find.byType(KanbanBoard);
    expect(boards, findsOneWidget);
    final firstBoardName = tester.widget<KanbanBoard>(boards).board.title;

    // tap '+' add board button
    final addBoardButton = find.byKey(const Key('addBoardButton'));
    await tester.runAsync(() async => await tester.tap(addBoardButton));
    await tester.pumpAndSettle();

    // should find a `boardForm` in create mode
    final boardForm = find.byKey(const Key('boardForm'));
    expect(boardForm, findsOneWidget);
    expect(find.text(l10n.creatingABoard), findsOneWidget);

    // find board name field
    final boardNameField = find.byType(TextFormField);
    expect(boardNameField, findsWidgets);

    // enter a repeated name
    await tester.enterText(boardNameField.first, firstBoardName);

    // drag until find 'done button'
    final doneButton = find.byKey(const Key('boardFormDoneButton'));
    await tester.dragUntilVisible(
      doneButton,
      boardForm,
      const Offset(0, -250),
    );
    await tester.pumpAndSettle();

    // tap 'done button'
    await tester.runAsync(() async => await tester.tap(doneButton));
    await tester.pumpAndSettle();

    // should have thrown a `NameNotUniqueException`
    final errorMessage = find.text(l10n.boardUniqueNameException);
    expect(errorMessage, findsOneWidget);

    // find ok button
    final okButton = find.text(l10n.ok);
    expect(okButton, findsOneWidget);

    // tap ok button
    await tester.runAsync(() async => await tester.tap(okButton));
    await tester.pumpAndSettle();

    // should find only one board
    expect(find.byType(KanbanBoard), findsOneWidget);
  });
}
