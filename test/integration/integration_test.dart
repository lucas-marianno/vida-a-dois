import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/features/kanban/presentation/pages/kanban_page.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/form/task_form.dart';
import 'package:vida_a_dois/firebase_options.dart';
import 'package:vida_a_dois/injection_container.dart';

import '../helper/mock_blocs.dart';

void main() async {
  HttpOverrides.global = null;

  TestWidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setUpLocator();

  await kanbanTests();
}

Future<void> kanbanTests() async {
  final mockUserSettings = MockUserSettingsBloc();

  final app = MultiBlocProvider(
    providers: [
      BlocProvider<ConnectivityBloc>(create: (_) => ConnectivityBloc()),
      BlocProvider<UserSettingsBloc>(create: (_) => mockUserSettings),
      BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
      BlocProvider<BoardBloc>(create: (_) => locator<BoardBloc>()),
      BlocProvider<TaskBloc>(create: (_) => locator<TaskBloc>()),
    ],
    child: const VidaADoidApp(),
  );

  setUp(() {
    when(() => mockUserSettings.state).thenReturn(UserSettingsLoading());
  });
  testWidgets('should find kanban page', (tester) async {
    await tester.pumpWidget(app);

    await tester.pumpAndSettle();
    expect(find.byType(KanbanPage), findsOneWidget);
  });

  testWidgets('should open new task form', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await tester.tap(find.text('New task').first);
    await tester.pumpAndSettle();

    final form = find.text('Creating a new task');
    expect(form, findsOneWidget);
  });
}
