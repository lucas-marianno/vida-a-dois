import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/util/dialogs/error_dialog.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/kanban/board_drag_target.dart';
import 'package:kanban/features/kanban/presentation/widgets/kanban/kanban_board_title.dart';
import 'kanban_add_task_button.dart';

class KanbanBoard extends StatelessWidget {
  final Board board;
  final ScrollController horizontalController;
  const KanbanBoard({
    required this.board,
    required this.horizontalController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double widthMultiplier = 0.6;
    double width = MediaQuery.of(context).size.width * widthMultiplier;

    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.shadow,
        ),
      ),
      child: Column(
        children: [
          KanbanBoardTitle(board: board),
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TasksLoadingState) {
                return Expanded(
                  child: Container(
                    width: width,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.all(5),
                    child: LinearProgressIndicator(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                    ),
                  ),
                );
              } else if (state is TasksLoadedState) {
                return KanbanBoardDragTarget(
                  board: board,
                  width: width,
                  mappedTasks: state.mappedTasks,
                  horizontalController: horizontalController,
                );
              } else {
                return Expanded(
                  child: Center(
                    child: ErrorDialog(
                      UnimplementedError('\n\n$state\n'),
                      onAccept: () {
                        context.read<TaskBloc>().add(ReloadTasks());
                      },
                    ),
                  ),
                );
              }
            },
          ),
          KanbanAddTaskButton(board),
        ],
      ),
    );
  }
}
