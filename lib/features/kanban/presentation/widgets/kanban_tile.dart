import 'package:flutter/material.dart';
import 'package:kanban/core/constants/enum/task_assignee.dart';
import 'package:kanban/core/constants/enum/task_importance.dart';
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
      feedback: tile,
      childWhenDragging: Text(
        task.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      child: tile,
    );
  }

  Widget _createTile(BuildContext context) {
    TaskRepository taskRepo = TaskRepository(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: tileWidth,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.blueGrey[300],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // tarefa proposta
            ListTile(
              title: Text(
                task.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // show edit / delete task
              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: const Text('Edit'),
                      onTap: () => taskRepo.editTask(task),
                    ),
                    PopupMenuItem(
                      child: const Text('Delete'),
                      onTap: () => taskRepo.deleteTask(task),
                    ),
                  ];
                },
              ),
            ),
            ListTile(
              // Exibir a foto da pessoa que foi atribuida a tarefa
              leading: Text(
                DateTimeUtil.dateTimeToStringShort(task.dueDate?.toDate()),
              ),
              // Permitir atribuir um nível de importancia para a tarefa
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    icon: Icon(task.taskImportance.icon),
                    tooltip: task.taskImportance.name,
                    itemBuilder: (context) {
                      return [
                        for (TaskImportance importance in TaskImportance.values)
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(importance.icon),
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
