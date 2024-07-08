import 'package:flutter/material.dart';

class KanbanColumnTitle extends StatelessWidget {
  const KanbanColumnTitle({
    super.key,
    required this.columnId,
  });

  final String columnId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 30),
        Text(columnId),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.sort),
          onPressed: () {
            //TODO: create sortby functionallity
          },
        )
      ],
    );
  }
}
