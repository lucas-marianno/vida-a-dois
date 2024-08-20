import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vida_a_dois/core/util/dialogs/error_dialog.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/task/task_bloc.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/board_entity.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/board_drag_target.dart';
import 'package:vida_a_dois/features/kanban/presentation/widgets/kanban/kanban_board_title.dart';
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
    bool isShittyDevice = MediaQuery.of(context).size.height < 1000;

    double widthMultiplier = isShittyDevice ? 0.8 : 0.6;
    double width = MediaQuery.of(context).size.width * widthMultiplier;

    final taskBloc = context.read<TaskBloc>();

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
                return const Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(),
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
                      onAccept: () => taskBloc.add(ReloadTasks()),
                    ),
                  ),
                );
              }
            },
          ),
          // TODO: show a hovering 'arrow down' to indicate that there are hidden items
          // bellow '+ new task' button.
          // Possibly, only show '+ new task' when the last item is being shown
          KanbanAddTaskButton(
            () => taskBloc.add(CreateTaskEvent(context, board.title)),
          ),
        ],
      ),
    );
  }
}
