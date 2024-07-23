import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

class KanbanAddTaskButton extends StatelessWidget {
  final BoardEntity currentBoard;
  const KanbanAddTaskButton(this.currentBoard, {super.key});

  void addTask(BuildContext context) {
    context.read<TaskBloc>().add(CreateTaskEvent(
          Task(
            title: L10n.of(context).newTask,
            status: currentBoard.title,
          ),
        ));
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
          title: Text(L10n.of(context).newTask),
          onTap: () => addTask(context),
        ),
      ),
    );
  }
}
