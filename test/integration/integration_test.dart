import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/injection_container.dart';
import 'package:vida_a_dois/core/util/logger/logger.dart';

import 'package:vida_a_dois/features/kanban/data/cloud_firestore/firestore_references.dart';
import 'package:vida_a_dois/features/kanban/data/data_sources/board_data_source.dart';
import 'package:vida_a_dois/features/kanban/data/models/board_model.dart';
import 'package:vida_a_dois/features/kanban/presentation/pages/kanban_page.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_board.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_tile.dart';

import 'package:mockito/mockito.dart' as mockito;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import '../helper/mock_blocs.dart';
import '../helper/mock_generator.mocks.dart';

void main() async {
  late final Widget app;

  final mockUser = MockUser(
    uid: 'uid123',
    email: 'mockUser@mail.com',
    displayName: 'mock user',
  );
  final fakeFirestore = FakeFirebaseFirestore();
  final fakeAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
  final fakeConnectivity = MockConnectivity();

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
  });

  testWidgets('should find an empty kanban page', skip: false, (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(KanbanPage), findsOneWidget);
    expect(find.byType(KanbanBoard), findsNothing);
    expect(find.byKey(const Key('noBoardsYetDialog')), findsOneWidget);
  });
  group('board', skip: false, () {
    testWidgets('should create a first kanban board', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // should find an `ok button`
      final okButton = find.text('Ok');
      expect(okButton, findsOneWidget);

      // tap 'ok button'
      await tester.runAsync(() async => await tester.tap(okButton));
      await tester.pump();

      // should find a `boardForm`
      final boardForm = find.byKey(const Key('boardForm'));
      expect(boardForm, findsOneWidget);

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
    });

    testWidgets('should find an empty kanban board', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byType(KanbanBoard), findsOneWidget);
      expect(find.byType(KanbanTile), findsNothing);
    });
  });
  group('task', skip: false, () {
    setUpAll(() async {
      fakeFirestore.clearPersistence();

      final boardDataSource = BoardDataSourceImpl(
        firestoreReferences: FirestoreReferencesImpl(
          firestoreInstance: fakeFirestore,
          firebaseAuth: fakeAuth,
        ),
      );

      await boardDataSource.updateBoards(
        [BoardModel(title: 'New Board', index: 0)],
      );
    });

    testWidgets('should create new task', (tester) async {
      // run app
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // tap create task
      final createTaskButton = find.text('New task');
      await tester.runAsync(() async => await tester.tap(createTaskButton));
      await tester.pumpAndSettle();

      // should open new task form
      final taskForm = find.byKey(const Key('taskForm'));
      expect(taskForm, findsOneWidget);

      // scroll down and find done button
      final doneButton = find.byKey(const Key('doneButton'));
      await tester.dragUntilVisible(
        doneButton,
        taskForm,
        const Offset(0, -250),
      );
      await tester.pumpAndSettle();

      // tap done button
      await tester.runAsync(() async => await tester.tap(doneButton));
      await tester.pumpAndSettle();

      // should have created a new task
      expect(find.byType(KanbanTile), findsOneWidget);
    });

    testWidgets('should show edit task form', (tester) async {
      // run app
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // should there be a kanban tile
      final kanbanTile = find.byType(KanbanTile).first;
      expect(kanbanTile, findsOneWidget);

      // tap tile
      await tester.runAsync(() async => await tester.tap(kanbanTile));
      await tester.pumpAndSettle();

      // should open edit task form
      final taskForm = find.byKey(const Key('taskForm'));
      expect(taskForm, findsOneWidget);
    });

    testWidgets('should delete created task', (tester) async {
      // run app
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // should there be a kanban tile
      final kanbanTile = find.byType(KanbanTile).first;
      expect(kanbanTile, findsOneWidget);

      // tap tile
      await tester.runAsync(() async => await tester.tap(kanbanTile));
      await tester.pumpAndSettle();

      // scroll until edit/cancel button is visible
      final editCancelButton = find.byKey(const Key('editCancelButton'));
      final taskForm = find.byKey(const Key('taskForm'));
      await tester.dragUntilVisible(
        editCancelButton,
        taskForm,
        const Offset(0, -250),
      );
      await tester.pumpAndSettle();

      // tap edit button
      await tester.tap(editCancelButton);
      await tester.pumpAndSettle();

      // tap delete button
      final deleteButton = find.byIcon(Icons.delete);
      await tester.runAsync(() async => await tester.tap(deleteButton));
      await tester.pumpAndSettle();

      // tap 'ok' on confirmation button
      final okButton = find.text('Ok');
      await tester.runAsync(() async => await tester.tap(okButton));
      await tester.pumpAndSettle();

      // should have deleted tile
      expect(find.byType(KanbanTile), findsNothing);
    });
  });
}
