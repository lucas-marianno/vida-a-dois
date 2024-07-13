import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kanban/core/constants/enum/task_status.dart';

import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';

import 'kanban_tile.dart';

class KanbanColumnDragTarget extends StatelessWidget {
  final TaskStatus columnId;
  final double width;
  final List<Task> taskList;
  final ScrollController horizontalParentScrollController;

  const KanbanColumnDragTarget({
    required this.columnId,
    required this.width,
    required this.taskList,
    required this.horizontalParentScrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ScrollController verticalController = ScrollController();
    return Expanded(
      child: DragTarget(
        onAcceptWithDetails: (data) {
          if (data.data is Task) {
            TaskRepository(context)
                .updateTaskStatus(data.data as Task, columnId);
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
