import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/bloc/column/column_bloc.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';
import '../widgets/kanban/kanban_column.dart';

class KanbanPage extends StatefulWidget {
  const KanbanPage({super.key});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  ScrollController scrlCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    final columnsBloc = context.read<ColumnsBloc>();
    final taskBloc = context.read<TaskBloc>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        title: Text(
          'Kanban app concept'.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<ColumnsBloc, ColumnsState>(
          builder: (context, state) {
            if (state is ColumnLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ColumnLoadedState) {
              final columns = state.columns;

              taskBloc.add(LoadTasksEvent(columns));

              return ListView.builder(
                controller: scrlCtrl,
                scrollDirection: Axis.horizontal,
                itemCount: columns.length + 1,
                itemBuilder: (context, index) {
                  if (index < columns.length) {
                    return KanbanColumn(
                      column: state.columns[index],
                      horizontalParentScrollController: scrlCtrl,
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          child: const Icon(Icons.add),
                          onPressed: () => columnsBloc.add(CreateColumnEvent()),
                        ),
                      ),
                    );
                  }
                },
              );
            } else if (state is ColumnErrorState) {
              return Center(
                child: Text(state.error),
              );
            } else {
              throw UnimplementedError(
                  '$state implementation wasn\'t found in $ColumnsState!');
            }
          },
        ),
      ),
    );
  }
}
