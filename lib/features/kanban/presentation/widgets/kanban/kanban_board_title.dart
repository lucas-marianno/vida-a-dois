import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/features/kanban/bloc/board/board_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';

class KanbanBoardTitle extends StatefulWidget {
  final BoardEntity board;

  const KanbanBoardTitle({
    super.key,
    required this.board,
  });

  @override
  State<KanbanBoardTitle> createState() => _KanbanBoardTitleState();
}

class _KanbanBoardTitleState extends State<KanbanBoardTitle> {
  late final BoardBloc boardBloc;
  TextEditingController controller = TextEditingController();
  bool editMode = false;

  void toggleEditMode() => setState(() => editMode = !editMode);

  void renameBoard() {
    final newTitle = controller.text;

    boardBloc.add(RenameBoardEvent(widget.board, newTitle));

    toggleEditMode();
    controller.clear();
  }

  void deleteBoard() {
    boardBloc.add(DeleteBoardEvent(widget.board));
  }

  void editBoard() {
    boardBloc.add(EditBoardEvent(widget.board));
  }

  @override
  void initState() {
    super.initState();
    boardBloc = context.read<BoardBloc>();
  }

  @override
  Widget build(BuildContext context) {
    if (editMode) {
      controller.text = widget.board.title;
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
          onSubmitted: (_) => renameBoard(),
        ),
        trailing: IconButton(
          onPressed: renameBoard,
          icon: const Icon(Icons.check),
        ),
      );
    }

    return ListTile(
      leading: const SizedBox(width: 0),
      titleAlignment: ListTileTitleAlignment.center,
      title: Text(
        widget.board.title,
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
      trailing: PopupMenuButton(
        tooltip: 'Opções',
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              onTap: deleteBoard,
              child: const Text('Excluir'),
            ),
            PopupMenuItem(
              onTap: editBoard,
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
