import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';

class KanbanColumnTitle extends StatelessWidget {
  final ColumnEntity column;

  const KanbanColumnTitle({
    super.key,
    required this.column,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 30),
          Text(
            column.title.toUpperCase(),
            style: const TextStyle(
              // color: Colors.white,
              // fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              //TODO: create sortby functionallity
            },
          )
        ],
      ),
    );
  }
}
