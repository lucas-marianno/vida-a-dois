import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/extensions/color_extension.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/src/presentation/widgets/user_initials.dart';

import 'package:kanban/core/extensions/datetime_extension.dart';
import 'package:kanban/src/domain/entities/task_entity.dart';
import 'package:kanban/src/presentation/bloc/task/task_bloc.dart';
import 'package:kanban/src/domain/constants/enum/task_importance.dart';
import 'package:kanban/src/presentation/extensions/task_importance_ui_extension.dart';
import 'package:kanban/src/presentation/util/draggable_scroll_controller.dart';

class KanbanTile extends StatelessWidget {
  final Task task;
  final double tileWidth;
  final ScrollController horizontalScrollController;

  const KanbanTile({
    required this.task,
    required this.tileWidth,
    required this.horizontalScrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DraggableScrollController controller = DraggableScrollController(
      context,
      horizontalScrollController: horizontalScrollController,
    );

    Widget taskTile = _TaskTile(task, tileWidth: tileWidth);

    Widget disabledTaskTile = _TaskTile(
      task,
      tileWidth: tileWidth,
      isDisabled: true,
    );

    return LongPressDraggable(
      onDragUpdate: controller.onDragUpdate,
      data: task,
      feedback: SizedBox(
        width: tileWidth,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          elevation: 6,
          child: taskTile,
        ),
      ),
      childWhenDragging: disabledTaskTile,
      child: taskTile,
    );
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;
  final double tileWidth;
  final bool isDisabled;

  const _TaskTile(this.task,
      {required this.tileWidth, this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    void readTask() async {
      context.read<TaskBloc>().add(ReadTask(task));
    }

    return Container(
      width: tileWidth,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      foregroundDecoration: !isDisabled
          ? null
          : BoxDecoration(
              color: Theme.of(context).colorScheme.surface.addTransparency(),
              borderRadius: BorderRadius.circular(10),
            ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.shadow),
      ),
      child: GestureDetector(
        onTap: readTask,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                // tarefa proposta
                _TaskTileTitleWithDescription(task: task),
                // Altera o nível de importância da tarefa
                _TaskTileImportance(task: task),
              ],
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 16),
              leading:
                  task.deadline == null ? null : _TaskTileDataStamp(task: task),
              trailing: _TaskTileAssignee(task: task),
            )
          ],
        ),
      ),
    );
  }
}

class _TaskTileAssignee extends StatelessWidget {
  const _TaskTileAssignee({required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    void updateTaskAssignee(String assigneeUID) {
      context.read<TaskBloc>().add(UpdateTaskAssigneeUID(task, assigneeUID));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Exibir a foto da pessoa que foi atribuida a tarefa
        PopupMenuButton(
          key: const Key('taskAssigneePopupButton'),
          icon: UserInitials(task.assingneeInitials ?? ''),
          itemBuilder: (context) {
            // TODO: implement assignee selector
            return [
              for (int i = 0; i < 3; i++)
                PopupMenuItem(
                  child: const Text('Uninplemented'),
                  onTap: () => updateTaskAssignee('Unimplemented'),
                ),
            ];
            // return [
            //   for (TaskAssignee assignee in TaskAssignee.values)
            //     PopupMenuItem(
            //       child: Row(
            //         children: [
            //           Icon(
            //             assignee.icon,
            //           ),
            //           const SizedBox(width: 10),
            //           Text(assignee.name),
            //         ],
            //       ),
            //       onTap: () => updateTaskAssignee(assignee),
            //     ),
            // ];
          },
        ),
      ],
    );
  }
}

class _TaskTileDataStamp extends StatelessWidget {
  const _TaskTileDataStamp({required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_month,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 10),
        Text(
          task.deadline?.toAbreviatedDate(L10n.of(context)).toUpperCase() ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _TaskTileImportance extends StatelessWidget {
  const _TaskTileImportance({required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    void updateTaskImportance(TaskImportance importance) {
      context.read<TaskBloc>().add(UpdateTaskImportance(task, importance));
    }

    return Positioned(
      top: 6,
      right: 0,
      child: PopupMenuButton(
        key: const Key('taskImportancePopupButton'),
        icon: Icon(
          task.importance.icon,
          color: task.importance.color,
        ),
        tooltip: task.importance.name,
        itemBuilder: (context) {
          return [
            for (TaskImportance importance in TaskImportance.values)
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      importance.icon,
                      color: importance.color,
                    ),
                    const SizedBox(width: 10),
                    Text(importance.name),
                  ],
                ),
                onTap: () => updateTaskImportance(importance),
              ),
          ];
        },
      ),
    );
  }
}

class _TaskTileTitleWithDescription extends StatelessWidget {
  const _TaskTileTitleWithDescription({required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16, right: 50),
      title: Text(
        task.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: task.description == null
          ? null
          : Text(
              task.description!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }
}
