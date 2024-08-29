import 'package:flutter/material.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../helper/mock_blocs.dart';

import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/injection_container.dart';
import 'package:vida_a_dois/features/user_settings/domain/entities/user_settings.dart';
import 'package:vida_a_dois/features/kanban/presentation/pages/kanban_page.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_board.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_tile.dart';

final fakeFirestore = FakeFirebaseFirestore();

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpLocator(fakeFirestore);

  fakeFirestore.clearPersistence();

  await fullIntegrationTests(skip: true);
  await mockKanbanTests(skip: false);
}

Future<void> fullIntegrationTests({bool skip = false}) async {
  group('integration tests', skip: skip, () {
    final app = MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityBloc>(create: (_) => ConnectivityBloc()),
        BlocProvider<UserSettingsBloc>(create: (_) => UserSettingsBloc()),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<BoardBloc>(create: (_) => locator<BoardBloc>()),
        BlocProvider<TaskBloc>(create: (_) => locator<TaskBloc>()),
      ],
      child: const VidaADoidApp(),
    );
    group('kanban layout', () {
      testWidgets('should find kanban page\n' 'should find a kanban board',
          (tester) async {
        await tester.pumpWidget(app);
        await tester.pumpAndSettle();

        expect(find.byType(KanbanPage), findsOneWidget);
        expect(find.byType(KanbanBoard), findsNWidgets(1));
      });
    });
    group('task', () {
      testWidgets('should find no kanban tile', (tester) async {
        await tester.pumpWidget(app);
        await tester.pumpAndSettle();

        expect(find.byType(KanbanTile), findsNothing);
      });
      testWidgets('should create new task', (tester) async {
        // run app
        await tester.pumpWidget(app);
        await tester.pumpAndSettle();

        // tap create task
        await tester.runAsync(() async {
          await tester.tap(find.byIcon(Icons.add).first);
        });
        await tester.pump();

        // should open new task form
        expect(find.byKey(const Key('taskForm')), findsOneWidget);

        // scroll down and find done button
        final doneButton = find.byKey(const Key('doneButton'));
        await tester.dragUntilVisible(
          doneButton,
          find.byKey(const Key('taskForm')),
          const Offset(0, -250),
        );

        // tap done button
        await tester.tap(doneButton);
        await tester.pumpAndSettle();

        // should have created a new task
        expect(find.byType(KanbanTile), findsOneWidget);
      });

      testWidgets('should show edit task form', (tester) async {
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
      testWidgets('should delete created task', (tester) async {
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
  });
}

Future<void> mockKanbanTests({bool skip = false}) async {
  final mockUserSettingsBloc = MockUserSettingsBloc();
  final mockConnectivityBloc = MockConnectivityBloc();
  final mockAuthBloc = MockAuthBloc();

  final app = MultiBlocProvider(
    providers: [
      BlocProvider<ConnectivityBloc>(create: (_) => mockConnectivityBloc),
      BlocProvider<UserSettingsBloc>(create: (_) => mockUserSettingsBloc),
      BlocProvider<AuthBloc>(create: (_) => mockAuthBloc),
      BlocProvider<BoardBloc>(create: (_) => locator<BoardBloc>()),
      BlocProvider<TaskBloc>(create: (_) => locator<TaskBloc>()),
    ],
    child: const VidaADoidApp(),
  );

  group('mock kanban', skip: skip, () {
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
      when(
        () => mockAuthBloc.state,
      ).thenReturn(AuthAuthenticated(mockUser));
      when(
        () => mockUserSettingsBloc.state,
      ).thenReturn(UserSettingsLoaded(mockUserSettings));
    });

    testWidgets('should find kanban page', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byType(KanbanPage), findsOneWidget);
    });

    testWidgets('should find no kanban boards yet', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byType(KanbanBoard), findsNothing);
      expect(find.byKey(const Key('noBoardsYetDialog')), findsOneWidget);
    });

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
      print(doneButton);
      await tester.pump();
      expect(doneButton, findsOneWidget);

      // // tap 'done button'
      await tester.runAsync(() async => await tester.tap(doneButton));
      // await tester.pump();

      // // should find a kanban board
      // expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should find a kanban board', skip: true, (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      expect(find.byType(KanbanBoard), findsOneWidget);
    });
    testWidgets('should find a kanban tile', skip: true, (tester) async {
      await tester.pumpWidget(app);

      await tester.pumpAndSettle();
      expect(find.byType(KanbanTile), findsOneWidget);
    });
  });
}
