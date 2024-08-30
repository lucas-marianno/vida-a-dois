import 'package:flutter/material.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vida_a_dois/core/util/logger/logger.dart';
import 'package:vida_a_dois/features/kanban/data/cloud_firestore/firestore_references.dart';
import 'package:vida_a_dois/features/kanban/data/data_sources/board_data_source.dart';
import 'package:vida_a_dois/features/kanban/data/models/board_model.dart';
import '../helper/mock_blocs.dart';

import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/injection_container.dart';
import 'package:vida_a_dois/features/user_settings/domain/entities/user_settings.dart';
import 'package:vida_a_dois/features/kanban/presentation/pages/kanban_page.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_board.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_tile.dart';

final fakeFirestore = FakeFirebaseFirestore();
final fakeAuth = MockFirebaseAuth();

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpLocator(fakeFirestore, fakeAuth);

  initLogger(Log(level: Level.warning));

  fakeFirestore.clearPersistence();

  await runIntegrationTests(skip: false);
}

Future<void> runIntegrationTests({bool skip = false}) async {
  final mockUserSettingsBloc = MockUserSettingsBloc();
  final mockConnectivityBloc = MockConnectivityBloc();

  final app = MultiBlocProvider(
    providers: [
      BlocProvider<ConnectivityBloc>(create: (_) => mockConnectivityBloc),
      BlocProvider<UserSettingsBloc>(create: (_) => mockUserSettingsBloc),
      BlocProvider<AuthBloc>(create: (_) => locator<AuthBloc>()),
      BlocProvider<BoardBloc>(create: (_) => locator<BoardBloc>()),
      BlocProvider<TaskBloc>(create: (_) => locator<TaskBloc>()),
    ],
    child: const VidaADoidApp(),
  );

  final mockUser = MockUser(email: 'email@mail.com', uid: 'uid123');
  final mockUserSettings = UserSettings(
    uid: 'uid134',
    userName: 'userName',
    themeMode: ThemeMode.light,
    locale: const Locale('en'),
    initials: 'un',
  );

  setUp(() {
    when(
      () => mockConnectivityBloc.state,
    ).thenReturn(HasInternetConnection());
    // when(
    //   () => mockAuthBloc.state,
    // ).thenReturn(AuthAuthenticated(mockUser));
    when(
      () => mockUserSettingsBloc.state,
    ).thenReturn(UserSettingsLoaded(mockUserSettings));
  });

  testWidgets('should find an empty kanban page', (tester) async {
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

    testWidgets('should find an empty kanban board', skip: false,
        (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byType(KanbanBoard), findsOneWidget);
      expect(find.byType(KanbanTile), findsNothing);
    });
  });
  group('task', skip: false, () {
    fakeFirestore.clearPersistence();
    final fakeRefs = FirestoreReferencesImpl(fakeFirestore);
    final boardDataSource =
        BoardDataSourceImpl(boardsDocReference: fakeRefs.boardsDocRef);

    testWidgets('should create new task', (tester) async {
      await boardDataSource.updateBoards(
        [BoardModel(title: 'New Board', index: 0)],
      );
      print(fakeFirestore.dump());

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

      // // should have created a new task
      // expect(find.byType(KanbanTile), findsOneWidget);
    });

    testWidgets('should show edit task form', skip: true, (tester) async {
      // run app
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // tap tile
      await tester.runAsync(() async {
        await tester.tap(find.byType(KanbanTile).first);
      });
      await tester.pump();

      // should open edit task form
      expect(find.byKey(const Key('taskForm')), findsOneWidget);
    });
    testWidgets('should delete created task', skip: true, (tester) async {
      // run app
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // find tile and click
      await tester.runAsync(() async {
        await tester.tap(find.byType(KanbanTile).first);
      });
      await tester.pump();

      // scroll until edit/cancel button is visible
      final editCancelButton = find.byKey(const Key('editCancelButton'));
      await tester.dragUntilVisible(
        editCancelButton,
        find.byKey(const Key('taskForm')),
        const Offset(0, -250),
      );

      // tap edit button
      await tester.tap(editCancelButton);
      await tester.pumpAndSettle();

      // tap delete button
      await tester.runAsync(() async {
        await tester.tap(find.byIcon(Icons.delete));
      });
      await tester.pump();

      // tap 'ok' on confirmation button
      await tester.runAsync(() async {
        await tester.tap(find.text('Ok'));
      });
      await tester.pump();
      expect(find.byType(KanbanTile), findsNothing);
    });
  });
}
