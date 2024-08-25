import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/board_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';
import 'package:vida_a_dois/features/kanban/presentation/pages/kanban_page.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_board.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_tile.dart';
import 'package:vida_a_dois/features/kanban/util/parse_tasklist_into_taskmap.dart';
import 'package:vida_a_dois/features/user_settings/domain/entities/user_settings.dart';

import '../helper/mock_blocs.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  await kanbanTests();
}

Future<void> kanbanTests() async {
  final mockUserSettingsBloc = MockUserSettingsBloc();
  final mockConnectivityBloc = MockConnectivityBloc();
  final mockAuthBloc = MockAuthBloc();
  final mockTaskBloc = MockTaskBloc();
  final mockBoardBloc = MockBoardBloc();

  final app = MultiBlocProvider(
    providers: [
      BlocProvider<ConnectivityBloc>(create: (_) => mockConnectivityBloc),
      BlocProvider<UserSettingsBloc>(create: (_) => mockUserSettingsBloc),
      BlocProvider<AuthBloc>(create: (_) => mockAuthBloc),
      BlocProvider<BoardBloc>(create: (_) => mockBoardBloc),
      BlocProvider<TaskBloc>(create: (_) => mockTaskBloc),
    ],
    child: const VidaADoidApp(),
  );

  group('kanban', () {
    final mockUser = MockUser(email: 'email@mail.com', uid: 'uid123');
    final mockUserSettings = UserSettings(
      uid: 'uid134',
      userName: 'userName',
      themeMode: ThemeMode.light,
      locale: const Locale('en'),
      initials: 'un',
    );
    final mockBoard = Board(title: 'mock board', index: 0);
    final mockBoardsList = [mockBoard];
    final mockTask = Task(title: 'mock task', status: 'mock board');
    final mockMappedTasks = mergeIntoMap([mockTask], mockBoardsList);

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
      when(
        () => mockBoardBloc.state,
      ).thenReturn(BoardLoadedState(mockBoardsList));
      when(
        () => mockTaskBloc.state,
      ).thenReturn(TasksLoaded(mockMappedTasks));
    });
    testWidgets('should find kanban page', (tester) async {
      await tester.pumpWidget(app);

      await tester.pumpAndSettle();
      expect(find.byType(KanbanPage), findsOneWidget);
    });

    testWidgets('should find a kanban board', (tester) async {
      await tester.pumpWidget(app);

      await tester.pumpAndSettle();
      expect(find.byType(KanbanBoard), findsOneWidget);
    });
    testWidgets('should find a kanban tile', (tester) async {
      await tester.pumpWidget(app);

      await tester.pumpAndSettle();
      expect(find.byType(KanbanTile), findsOneWidget);
    });

    testWidgets('should open new task form', skip: false, (tester) async {
      when(
        () => mockTaskBloc.on<ReadTask>(_onReadTaskEvent),
      ).thenAnswer((_) => TaskLoading());

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('New task').first);
      await tester.pumpAndSettle();

      final form = find.text('Creating a new task');
      expect(form, findsOneWidget);
    });
  });
}

_onReadTaskEvent(ReadTask event, Emitter<TaskState> emit) async {
  // final newTask = await TaskForm(event.context).readTask(event.task);

  // if (newTask == null) return;

  // await updateTask(event.task, newTask);
}
