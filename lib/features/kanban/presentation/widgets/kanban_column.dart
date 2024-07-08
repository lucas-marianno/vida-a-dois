import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/presentation/widgets/kanban_column_title.dart';
import 'kanban_add_task_button.dart';
import 'kanban_column_streambuilder.dart';

class KanbanColumn extends StatelessWidget {
  final String columnId;
  const KanbanColumn({
    required this.columnId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          KanbanColumnTitle(columnId: columnId),
          KanbanColumnStreamBuilder(columnId: columnId, width: width),
          KanbanAddTaskButton(columnId: columnId),
        ],
      ),
    );
  }
}
