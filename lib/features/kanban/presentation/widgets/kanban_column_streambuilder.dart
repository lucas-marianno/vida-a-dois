import 'dart:math';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kanban/core/constants/enum/task_status.dart';
import 'package:kanban/features/kanban/data/remote/firestore_service.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

import 'kanban_tile.dart';

class KanbanColumnStreamBuilder extends StatelessWidget {
  const KanbanColumnStreamBuilder({
    super.key,
    required this.columnId,
    required this.width,
  });

  final String columnId;
  final double width;

  @override
  Widget build(BuildContext context) {
    final Stream contentStream =
        FirestoreService.getMockColumnContent(columnId);

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
          return StreamBuilder(
            stream: contentStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot> content = snapshot.data.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: max(content.length, 1),
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  itemBuilder: (context, index) {
                    if (content.isEmpty) {
                      return const Center(child: Text('No tasks here!'));
                    }

                    String taskTitle = content[index]['title'];
                    TaskStatus status = TaskStatus.fromString(columnId);
                    final task = Task(title: taskTitle, status: status);

                    return KanbanTile(
                      task: task,
                      tileHeight: width / 3,
                      tileWidth: width,
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }
}
