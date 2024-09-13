import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/core/extensions/datetime_extension.dart';
import 'package:kanban/src/presentation/widgets/form/widgets/form_date_picker.dart';
import 'package:kanban/src/domain/constants/enum/task_importance.dart';
import 'package:vida_a_dois/injection_container.dart';

import 'package:vida_a_dois/core/i18n/l10n.dart';
import 'package:vida_a_dois/core/util/logger.dart';

import 'package:kanban/src/data/data_sources/board_data_source.dart';
import 'package:kanban/src/data/data_sources/task_data_source.dart';
import 'package:kanban/src/data/models/board_model.dart';
import 'package:kanban/src/data/models/task_model.dart';
import 'package:kanban/src/presentation/pages/kanban_page.dart';
import 'package:kanban/src/presentation/widgets/kanban/kanban_board.dart';
import 'package:kanban/src/presentation/widgets/kanban/kanban_tile.dart';

import 'package:mockito/mockito.dart' as mockito;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../../../../../helper/mock_blocs.dart';
import '../../../../../helper/mock_generator.mocks.dart';

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
  group('task create and delete from `TaskForm`', () {
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
  group('task editing from `TaskForm`', () {
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
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

      expect(doneButton, findsOneWidget);

      // tap done button
      await tester.runAsync(() async => await tester.tap(doneButton));
      await tester.pumpAndSettle();

      // should be back in `KanbanPage` with an updated `Task`
      expect(taskForm, findsNothing);
      expect(kanbanTile, findsOneWidget);

      final tileWidget = tester.widget<KanbanTile>(kanbanTile);
      expect(tileWidget.task.description, newTaskDescription);
    });

    testWidgets('should edit task importance to "HIGH"', (tester) async {
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

      // find task importance form field
      final taskImportanceFormField =
          find.byKey(Key('${l10n.taskImportance}DropdownField'));
      await tester.dragUntilVisible(
        taskImportanceFormField,
        taskForm,
        const Offset(0, 50),
      );
      expect(taskImportanceFormField, findsOneWidget);

      // select new importance
      await tester.tap(taskImportanceFormField);
      await tester.pumpAndSettle();
      final highImportance = find.text(l10n.high);
      expect(highImportance, findsOneWidget);
      await tester.tap(highImportance);
      await tester.pumpAndSettle();

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

      // should be back in `KanbanPage`
      expect(taskForm, findsNothing);
      expect(kanbanTile, findsOneWidget);

      // `TaskTile` should have been updated
      final tileWidget = tester.widget<KanbanTile>(kanbanTile);
      expect(tileWidget.task.importance, TaskImportance.high);

      // `TaskTile` should show updated importance Icon
      final importanceIcon = find.descendant(
        of: find.byType(KanbanTile),
        matching: find.byIcon(Icons.keyboard_double_arrow_up),
      );
      expect(importanceIcon, findsOneWidget);
    });

    testWidgets('should edit task importance to "LOW"', (tester) async {
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

      // find task importance form field
      final taskImportanceFormField =
          find.byKey(Key('${l10n.taskImportance}DropdownField'));
      await tester.dragUntilVisible(
        taskImportanceFormField,
        taskForm,
        const Offset(0, 50),
      );
      expect(taskImportanceFormField, findsOneWidget);

      // select new importance
      await tester.tap(taskImportanceFormField);
      await tester.pumpAndSettle();
      final lowImportance = find.text(l10n.low);
      expect(lowImportance, findsOneWidget);
      await tester.tap(lowImportance);
      await tester.pumpAndSettle();

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

      // should be back in `KanbanPage`
      expect(taskForm, findsNothing);
      expect(kanbanTile, findsOneWidget);

      // `TaskTile` should have been updated
      final tileWidget = tester.widget<KanbanTile>(kanbanTile);
      expect(tileWidget.task.importance, TaskImportance.low);

      // `TaskTile` should show updated importance Icon
      final importanceIcon = find.descendant(
        of: find.byType(KanbanTile),
        matching: find.byIcon(Icons.keyboard_arrow_down),
      );
      expect(importanceIcon, findsOneWidget);
    });

    testWidgets('should change task status', (tester) async {
      fakeFirestore.clearPersistence();

      // arrange
      final board1 = BoardModel(title: 'to do', index: 0);
      final board2 = BoardModel(title: 'in progress', index: 1);
      final mockTask = TaskModel(title: 'mock title', status: board1.title);
      await boardDS.updateBoards([board1, board2]);
      await taskDS.createTask(mockTask);

      // run app
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // find two boards
      final boards = find.byType(KanbanBoard);
      expect(boards, findsNWidgets(2));

      // find `KanbanTile` in `board1`
      final kanbanTile = find.byType(KanbanTile);
      expect(
        find.descendant(of: boards.first, matching: kanbanTile),
        findsOneWidget,
      );
      expect(
        find.descendant(of: boards.last, matching: kanbanTile),
        findsNothing,
      );

      // tap tile
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

      // find task status form field
      final taskStatusFormField =
          find.byKey(Key('${l10n.taskStatus}DropdownField'));
      await tester.dragUntilVisible(
        taskStatusFormField,
        taskForm,
        const Offset(0, 50),
      );
      expect(taskStatusFormField, findsOneWidget);

      // find new status
      await tester.runAsync(() async => await tester.tap(taskStatusFormField));
      await tester.pumpAndSettle();
      final newStatus = find.descendant(
        of: find.byType(DropdownMenuItem<String>),
        matching: find.text(board2.title),
      );
      expect(newStatus, findsOneWidget);

      // select new status
      await tester.runAsync(() async => await tester.tap(newStatus));
      await tester.pumpAndSettle();

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

      // should be back in `KanbanPage`
      expect(taskForm, findsNothing);
      expect(kanbanTile, findsOneWidget);

      // `TaskTile` should have been updated to `board2`
      expect(boards, findsNWidgets(2));
      expect(
        find.descendant(of: boards.first, matching: kanbanTile),
        findsNothing,
      );
      expect(
        find.descendant(of: boards.last, matching: kanbanTile),
        findsOneWidget,
      );
    });

    testWidgets('should show task.deadline as initial value in deadlinefield',
        (tester) async {
      // arrange
      final taskDeadline = DateTime(2024, 9, 16);
      await fakeFirestore.clearPersistence();
      await boardDS.updateBoards([BoardModel(title: 'to do', index: 0)]);
      await taskDS.createTask(
        TaskModel(title: 'task', status: 'to do', deadline: taskDeadline),
      );

      // run app
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // tap tile
      final kanbanTile = find.byType(KanbanTile).first;
      final dataStamp = find.descendant(
        of: kanbanTile,
        matching: find.text(taskDeadline.toAbreviatedDate(l10n).toUpperCase()),
      );
      expect(dataStamp, findsOneWidget);

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

      // find task deadline
      final taskDeadlineField = find.byType(FormDatePicker);
      await tester.dragUntilVisible(
        taskDeadlineField,
        taskForm,
        const Offset(0, 50),
      );
      await tester.pumpAndSettle();
      expect(taskDeadlineField, findsOneWidget);

      // initial date should be localized and displayed
      final taskDeadlineInitialValue = find.descendant(
        of: taskDeadlineField,
        matching: find.text(taskDeadline.toShortDate(l10n)),
      );

      expect(taskDeadlineInitialValue, findsOneWidget);
    });

    testWidgets('should change `Deadline`', (tester) async {
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

      // find task deadline
      final taskDeadline = find.byType(FormDatePicker);
      await tester.dragUntilVisible(
        taskDeadline,
        taskForm,
        const Offset(0, 50),
      );
      await tester.pumpAndSettle();
      expect(taskDeadline, findsOneWidget);

      // open date picker
      await tester.tap(taskDeadline);
      await tester.pumpAndSettle();
      // enter input mode
      final inputMode = find.byIcon(Icons.edit_outlined);
      expect(inputMode, findsOneWidget);
      await tester.tap(inputMode);
      await tester.pumpAndSettle();

      // enter new date
      final dateField = find.byType(InputDatePickerFormField);
      final deadline = DateTime(1994, 9, 16);
      expect(dateField, findsOneWidget);
      await tester.enterText(
        dateField,
        l10n.dateShort(deadline.day, deadline.month, deadline.year),
      );

      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();

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

      // should be back in `KanbanPage`
      expect(taskForm, findsNothing);
      expect(kanbanTile, findsOneWidget);

      // `TaskTile` should have been updated
      final tileWidget = tester.widget<KanbanTile>(kanbanTile);
      expect(tileWidget.task.deadline, DateTime(1994, 9, 16));

      // `TaskTile` should show updated deadline
      final deadLineIcon = find.descendant(
        of: find.byType(KanbanTile),
        matching: find.byIcon(Icons.calendar_month),
      );
      expect(deadLineIcon, findsOneWidget);
      final deadLineText = find.descendant(
        of: find.byType(KanbanTile),
        matching: find.text(deadline.toAbreviatedDate(l10n).toUpperCase()),
      );
      expect(deadLineText, findsOneWidget);
    });
  });
}
