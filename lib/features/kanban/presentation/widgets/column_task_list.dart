import 'dart:math';
import 'package:flutter/material.dart';

import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

import 'kanban_tile.dart';

class KanbanTaskList extends StatelessWidget {
  final double width;
  final List<Task> taskList;

  const KanbanTaskList({
    required this.width,
    required this.taskList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DragTarget(
        onAcceptWithDetails: (data) {
          if (data.data is Task) {
            //TODO: remove this function from here

            //TODO: create function to add received task
            // taskList.add(data.data as Task);
          }
        },
        builder: (context, candidateData, rejectedData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: max(taskList.length, 1),
            padding: const EdgeInsets.symmetric(vertical: 1),
            itemBuilder: (context, index) {
              if (taskList.isEmpty) {
                return const Center(child: Text('No tasks here!'));
              }

              return KanbanTile(
                task: taskList[index],
                tileHeight: width / 3,
                tileWidth: width,
              );
            },
          );
        },
      ),
    );
  }
}
