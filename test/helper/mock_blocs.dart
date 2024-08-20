import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vida_a_dois/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:vida_a_dois/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vida_a_dois/features/user_settings/bloc/user_settings_bloc.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/board/board_bloc.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/task/task_bloc.dart';

// Mock Blocs
class _MockConnectivityBloc
    extends MockBloc<ConnectivityEvent, ConnectivityState>
    implements ConnectivityBloc {}

class _MockUserSettingsBloc
    extends MockBloc<UserSettingsEvent, UserSettingsState>
    implements UserSettingsBloc {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _MockBoardBloc extends MockBloc<BoardEvent, BoardState>
    implements BoardBloc {}

class _MockTaskBloc extends MockBloc<TaskEvent, TaskState>
    implements TaskBloc {}

class MultiMockBloc {
  late final ConnectivityBloc connectivity;
  late final UserSettingsBloc userSettings;
  late final AuthBloc auth;
  late final BoardBloc board;
  late final TaskBloc task;

  void initBlocs() {
    connectivity = _MockConnectivityBloc();
    userSettings = _MockUserSettingsBloc();
    auth = _MockAuthBloc();
    board = _MockBoardBloc();
    task = _MockTaskBloc();
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
