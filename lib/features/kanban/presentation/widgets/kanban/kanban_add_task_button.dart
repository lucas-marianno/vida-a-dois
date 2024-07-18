import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';

class KanbanAddTaskButton extends StatelessWidget {
  final ColumnEntity currentColumn;
  const KanbanAddTaskButton(this.currentColumn, {super.key});

  void addTask(BuildContext context) {
    context.read<TaskBloc>().add(CreateTaskEvent(currentColumn));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Nova Tarefa'),
          onTap: () => addTask(context),
        ),
      ),
    );
  }
}
