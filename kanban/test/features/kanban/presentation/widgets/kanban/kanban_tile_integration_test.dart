import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_a_dois/injection_container.dart';
import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/core/util/logger.dart';

import 'package:kanban/src/data/data_sources/board_data_source.dart';
import 'package:kanban/src/data/data_sources/task_data_source.dart';
import 'package:kanban/src/data/models/board_model.dart';
import 'package:kanban/src/data/models/task_model.dart';
import 'package:kanban/src/domain/constants/enum/task_importance.dart';
import 'package:kanban/src/presentation/extensions/task_importance_ui_extension.dart';
import 'package:kanban/src/presentation/pages/kanban_page.dart';
import 'package:kanban/src/presentation/widgets/kanban/kanban_board.dart';
import 'package:kanban/src/presentation/widgets/kanban/kanban_tile.dart';

import 'package:mockito/mockito.dart' as mockito;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../../../../../helper/testable_app.dart';
import '../../../../../helper/mock_generator.mocks.dart';

void main() async {
  late final Widget app;
  late final BoardDataSource boardDS;
  late final TaskDataSource taskDS;
  final mockTask = TaskModel(title: 'task title', status: 'to do');
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

    boardDS = locator<BoardDataSource>();
    taskDS = locator<TaskDataSource>();
  });

  setUp(() async {
    await fakeFirestore.clearPersistence();
    await boardDS.updateBoards([BoardModel(title: 'to do', index: 0)]);
    await taskDS.createTask(mockTask);
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
