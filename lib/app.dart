import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/constants/routes.dart';
import 'package:kanban/core/theme/app_theme.dart';
import 'package:kanban/features/kanban/bloc/column/column_bloc.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';

class VidaADoidApp extends StatelessWidget {
  const VidaADoidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ColumnsBloc>(
          create: (context) => ColumnsBloc(),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(),
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
