import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/presentation/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_assignee.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/core/util/color_util.dart';
import 'package:kanban/core/util/datetime_util.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/task_form.dart';
import '../../../domain/entities/task_entity.dart';

class KanbanTile extends StatefulWidget {
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
  State<KanbanTile> createState() => _KanbanTileState();
}

class _KanbanTileState extends State<KanbanTile> {
  late final TaskBloc taskBloc;
  bool isOnEdge = false;

  /// `[direction] ? scrollRight : scrollLeft`
  void startScrollingPage(bool direction) {
    const Duration interval = Duration(milliseconds: 100);
    const double speedMultiplier = 1.5;
    final ScrollController horzCtrl = widget.horizontalScrollController;

    double scrollAmount = 30 * (direction ? 1 : -1);

    Timer.periodic(interval, (timer) {
      if (!isOnEdge) timer.cancel();

      horzCtrl.animateTo(
        horzCtrl.offset + scrollAmount,
        duration: interval,
        curve: Curves.linear,
      );
      scrollAmount *= speedMultiplier;
    });
  }

  void checkEdgeAreaEnter(Offset draggableGlobalPosition) {
    final double edgeArea = MediaQuery.of(context).size.width * 0.1;
    final double pos = draggableGlobalPosition.dx;
    final double width = MediaQuery.of(context).size.width;

    final isOnLeftEdge = pos < 0 + edgeArea;
    final isOnRightEdge = pos > width - edgeArea;

    if (isOnLeftEdge) {
      if (!isOnEdge) {
        isOnEdge = true;
        startScrollingPage(false);
      }
    } else if (isOnRightEdge) {
      if (!isOnEdge) {
        isOnEdge = true;
        startScrollingPage(true);
      }
    } else {
      if (isOnEdge) {
        isOnEdge = false;
      }
    }
  }

  void readTask() async {
    final newTask = await TaskForm.readTask(widget.task, context);

    if (newTask == null || newTask.equalsTo(widget.task)) return;

    taskBloc.add(UpdateTaskEvent(newTask));
  }

  void updateTaskAssignee(TaskAssignee assignee) {
    taskBloc.add(UpdateTaskAssigneeEvent(widget.task, assignee));
  }

  void updateTaskImportance(TaskImportance importance) {
    taskBloc.add(UpdateTaskImportanceEvent(widget.task, importance));
  }

  @override
  void initState() {
    super.initState();
    taskBloc = context.read<TaskBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Widget tile = _createTile(context);
    return LongPressDraggable(
      onDragUpdate: (details) => checkEdgeAreaEnter(details.globalPosition),
      data: widget.task,
      feedback: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        elevation: 6,
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
    return Container(
      width: widget.tileWidth,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 16, right: 50),
                  title: Text(
                    widget.task.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: widget.task.description == null
                      ? null
                      : Text(
                          widget.task.description!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
                // Altera o nível de importância da tarefa
                Positioned(
                  top: 6,
                  right: 0,
                  child: PopupMenuButton(
                    icon: Icon(
                      widget.task.taskImportance.icon,
                      color: widget.task.taskImportance.color,
                    ),
                    tooltip: widget.task.taskImportance.name,
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
                ),
              ],
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 16),
              leading: widget.task.dueDate == null
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
                            widget.task.dueDate!.toDate(),
                          ).toUpperCase(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Exibir a foto da pessoa que foi atribuida a tarefa
                  PopupMenuButton(
                    icon: Icon(
                      widget.task.assingnee.icon,
                    ),
                    tooltip: widget.task.assingnee.name,
                    itemBuilder: (context) {
                      return [
                        for (TaskAssignee assignee in TaskAssignee.values)
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(
                                  assignee.icon,
                                ),
                                const SizedBox(width: 10),
                                Text(assignee.name),
                              ],
                            ),
                            onTap: () => updateTaskAssignee(assignee),
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
