import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/src/presentation/bloc/board/board_bloc.dart';
import 'package:kanban/src/presentation/bloc/task/task_bloc.dart';

class TestableApp extends StatelessWidget {
  final Widget child;
  final String languageCode;
  final BoardBloc boardBloc;
  final TaskBloc taskBloc;

  const TestableApp(
    this.child, {
    this.languageCode = 'en',
    super.key,
    required this.boardBloc,
    required this.taskBloc,
  }) : assert(languageCode.length == 2);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BoardBloc>(create: (_) => boardBloc),
        BlocProvider<TaskBloc>(create: (_) => taskBloc),
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
