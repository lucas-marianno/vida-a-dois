import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';

///TODO: refactor [KanbanAddTaskButton] to initialize task creation with current column status
class KanbanAddTaskButton extends StatelessWidget {
  const KanbanAddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    final taskBloc = context.read<TaskBloc>();

    return Center(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Add Task'),
          onTap: () => taskBloc.add(CreateTaskEvent()),
        ),
      ),
    );
  }
}
