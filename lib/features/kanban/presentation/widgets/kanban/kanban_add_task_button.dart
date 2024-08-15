import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/features/kanban/presentation/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/task_form.dart';

class KanbanAddTaskButton extends StatelessWidget {
  final BoardEntity currentBoard;
  const KanbanAddTaskButton(this.currentBoard, {super.key});

  // TODO: This function should be removed from here, ui should not have to worry about error handling
  void addTask(BuildContext context) async {
    TaskBloc taskBloc = context.read<TaskBloc>();

    final newTask = await TaskForm.readTask(
      TaskEntity(title: L10n.of(context).newTask, status: currentBoard.title),
      context,
      initAsReadOnly: false,
    );

    if (newTask == null) return;

    taskBloc.add(CreateTaskEvent(newTask));
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
