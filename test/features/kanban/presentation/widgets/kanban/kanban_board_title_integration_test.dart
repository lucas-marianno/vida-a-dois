import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';
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

  setUp(() async {
    await fakeFirestore.clearPersistence();
    await boardDS.updateBoards([BoardModel(title: 'to do', index: 0)]);
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
