import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/data/remote/firestore_service.dart';
import 'package:kanban/features/kanban/presentation/widgets/create_task_form.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/repository/task_repository.dart';

class KanbanTile extends StatelessWidget {
  final Task task;
  final double tileHeight;
  final double tileWidth;
  const KanbanTile({
    required this.task,
    required this.tileHeight,
    required this.tileWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget tile = _createTile(context);

    return LongPressDraggable(
      data: task,
      onDragEnd: (details) {
        if (details.wasAccepted) {
          removeTaskFromColumn(task);
        }
      },
      feedback: tile,
      childWhenDragging: Text(
        task.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      child: tile,
    );
  }

  Widget _createTile(BuildContext context) => Material(
        color: Colors.transparent,
        child: Container(
          height: tileHeight,
          width: tileWidth,
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blueGrey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // tarefa proposta
              ListTile(
                title: Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  onPressed: () async {
                    // TODO: display task options (edit | delete)
                    final response =
                        await TaskFromModalBottomForm.editTask(task, context);
                    if (response != null) {
                      // Call firestore to edit
                      FirestoreService.editTask(response);
                    }
                  },
                  icon: const Icon(Icons.more_horiz),
                ),
              ),
              // Permitir que o usuário escolha um icone de uma lista
              const Row(
                children: [
                  Icon(Icons.tapas_outlined),
                  // Exibir a foto da pessoa que foi atribuida a tarefa
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  // Permitir atribuir um nível de importancia para a tarefa
                  Icon(Icons.label_important),
                ],
              ),
            ],
          ),
        ),
      );
}
