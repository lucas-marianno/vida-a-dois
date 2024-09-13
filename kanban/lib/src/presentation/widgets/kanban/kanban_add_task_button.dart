import 'package:flutter/material.dart';
import 'package:kanban/core/i18n/l10n.dart';

class KanbanAddTaskButton extends StatelessWidget {
  final void Function() onTap;
  const KanbanAddTaskButton(this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: const Icon(Icons.add),
          title: Text(L10n.of(context).newTask),
          onTap: onTap,
        ),
      ),
    );
  }
}
