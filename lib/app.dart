import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:kanban/core/constants/routes.dart';
import 'package:kanban/core/theme/app_theme.dart';
import 'package:kanban/core/util/logger/logger.dart';
import 'package:kanban/features/kanban/bloc/board/board_bloc.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';

class VidaADoidApp extends StatelessWidget {
  const VidaADoidApp({super.key});

  @override
  Widget build(BuildContext context) {
    Log.initializing('$MultiBlocProvider');

    return MultiBlocProvider(
      providers: [
        BlocProvider<BoardBloc>(create: (context) => BoardBloc()),
        BlocProvider<TaskBloc>(create: (context) => TaskBloc()),
        BlocProvider<ConnectivityBloc>(
          create: (context) =>
              ConnectivityBloc()..add(CheckConnectivityEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: Routes.homePage,
        routes: Routes.routes,
      ),
    );
  }
}
