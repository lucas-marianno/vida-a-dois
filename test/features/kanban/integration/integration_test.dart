import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';
import 'package:vida_a_dois/injection_container.dart';
import 'package:vida_a_dois/core/util/logger/logger.dart';

import 'package:vida_a_dois/features/kanban/presentation/pages/kanban_page.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_board.dart';

import 'package:mockito/mockito.dart' as mockito;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../../../helper/mock_blocs.dart';
import '../../../helper/mock_generator.mocks.dart';

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

  final l10n = await L10n.from('en');

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

  testWidgets('should find an empty kanban page', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.byType(KanbanPage), findsOneWidget);
    expect(find.byType(KanbanBoard), findsNothing);
    expect(find.text(l10n.noBoardsYet), findsOneWidget);
    expect(find.byKey(const Key('noBoardsYetDialog')), findsOneWidget);
  });
}
