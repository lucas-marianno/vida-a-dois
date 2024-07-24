import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/util/dialogs/alert_dialog.dart';
import 'package:kanban/features/kanban/bloc/board/board_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/board_form.dart';

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

  void deleteBoard() async {
    final l10n = L10n.of(context);
    final response = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        context: context,
        title: '${l10n.delete} ${l10n.board.toLowerCase()}?',
        content: l10n.deleteBoardPromptDescription(widget.board.title),
        onAccept: () => Navigator.pop(context, true),
        onCancel: () => Navigator.pop(context),
      ),
    );

    if (response != true) return;

    boardBloc.add(DeleteBoardEvent(widget.board));
  }

  void editBoard() async {
    final newBoard = await BoardForm.readBoard(widget.board, context);

    if (newBoard == null || newBoard.equalsTo(widget.board)) return;

    boardBloc.add(EditBoardEvent(widget.board, newBoard));
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

    final l10n = L10n.of(context);

    return ListTile(
      leading: const SizedBox(width: 0),
      titleAlignment: ListTileTitleAlignment.center,
      title: Text(
        widget.board.title,
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
      trailing: PopupMenuButton(
        tooltip: l10n.options,
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              onTap: deleteBoard,
              child: Text(l10n.delete),
            ),
            PopupMenuItem(
              onTap: editBoard,
              child: Text(l10n.edit),
            ),
            PopupMenuItem(
              onTap: toggleEditMode,
              child: Text(l10n.rename),
            ),
          ];
        },
      ),
    );
  }
}
