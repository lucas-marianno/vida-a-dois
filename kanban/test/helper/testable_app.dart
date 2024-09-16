import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/src/presentation/bloc/board/board_bloc.dart';
import 'package:kanban/src/presentation/bloc/task/task_bloc.dart';

import 'mock_blocs.dart';

class TestableApp extends StatelessWidget {
  final Widget child;
  final String languageCode;
  final BoardBloc _boardBloc;
  final TaskBloc _taskBloc;

  TestableApp(
    this.child, {
    this.languageCode = 'en',
    BoardBloc? boardBloc,
    TaskBloc? taskBloc,
    super.key,
  })  : assert(languageCode.length == 2),
        _boardBloc = boardBloc ?? MockBoardBloc(),
        _taskBloc = taskBloc ?? MockTaskBloc();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BoardBloc>(create: (_) => _boardBloc),
        BlocProvider<TaskBloc>(create: (_) => _taskBloc),
      ],
      child: MaterialApp(
        locale: Locale(languageCode),
        localizationsDelegates: L10n.delegates,
        supportedLocales: L10n.supportedLocales,
        home: Material(child: child),
      ),
    );
  }
}
