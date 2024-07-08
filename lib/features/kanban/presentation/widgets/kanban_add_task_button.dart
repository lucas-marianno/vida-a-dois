import 'package:flutter/material.dart';

class KanbanAddTaskButton extends StatelessWidget {
  final String columnId;
  const KanbanAddTaskButton({
    required this.columnId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Add Task'),
          onTap: () {
            //TODO: add new task
            print('new task added to $columnId');
          },
        ),
      ),
    );
  }
}
