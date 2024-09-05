import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/injection_container.dart';

import 'package:vida_a_dois/core/i18n/l10n.dart';
import 'package:vida_a_dois/core/util/logger/logger.dart';

import 'package:vida_a_dois/features/kanban/data/data_sources/board_data_source.dart';
import 'package:vida_a_dois/features/kanban/data/data_sources/task_data_source.dart';
import 'package:vida_a_dois/features/kanban/data/models/board_model.dart';
import 'package:vida_a_dois/features/kanban/data/models/task_model.dart';
import 'package:vida_a_dois/features/kanban/presentation/pages/kanban_page.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_board.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_tile.dart';

import 'package:mockito/mockito.dart' as mockito;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../../../helper/mock_blocs.dart';
import '../../../helper/mock_generator.mocks.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  initLogger(Log(level: Level.warning));

  late final Widget app;
  final l10n = await L10n.from('en');
  final fakeFirestore = FakeFirebaseFirestore();

  setUpAll(() {
    final fakeConnectivity = MockConnectivity();
    final fakeAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(
        uid: 'uid123',
        email: 'mockUser@mail.com',
        displayName: 'mock user',
      ),
    );

    setUpLocator(fakeFirestore, fakeAuth, fakeConnectivity);

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
  group('task create and delete', () {
    late BoardDataSource boardDS;
    setUpAll(() async {
      await fakeFirestore.clearPersistence();

      boardDS = locator<BoardDataSource>();
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

    final mockBoard = BoardModel(title: 'to do', index: 0);
    final mockTask = TaskModel(title: 'do this', status: "to do");

    setUpAll(() async {
      await fakeFirestore.clearPersistence();

      boardDS = locator<BoardDataSource>();
      taskDS = locator<TaskDataSource>();
    });

    setUp(() async {
      await fakeFirestore.clearPersistence();

      await boardDS.updateBoards([mockBoard]);
      await taskDS.createTask(mockTask);
    });

    testWidgets('ensure setUp() works correctly', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final kanbanPage = find.byType(KanbanPage);
      expect(kanbanPage, findsOneWidget);

      final kanbanBoard = find.byType(KanbanBoard);
      expect(kanbanBoard, findsOneWidget);

      final kanbanTile = find.byType(KanbanTile);
      expect(kanbanTile, findsOneWidget);
    });

    testWidgets('should edit task title', (tester) async {
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

      // find task title form field
      final taskTitleFormField = find.byKey(Key('${l10n.task}FormField'));
      await tester.dragUntilVisible(
        taskTitleFormField,
        taskForm,
        const Offset(0, 50),
      );
      expect(taskTitleFormField, findsOneWidget);

      // enter new task title
      const newTaskTitle = 'new task title';
      await tester.enterText(taskTitleFormField, newTaskTitle);
      await tester.pumpAndSettle();

      // should have entered new title
      expect(find.text(newTaskTitle), findsOneWidget);

      // find done button
      final doneButton = find.byKey(const Key('doneButton'));
      await tester.dragUntilVisible(
        doneButton,
        taskForm,
        const Offset(0, -100),
      );
      expect(doneButton, findsOneWidget);

      // tap done button
      await tester.runAsync(() async => await tester.tap(doneButton));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // should be back in `KanbanPage` with an updated `Task`
      expect(taskForm, findsNothing);
      expect(kanbanTile, findsOneWidget);

      final tileWidget = tester.widget<KanbanTile>(kanbanTile);
      expect(tileWidget.task.title, newTaskTitle);
    });
    testWidgets('should edit task description', (tester) async {
      // for some reason, this is the only way to not glitch everything when
      // running test in dart vm with headless mode (aka vs code testing).
      // why does it happen? no idea, it just works
      tester.view.physicalSize = const Size(1080, 1920);

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

      // find task description form field
      final taskDescriptionFormField =
          find.byKey(Key('${l10n.taskDescription}FormField'));
      await tester.dragUntilVisible(
        taskDescriptionFormField,
        taskForm,
        const Offset(0, 50),
      );
      expect(taskDescriptionFormField, findsOneWidget);

      // enter new task description
      const newTaskDescription = 'new task long description with many words';
      await tester.enterText(taskDescriptionFormField, newTaskDescription);
      await tester.pumpAndSettle();

      // should have entered new description
      expect(find.text(newTaskDescription), findsOneWidget);

      // find done button
      final doneButton = find.byKey(const Key('doneButton'));
      await tester.dragUntilVisible(
        doneButton,
        taskForm,
        const Offset(0, -100),
      );
      expect(doneButton, findsOneWidget);

      // tap done button
      await tester.runAsync(() async => await tester.tap(doneButton));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // should be back in `KanbanPage` with an updated `Task`
      expect(taskForm, findsNothing);
      expect(kanbanTile, findsOneWidget);

      final tileWidget = tester.widget<KanbanTile>(kanbanTile);
      expect(tileWidget.task.description, newTaskDescription);
    });
  });
}
