import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/bloc/task/task_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/kanban/column_drag_target.dart';
import 'package:kanban/features/kanban/presentation/widgets/kanban/kanban_column_title.dart';
import 'kanban_add_task_button.dart';

class KanbanColumn extends StatelessWidget {
  final ColumnEntity column;
  final ScrollController horizontalParentScrollController;
  const KanbanColumn({
    required this.column,
    required this.horizontalParentScrollController,
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
          KanbanColumnTitle(column: column),
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TasksLoadingState) {
                return loading(context);
              } else if (state is TasksLoadedState) {
                return KanbanColumnDragTarget(
                  column: column,
                  width: width,
                  mappedTasks: state.mappedTasks,
                  horizontalParentScrollController:
                      horizontalParentScrollController,
                );
              } else if (state is TasksErrorState) {
                return Center(
                  child: Text(state.error),
                );
              } else {
                throw UnimplementedError();
              }
            },
          ),
          const KanbanAddTaskButton(),
        ],
      ),
    );
  }

  static Widget loading(BuildContext context, {String? label}) {
    double widthMultiplier = 0.6;
    double width = MediaQuery.of(context).size.width * widthMultiplier;

    return Expanded(
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (label != null) Text(label),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
