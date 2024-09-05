import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';
import 'package:vida_a_dois/features/kanban/data/data_sources/task_data_source.dart';
import 'package:vida_a_dois/features/kanban/data/models/task_model.dart';
import 'package:vida_a_dois/features/kanban/domain/constants/enum/task_importance.dart';
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
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../../../helper/mock_blocs.dart';
import '../../../helper/mock_generator.mocks.dart';

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

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    setUpLocator(fakeFirestore, fakeAuth, fakeConnectivity);
    initLogger(Log(level: Level.all));

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
  group('task', () {
    group('task create and delete', skip: true, () {
      late BoardDataSource boardDS;
      setUpAll(() async {
        await fakeFirestore.clearPersistence();

        boardDS = BoardDataSourceImpl(
          firestoreReferences: FirestoreReferencesImpl(
            firestoreInstance: fakeFirestore,
            firebaseAuth: fakeAuth,
          ),
        );
      });

      setUp(() async {
        await boardDS.updateBoards(
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

      testWidgets('should show edit task form in read mode', (tester) async {
        // run app
        await tester.pumpWidget(app);
        await tester.pumpAndSettle();

        // should there be a kanban tile
        final kanbanTile = find.byType(KanbanTile).first;
        expect(kanbanTile, findsOneWidget);

        // tap tile
        await tester.runAsync(() async => await tester.tap(kanbanTile));
        await tester.pumpAndSettle();

        // should open edit task form in read mode
        final taskForm = find.byKey(const Key('taskForm'));
        expect(taskForm, findsOneWidget);
        expect(find.text(l10n.readingATask), findsOneWidget);
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
    group('task editing', () {
      late BoardDataSource boardDS;
      late TaskDataSource taskDS;

      setUpAll(() async {
        await fakeFirestore.clearPersistence();

        final fakeRef = FirestoreReferencesImpl(
          firestoreInstance: fakeFirestore,
          firebaseAuth: fakeAuth,
        );

        boardDS = BoardDataSourceImpl(firestoreReferences: fakeRef);
        taskDS = TaskDataSourceImpl(firestoreReferences: fakeRef);
      });
      testWidgets('should be empty', (tester) async {
        await fakeFirestore.clearPersistence();

        await tester.pumpWidget(app);
        await tester.pumpAndSettle();

        final kanbanPage = find.byType(KanbanPage);
        expect(kanbanPage, findsOneWidget);

        final kanbanBoard = find.byType(KanbanBoard);
        expect(kanbanBoard, findsNothing);

        final kanbanTile = find.byType(KanbanTile);
        expect(kanbanTile, findsNothing);
      });
      testWidgets('should there be a kanban board', (tester) async {
        await fakeFirestore.clearPersistence();
        await boardDS.updateBoards([BoardModel(title: 'title', index: 0)]);

        await tester.pumpWidget(app);
        await tester.pumpAndSettle();

        final kanbanPage = find.byType(KanbanPage);
        expect(kanbanPage, findsOneWidget);

        final kanbanBoard = find.byType(KanbanBoard);
        expect(kanbanBoard, findsOneWidget);

        final kanbanTile = find.byType(KanbanTile);
        expect(kanbanTile, findsNothing);
      });

      testWidgets('should there be a kanban tile', (tester) async {
        await fakeFirestore.clearPersistence();
        logger.info(fakeFirestore.dump());
        // await tester.pumpWidget(app);
        // await tester.pumpAndSettle();

        await boardDS.updateBoards([BoardModel(title: 'to do', index: 0)]);
        await taskDS.createTask(TaskModel(
          id: 'id de cu é rola',
          title: 'tasj title do caralho',
          description: 'meu cu',
          assingneeUID: 'tua mãe',
          assingneeInitials: '4Q',
          taskImportance: TaskImportance.normal,
          status: "to do",
          dueDate: DateTime.now(),
          createdBy: 'minha rola',
          createdDate: DateTime.now(),
        ));

        // await tester.pumpAndSettle();
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

        logger.warning(fakeFirestore.dump());

        final kanbanPage = find.byType(KanbanPage);
        expect(kanbanPage, findsOneWidget);

        final kanbanBoard = find.byType(KanbanBoard);
        expect(kanbanBoard, findsOneWidget);

        final kanbanTile = find.byType(KanbanTile);
        expect(kanbanTile, findsOneWidget);
      });

      testWidgets('should edit task title', skip: true, (tester) async {
        // run app
        await tester.pumpWidget(app);
        await tester.pumpAndSettle();

        // tap tile
        final kanbanTile = find.byType(KanbanTile).first;
        await tester.runAsync(() async => await tester.tap(kanbanTile));
        await tester.pumpAndSettle();

        // open edit task form in read mode
        final taskForm = find.byKey(const Key('taskForm'));
        expect(taskForm, findsOneWidget);
        expect(find.text(l10n.readingATask), findsOneWidget);

        // scroll until edit/cancel button is visible
        final editCancelButton = find.byKey(const Key('editCancelButton'));
        await tester.dragUntilVisible(
          editCancelButton,
          taskForm,
          const Offset(0, -50),
        );
        await tester.pumpAndSettle();

        // tap edit button
        await tester.tap(editCancelButton);
        await tester.pumpAndSettle();

        // should have entered edit mode
        expect(find.text(l10n.editingATask), findsOneWidget);

        // find task title
        final taskTitle = find.byKey(Key('${l10n.task}FormField'));
        // final taskTitle = find.byType(MyFormField);

        logger.wtf(taskTitle);
        expect(taskTitle, findsOneWidget);

        // enter new task title
        const newTaskTitle = 'new task title';
        await tester.runAsync(() async => await tester.tap(taskTitle));
        await tester.pumpAndSettle();
        await tester.enterText(taskTitle, newTaskTitle);

        // should have entered new title
        expect(find.text(newTaskTitle), findsOneWidget);
      });
    });
  });
}
