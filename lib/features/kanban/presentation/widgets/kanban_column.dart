import 'package:flutter/material.dart';
import 'package:kanban/core/constants/enum/task_status.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/kanban_column_title.dart';
import 'column_drag_target.dart';
import 'kanban_add_task_button.dart';

class KanbanColumn extends StatelessWidget {
  final TaskStatus columnId;
  final List<Task> taskList;
  final ScrollController horizontalParentScrollController;
  const KanbanColumn({
    required this.columnId,
    required this.taskList,
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
          KanbanColumnTitle(columnId: columnId),
          KanbanColumnDragTarget(
            columnId: columnId,
            taskList: taskList,
            width: width,
            horizontalParentScrollController: horizontalParentScrollController,
          ),
          const KanbanAddTaskButton(),
        ],
      ),
    );
  }

  static Widget loading(BuildContext context) {
    double widthMultiplier = 0.6;
    double width = MediaQuery.of(context).size.width * widthMultiplier;

    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [LinearProgressIndicator()],
      ),
    );
  }
}
