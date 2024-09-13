import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vida_a_dois/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:vida_a_dois/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vida_a_dois/features/user_settings/presentation/bloc/user_settings_bloc.dart';
import 'package:kanban/src/presentation/bloc/board/board_bloc.dart';
import 'package:kanban/src/presentation/bloc/task/task_bloc.dart';

export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:bloc_test/bloc_test.dart';

export 'package:vida_a_dois/core/connectivity/bloc/connectivity_bloc.dart';
export 'package:vida_a_dois/features/auth/presentation/bloc/auth_bloc.dart';
export 'package:vida_a_dois/features/user_settings/presentation/bloc/user_settings_bloc.dart';
export 'package:kanban/src/presentation/bloc/board/board_bloc.dart';
export 'package:kanban/src/presentation/bloc/task/task_bloc.dart';

// Mock Blocs
class MockConnectivityBloc
    extends MockBloc<ConnectivityEvent, ConnectivityState>
    implements ConnectivityBloc {}

class MockUserSettingsBloc
    extends MockBloc<UserSettingsEvent, UserSettingsState>
    implements UserSettingsBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockBoardBloc extends MockBloc<BoardEvent, BoardState>
    implements BoardBloc {}

class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

class MultiMockBloc {
  late final ConnectivityBloc connectivity;
  late final UserSettingsBloc userSettings;
  late final AuthBloc auth;
  late final BoardBloc board;
  late final TaskBloc task;

  void initBlocs() {
    connectivity = MockConnectivityBloc();
    userSettings = MockUserSettingsBloc();
    auth = MockAuthBloc();
    board = MockBoardBloc();
    task = MockTaskBloc();
  }

  Widget provideWithBlocs(Widget widget) {
    initBlocs();
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityBloc>(create: (_) => connectivity),
        BlocProvider<UserSettingsBloc>(create: (_) => userSettings),
        BlocProvider<AuthBloc>(create: (_) => auth),
        BlocProvider<BoardBloc>(create: (_) => board),
        BlocProvider<TaskBloc>(create: (_) => task),
      ],
      child: widget,
    );
  }
}
