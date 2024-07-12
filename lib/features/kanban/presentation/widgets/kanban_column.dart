import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/kanban_column_title.dart';
import 'column_drag_target.dart';
import 'kanban_add_task_button.dart';

class KanbanColumn extends StatelessWidget {
  final String columnId;
  final List<Task> taskList;
  const KanbanColumn({
    required this.columnId,
    required this.taskList,
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
        color: Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          KanbanColumnTitle(columnId: columnId),
          KanbanColumnDragTarget(
            columnId: columnId,
            taskList: taskList,
            width: width,
          ),
          KanbanAddTaskButton(columnId: columnId),
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
