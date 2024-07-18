import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/bloc/column/column_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';

class KanbanColumnTitle extends StatefulWidget {
  final ColumnEntity column;

  const KanbanColumnTitle({
    super.key,
    required this.column,
  });

  @override
  State<KanbanColumnTitle> createState() => _KanbanColumnTitleState();
}

class _KanbanColumnTitleState extends State<KanbanColumnTitle> {
  late final ColumnsBloc columnBloc;
  TextEditingController controller = TextEditingController();
  bool editMode = false;

  void toggleEditMode() => setState(() => editMode = !editMode);

  void renameColumn() {
    final newTitle = controller.text;

    columnBloc.add(RenameColumnEvent(widget.column, newTitle));

    toggleEditMode();
    controller.clear();
  }

  void deleteColumn() {
    columnBloc.add(DeleteColumnEvent(widget.column));
  }

  void editColumn() {
    columnBloc.add(EditColumnEvent(widget.column));
  }

  @override
  void initState() {
    super.initState();
    columnBloc = context.read<ColumnsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    if (editMode) {
      controller.text = widget.column.title;
      return ListTile(
        leading: IconButton(
          onPressed: toggleEditMode,
          icon: const Icon(Icons.close),
        ),
        title: TextField(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          controller: controller,
          style: Theme.of(context).textTheme.titleMedium,
          autofocus: true,
          onSubmitted: (_) => renameColumn(),
        ),
        trailing: IconButton(
          onPressed: renameColumn,
          icon: const Icon(Icons.check),
        ),
      );
    }

    return ListTile(
      leading: const SizedBox(width: 0),
      titleAlignment: ListTileTitleAlignment.center,
      title: Text(
        widget.column.title,
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
      trailing: PopupMenuButton(
        tooltip: 'Opções',
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              onTap: deleteColumn,
              child: const Text('Excluir'),
            ),
            PopupMenuItem(
              onTap: editColumn,
              child: const Text('Editar'),
            ),
            PopupMenuItem(
              onTap: toggleEditMode,
              child: const Text('Renomear'),
            ),
          ];
        },
      ),
    );
  }
}
