import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'kanban_tile.dart';

class KanbanBoardDragTarget extends StatelessWidget {
  final BoardEntity board;
  final double width;
  final Map<String, List<Task>> mappedTasks;
  final ScrollController horizontalParentScrollController;

  const KanbanBoardDragTarget({
    required this.board,
    required this.width,
    required this.mappedTasks,
    required this.horizontalParentScrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final taskBloc = context.read<TaskBloc>();
    List<Task> taskList = mappedTasks[board.title] ?? [];
    ScrollController verticalController = ScrollController();
    return Expanded(
      child: DragTarget(
        onAcceptWithDetails: (data) {
          if (data.data is Task) {
            taskBloc.add(UpdateTaskStatusEvent(data.data as Task, board.title));
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
