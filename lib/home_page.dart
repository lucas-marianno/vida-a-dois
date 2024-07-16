import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/bloc/column/column_bloc.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';

import 'features/kanban/presentation/pages/kanban_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ColumnsBloc>(
          create: (context) => ColumnsBloc()..add(LoadColumnEvent()),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc()..add(TaskInitialEvent()),
        ),
      ],
      child: const KanbanPage(),
    );
  }
}
