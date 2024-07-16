import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'kanban_tile.dart';

class KanbanColumnDragTarget extends StatelessWidget {
  final ColumnEntity column;
  final double width;
  final Map<String, List<Task>> mappedTasks;
  final ScrollController horizontalParentScrollController;

  const KanbanColumnDragTarget({
    required this.column,
    required this.width,
    required this.mappedTasks,
    required this.horizontalParentScrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Task> taskList = mappedTasks[column.title]!;
    ScrollController verticalController = ScrollController();
    return Expanded(
      child: DragTarget(
        onAcceptWithDetails: (data) {
          if (data.data is Task) {
            // TODO: refactor this
            // TaskRepository(context)
            //     .updateTaskStatus(data.data as Task, columnId);
          }
        },
        builder: (context, candidateData, rejectedData) {
          return ListView.builder(
            controller: verticalController,
            shrinkWrap: true,
            itemCount: max(taskList.length, 1),
            itemBuilder: (context, index) {
              if (taskList.isEmpty) {
                return const Center(child: Text('No tasks here!'));
              }

              return KanbanTile(
                task: taskList[index],
                tileHeight: width / 3,
                tileWidth: width,
                horizontalParentScrollController:
                    horizontalParentScrollController,
                verticalParentScrollController: verticalController,
              );
            },
          );
        },
      ),
    );
  }
}
