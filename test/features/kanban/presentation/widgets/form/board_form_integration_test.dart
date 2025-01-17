import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';
import 'package:vida_a_dois/core/widgets/form/modal_form.dart';
import 'package:vida_a_dois/features/kanban/data/data_sources/board_data_source.dart';
import 'package:vida_a_dois/features/kanban/data/models/board_model.dart';
import 'package:vida_a_dois/features/kanban/presentation/pages/kanban_page.dart';
import 'package:vida_a_dois/injection_container.dart';
import 'package:vida_a_dois/core/util/logger/logger.dart';

import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_board.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_tile.dart';

import 'package:mockito/mockito.dart' as mockito;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../../../../../helper/mock_blocs.dart';
import '../../../../../helper/mock_generator.mocks.dart';

Future<void> main() async {
  late final Widget app;

  final l10n = await L10n.from('en');
  final mockUser = MockUser(
    uid: 'uid123',
    email: 'mockUser@mail.com',
    displayName: 'mock user',
  );
  final fakeFirestore = FakeFirebaseFirestore();
  final fakeAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
  final fakeConnectivity = MockConnectivity();

  late final BoardDataSource boardDS;

  setUpAll(() {
    fakeFirestore.clearPersistence();

    TestWidgetsFlutterBinding.ensureInitialized();
    setUpLocator(fakeFirestore, fakeAuth, fakeConnectivity);
    initLogger(Log(level: Level.warning));

    mockito.when(fakeConnectivity.onConnectivityChanged).thenAnswer((_) {
      return Stream<List<ConnectivityResult>>.fromIterable([
        [ConnectivityResult.wifi]
      ]);
    });

    app = MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityBloc>(
          create: (_) => locator<ConnectivityBloc>(),
        ),
        BlocProvider<UserSettingsBloc>(
          create: (_) => locator<UserSettingsBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => locator<AuthBloc>(),
        ),
        BlocProvider<BoardBloc>(
          create: (_) => locator<BoardBloc>(),
        ),
        BlocProvider<TaskBloc>(
          create: (_) => locator<TaskBloc>(),
        ),
      ],
      child: const VidaADoidApp(),
    );

    boardDS = locator<BoardDataSource>();
  });

  setUp(() async => fakeFirestore.clearPersistence());

  testWidgets('should find an empty kanban page', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(KanbanPage), findsOneWidget);
    expect(find.byType(KanbanBoard), findsNothing);
    expect(find.byType(KanbanTile), findsNothing);
  });

  testWidgets('should create a first kanban board', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // should find an `ok button`
    final okButton = find.text(l10n.ok);
    expect(okButton, findsOneWidget);

    // tap 'ok button'
    await tester.runAsync(() async => await tester.tap(okButton));
    await tester.pump();

    // should find a `boardForm` on create mode
    final boardForm = find.byKey(const Key('boardForm'));
    expect(boardForm, findsOneWidget);
    expect(find.text(l10n.creatingABoard), findsOneWidget);

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

    // should find a kanban board
    expect(find.byType(KanbanBoard), findsOneWidget);
    expect(find.text(l10n.newBoard), findsOneWidget);
  });

  testWidgets('should rename board', (tester) async {
    // arrange
    await boardDS.updateBoards([BoardModel(title: 'title', index: 0)]);

    // run app
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // should find a kanban board
    final initialBoard = find.byType(KanbanBoard);
    expect(initialBoard, findsOneWidget);
    final initialBoardTitle =
        (tester.widget(initialBoard) as KanbanBoard).board.title;

    // find 'more' button
    final moreButton = find.byIcon(Icons.more_vert);
    expect(moreButton, findsOneWidget);

    // tap 'more' button
    await tester.runAsync(() async => tester.tap(moreButton));
    await tester.pumpAndSettle();

    // find 'edit' context button
    final editContextButton = find.text(l10n.edit);
    expect(editContextButton, findsOneWidget);

    // tap 'edit' context button
    await tester.runAsync(() async => tester.tap(editContextButton));
    await tester.pumpAndSettle();

    // should find BoardForm in 'read mode'
    final boardForm = find.byKey(const Key('boardForm'));
    expect(boardForm, findsOneWidget);
    expect(find.text(l10n.readingABoard), findsOneWidget);

    // find edit button
    final editButton = find.byKey(const Key('boardFormEditButton'));
    expect(editButton, findsOneWidget);

    // tap edit button
    await tester.runAsync(() async => await tester.tap(editButton));
    await tester.pumpAndSettle();

    // form should have entered edit mode
    expect(find.text(l10n.editingABoard), findsOneWidget);

    // find a text field
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    // enter new board name
    const boardNewName = 'board new unique name';
    await tester.enterText(textField, boardNewName);
    await tester.pumpAndSettle();

    // find new text on widget
    expect(find.text(boardNewName), findsOneWidget);

    // find done button
    final done = find.byKey(const Key('boardFormDoneButton'));
    expect(done, findsOneWidget);

    // tap confirm button
    await tester.runAsync(() async => await tester.tap(done));
    await tester.pumpAndSettle();

    // expect to find renamed board
    expect(textField, findsNothing);
    final newBoard = find.byType(KanbanBoard);
    expect(newBoard, findsOneWidget);
    final updatedBoardTitle =
        (tester.widget(newBoard) as KanbanBoard).board.title;
    expect(find.text(boardNewName), findsOneWidget);
    expect(updatedBoardTitle, isNot(initialBoardTitle));
  });

  testWidgets('should create second kanban board', (tester) async {
    // arrange
    await boardDS.updateBoards([BoardModel(title: 'title', index: 0)]);

    // run app
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // should find an `addBoardButton`
    final addBoardButton = find.byKey(const Key('addBoardButton'));
    expect(addBoardButton, findsOneWidget);

    // tap '+' add board button
    await tester.runAsync(() async => await tester.tap(addBoardButton));
    await tester.pump();

    // should find a `boardForm` in create mode
    final boardForm = find.byKey(const Key('boardForm'));
    expect(boardForm, findsOneWidget);
    expect(find.text(l10n.creatingABoard), findsOneWidget);

    // find a text field
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    // enter new board name
    const boardNewName = 'Second board';
    await tester.enterText(textField, boardNewName);
    await tester.pumpAndSettle();

    // find new text on widget
    expect(find.text(boardNewName), findsOneWidget);

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

    // should find a kanban board
    expect(find.byType(KanbanBoard), findsNWidgets(2));
    expect(find.text(boardNewName), findsOneWidget);
  });
  testWidgets('should reorder boards', (tester) async {
    // arrange
    final board1 = BoardModel(title: 'first board', index: 0);
    final board2 = BoardModel(title: 'second board', index: 1);
    await boardDS.updateBoards([board1, board2]);

    // run app
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // should find two kanban boards
    final boards = find.byType(KanbanBoard);
    expect(boards, findsNWidgets(2));

    final boardsList = tester.widgetList<KanbanBoard>(boards).toList();
    final board1Title = boardsList.first.board.title;
    final board2Title = boardsList.last.board.title;
    expect(find.text(board1Title), findsOneWidget);
    expect(find.text(board2Title), findsOneWidget);

    // find the two 'more' button
    final moreButton = find.byIcon(Icons.more_vert);
    expect(moreButton, findsNWidgets(2));

    // tap the first 'more' button
    await tester.runAsync(() async => tester.tap(moreButton.first));
    await tester.pumpAndSettle();

    // find 'edit' context button
    final editContextButton = find.text(l10n.edit);
    expect(editContextButton, findsOneWidget);

    // tap 'edit' context button
    await tester.runAsync(() async => tester.tap(editContextButton));
    await tester.pumpAndSettle();

    // should find BoardForm in 'read mode'
    final boardForm = find.byKey(const Key('boardForm'));
    expect(boardForm, findsOneWidget);
    expect(find.text(l10n.readingABoard), findsOneWidget);

    // find edit button
    final editButton = find.byKey(const Key('boardFormEditButton'));
    expect(editButton, findsOneWidget);

    // tap edit button
    await tester.runAsync(() async => await tester.tap(editButton));
    await tester.pumpAndSettle();

    // form should have entered edit mode
    expect(find.text(l10n.editingABoard), findsOneWidget);

    // find reorder button
    final reorderButton = find.byType(FormDropDownMenuButton);
    expect(reorderButton, findsOneWidget);

    // tap reorder button
    await tester.runAsync(() async => await tester.tap(reorderButton));
    await tester.pumpAndSettle();

    // find `DropdownMenuItem`
    final menuItem = find.byType(DropdownMenuItem<String>);
    expect(menuItem, findsWidgets);

    // tap last
    await tester.tap(menuItem.last, warnIfMissed: false);

    // drag until find 'done button'
    final doneButton = find.byKey(const Key('boardFormDoneButton'));
    await tester.dragUntilVisible(
      doneButton,
      boardForm,
      const Offset(0, -50),
    );
    await tester.pumpAndSettle();

    // tap 'done button'
    await tester.runAsync(() async => await tester.tap(doneButton));
    await tester.pumpAndSettle();

    // should find the same two boards
    expect(boards, findsNWidgets(2));
    expect(find.text(board1Title), findsOneWidget);
    expect(find.text(board2Title), findsOneWidget);

    // the two boards should be in reversed order [board2, board1]
    final newBoardsList = tester.widgetList<KanbanBoard>(boards).toList();
    expect(newBoardsList[0].board.title, board2Title);
    expect(newBoardsList[1].board.title, board1Title);
  });

  testWidgets('should delete a board', (tester) async {
    // arrange
    final board1 = BoardModel(title: 'first board', index: 0);
    final board2 = BoardModel(title: 'second board', index: 1);
    await boardDS.updateBoards([board1, board2]);

    // run app
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // should find two kanban boards
    final boards = find.byType(KanbanBoard);
    expect(boards, findsNWidgets(2));

    // find the two 'more' button
    final moreButton = find.byIcon(Icons.more_vert);
    expect(moreButton, findsNWidgets(2));

    // tap the last 'more' button
    await tester.scrollUntilVisible(moreButton.last, 50);
    await tester.pumpAndSettle();
    await tester.runAsync(() async => tester.tap(moreButton.last));
    await tester.pumpAndSettle();

    // find 'edit' context button
    final editContextButton = find.text(l10n.edit);
    expect(editContextButton, findsOneWidget);

    // tap 'edit' context button
    await tester.runAsync(() async => tester.tap(editContextButton));
    await tester.pumpAndSettle();

    // should find BoardForm in 'read mode'
    final boardForm = find.byKey(const Key('boardForm'));
    expect(boardForm, findsOneWidget);
    expect(find.text(l10n.readingABoard), findsOneWidget);

    // find edit button
    final editButton = find.byKey(const Key('boardFormEditButton'));
    expect(editButton, findsOneWidget);

    // tap edit button
    await tester.runAsync(() async => await tester.tap(editButton));
    await tester.pumpAndSettle();

    // form should have entered edit mode
    expect(find.text(l10n.editingABoard), findsOneWidget);

    // find delete button
    final deleteButton = find.byIcon(Icons.delete);
    expect(deleteButton, findsOneWidget);

    // tap delete button
    await tester.runAsync(() async => await tester.tap(deleteButton));
    await tester.pumpAndSettle();

    // should find a confirmation dialog
    final confirmationDialog = find.text('${l10n.delete} board?');
    expect(confirmationDialog, findsOneWidget);

    // tap ok
    final okButton = find.text(l10n.ok);
    await tester.runAsync(() async => await tester.tap(okButton));
    await tester.pumpAndSettle();

    // should find only one kanban board
    expect(find.byType(KanbanBoard), findsOneWidget);
  });
}
