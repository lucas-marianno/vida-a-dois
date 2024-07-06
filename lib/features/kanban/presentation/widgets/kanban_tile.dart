import 'package:flutter/material.dart';

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
    Widget tile = createTile(task.title);
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

  Widget createTile(String tarefa) => Material(
        color: Colors.transparent,
        child: Container(
          height: tileHeight,
          width: tileWidth,
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.blueGrey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // tarefa proposta
              Text(
                tarefa,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const ListTile(
                // Permitir que o usuário escolha um icone de uma lista
                leading: Icon(Icons.tapas_outlined),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Exibir a foto da pessoa que foi atribuida a tarefa
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    // Permitir atribuir um nível de importancia para a tarefa
                    Icon(Icons.label_important),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
