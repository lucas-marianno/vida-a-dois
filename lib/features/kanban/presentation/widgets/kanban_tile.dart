import 'package:flutter/material.dart';
import 'package:kanban/core/constants/enum/task_assignee.dart';
import 'package:kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/core/util/color_util.dart';
import 'package:kanban/core/util/datetime_util.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';
import '../../domain/entities/task_entity.dart';

class KanbanTile extends StatelessWidget {
  final Task task;
  final double tileHeight;
  final double tileWidth;
  const KanbanTile({
    required this.task,
    required this.tileHeight,
    required this.tileWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget tile = _createTile(context);

    return LongPressDraggable(
      data: task,
      feedback: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        elevation: 6,
        shadowColor: Theme.of(context).colorScheme.shadow,
        child: tile,
      ),
      childWhenDragging: Container(
        foregroundDecoration: BoxDecoration(
          color: ColorUtil.makeTransparencyFrom(
            Theme.of(context).colorScheme.surface,
          ),
        ),
        child: tile,
      ),
      child: tile,
    );
  }

  Widget _createTile(BuildContext context) {
    TaskRepository taskRepo = TaskRepository(context);

    return Container(
      width: tileWidth,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.shadow),
      ),
      child: GestureDetector(
        onTap: () => taskRepo.readTask(task),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // tarefa proposta
            ListTile(
              title: Text(
                task.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              subtitle: task.description == null
                  ? null
                  : Text(
                      task.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 16),

              leading: task.dueDate == null
                  ? null
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          DateTimeUtil.dateTimeToStringShort(
                            task.dueDate!.toDate(),
                          ).toUpperCase(),
                        ),
                      ],
                    ),
              // Permitir atribuir um nível de importancia para a tarefa
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Exibir a foto da pessoa que foi atribuida a tarefa
                  PopupMenuButton(
                    icon: Icon(task.assingnee.icon),
                    tooltip: task.assingnee.name,
                    itemBuilder: (context) {
                      return [
                        for (TaskAssignee assignee in TaskAssignee.values)
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(assignee.icon),
                                const SizedBox(width: 10),
                                Text(assignee.name),
                              ],
                            ),
                            onTap: () => taskRepo.updateTaskAssignee(
                              task,
                              assignee,
                            ),
                          ),
                      ];
                    },
                  ),
                  PopupMenuButton(
                    icon: Icon(
                      task.taskImportance.icon,
                      color: task.taskImportance.color,
                    ),
                    tooltip: task.taskImportance.name,
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
                            onTap: () => taskRepo.updateTaskImportance(
                              task,
                              importance,
                            ),
                          ),
                      ];
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
