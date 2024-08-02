import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/util/dialogs/info_dialog.dart';
import 'package:kanban/features/kanban/presentation/bloc/board/board_bloc.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/board_form.dart';

class KanbanBoardTitle extends StatefulWidget {
  final Board board;

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

    final response = await InfoDialog.show(
      context,
      l10n.deleteBoardPromptDescription(widget.board.title),
      title: '${l10n.delete} ${l10n.board.toLowerCase()}?',
      showCancel: true,
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
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 0,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: toggleEditMode,
          icon: const Icon(Icons.close),
        ),
        title: TextField(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          controller: controller,
          style: Theme.of(context).textTheme.titleMedium,
          autofocus: true,
          onSubmitted: (_) => renameBoard(),
          onTapOutside: (_) => toggleEditMode(),
        ),
        trailing: IconButton(
          padding: EdgeInsets.zero,
          onPressed: renameBoard,
          icon: const Icon(Icons.check),
        ),
      );
    }

    final l10n = L10n.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      leading: const SizedBox(width: 0),
      titleAlignment: ListTileTitleAlignment.center,
      title: Text(
        widget.board.title,
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
      trailing: PopupMenuButton(
        padding: EdgeInsets.zero,
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
