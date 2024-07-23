import 'package:flutter/material.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/util/dialogs/alert_dialog.dart';
import 'package:kanban/features/kanban/data/remote/board_data_source.dart';
import 'package:kanban/features/kanban/data/remote/task_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/board_form.dart';

//CRUD
class BoardRepository {
  final BuildContext context;

  BoardRepository(this.context);

  Future<void> createBoard() async {
    final newBoard = await BoardForm.readBoard(
      BoardEntity(title: L10n.of(context).newBoard, index: 500),
      context,
      initAsReadOnly: false,
    );

    if (newBoard == null || newBoard.title.isEmpty) return;

    await BoardDataSource.createBoard(newBoard);
  }

  Future<void> updateBoard(BoardEntity board) async {
    final newBoard = await BoardForm.readBoard(board, context);

    if (newBoard == null || newBoard.equals(board)) return;

    await BoardDataSource.updateBoard(board, newBoard);
  }

  Future<void> deleteBoard(BoardEntity board) async {
    final l10n = L10n.of(context);

    final response = await Dialogs(context).alertDialog(
      title: '${l10n.delete} ${l10n.board.toLowerCase()}?',
      content: l10n.deleteBoardPromptDescription(board.title),
      cancelButtonLabel: l10n.cancel,
      confirmButtonLabel: '${l10n.delete} ${l10n.board.toLowerCase()}',
    );

    if (response != true) return;

    await Future.wait([
      BoardDataSource.deleteBoard(board),
      TaskDataSource.deleteAllTasksWithStatus(board.title),
    ]);
  }
}
