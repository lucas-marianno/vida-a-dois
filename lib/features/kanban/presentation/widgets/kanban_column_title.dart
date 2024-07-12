import 'package:flutter/material.dart';
import 'package:kanban/core/constants/enum/task_status.dart';

class KanbanColumnTitle extends StatelessWidget {
  const KanbanColumnTitle({
    super.key,
    required this.columnId,
  });

  final TaskStatus columnId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: columnId.color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 30),
          Text(
            columnId.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.sort,
              color: Colors.white,
            ),
            onPressed: () {
              //TODO: create sortby functionallity
            },
          )
        ],
      ),
    );
  }
}
