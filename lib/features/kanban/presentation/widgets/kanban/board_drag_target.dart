import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'kanban_tile.dart';

class KanbanBoardDragTarget extends StatelessWidget {
  final Board board;
  final double width;
  final ScrollController horizontalController;
  final Map<String, List<Task>> mappedTasks;

  const KanbanBoardDragTarget({
    required this.board,
    required this.width,
    required this.mappedTasks,
    required this.horizontalController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Task> taskList = mappedTasks[board.title] ?? [];
    ScrollController verticalController = ScrollController();
    return Expanded(
      child: DragTarget(
        onAcceptWithDetails: (data) {
          if (data.data is Task) {
            context.read<TaskBloc>().add(
                  UpdateTaskStatusEvent(data.data as Task, board.title),
                );
          }
        },
        builder: (context, _, __) {
          if (taskList.isEmpty) {
            return Center(child: Text(L10n.of(context).noTasksHere));
          }
          return ListView.builder(
            controller: verticalController,
            shrinkWrap: true,
            itemCount: taskList.length,
            itemBuilder: (context, i) => KanbanTile(
              task: taskList[i],
              horizontalScrollController: horizontalController,
              tileWidth: width,
            ),
          );
        },
      ),
    );
  }
}
