import 'dart:math';
import 'package:flutter/material.dart';

import '../../presentation/widgets/kanban_tile.dart';
import '../../domain/entities/task_entity.dart';

class KanbanColumn extends StatelessWidget {
  final String columnName;
  final List<Task> taskList;
  const KanbanColumn({
    required this.columnName,
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
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Center(child: Text(columnName)),
          Expanded(
            child: DragTarget(
              onAcceptWithDetails: (data) {
                if (data.data is Task) {
                  //TODO: remove this function from here

                  taskList.add(data.data as Task);
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
          ),
        ],
      ),
    );
  }
}
