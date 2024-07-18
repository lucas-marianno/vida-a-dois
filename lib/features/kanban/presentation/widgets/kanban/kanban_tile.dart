import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_assignee.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/core/util/color_util.dart';
import 'package:kanban/core/util/datetime_util.dart';
import '../../../domain/entities/task_entity.dart';

class KanbanTile extends StatefulWidget {
  final Task task;
  final double tileHeight;
  final double tileWidth;
  final ScrollController horizontalParentScrollController;
  final ScrollController verticalParentScrollController;
  const KanbanTile({
    required this.task,
    required this.tileHeight,
    required this.tileWidth,
    required this.horizontalParentScrollController,
    required this.verticalParentScrollController,
    super.key,
  });

  @override
  State<KanbanTile> createState() => _KanbanTileState();
}

class _KanbanTileState extends State<KanbanTile> {
  late Widget tile;
  late Timer? timer;
  late ScrollController verticalCtrl;
  late ScrollController horizontalCtrl;
  late double maxRight;
  late double maxLeft;
  Duration interval = const Duration(milliseconds: 100);
  double sentitiveArea = 10;

  /// [direction] == true: right
  ///
  /// [direction] == false: left
  Future<void> startScrollingPage(bool direction) async {
    horizontalCtrl.animateTo(
      direction ? maxRight : maxLeft,
      duration: interval,
      curve: Curves.linear,
    );
  }

  @override
  void initState() {
    verticalCtrl = widget.verticalParentScrollController;
    horizontalCtrl = widget.horizontalParentScrollController;
    maxRight = horizontalCtrl.position.maxScrollExtent;
    maxLeft = horizontalCtrl.position.minScrollExtent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tile = _createTile(context);

    return LongPressDraggable(
      onDragUpdate: (details) async {
        // TODO: this is horrible, refactor this.

        // final pos = details.globalPosition.dx;
        // if (pos < maxLeft + sentitiveArea) {
        //   await startScrollingPage(false);
        // } else if (pos > maxRight - sentitiveArea) {
        //   await startScrollingPage(true);
        // }
      },
      data: widget.task,
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
    final taskBloc = context.read<TaskBloc>();

    return Container(
      width: widget.tileWidth,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.shadow),
      ),
      child: GestureDetector(
        onTap: () => taskBloc.add(ReadTaskEvent(widget.task)),
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
                            onTap: () => taskBloc.add(UpdateTaskImportanceEvent(
                              widget.task,
                              importance,
                            )),
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
                            onTap: () => taskBloc.add(UpdateTaskAssigneeEvent(
                              widget.task,
                              assignee,
                            )),
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
