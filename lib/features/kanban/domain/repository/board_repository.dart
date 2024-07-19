import 'package:flutter/material.dart';
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
      BoardEntity(title: 'Novo quadro', index: 500),
      context,
      initAsReadOnly: false,
    );

    if (newBoard == null || newBoard.title.isEmpty) return;

    // update boards list
    await BoardDataSource.createBoard(newBoard);
  }

  Future<void> updateBoard(BoardEntity board) async {
    final newBoard = await BoardForm.readBoard(board, context);

    if (newBoard == null || newBoard.equals(board)) return;

    await BoardDataSource.updateBoard(board, newBoard);
  }

  Future<void> deleteBoard(BoardEntity board) async {
    final response = await Dialogs(context).alertDialog(
      title: 'Excluir quadro?',
      content: 'Tem certeza que deseja exluir o quadro "${board.title}"?'
          '\n'
          '\n'
          'Todas as tarefas marcadas com status "${board.title}" também serão excluídas.'
          '\n'
          '\n'
          'Atenção! Após a exclusão, não será possível a recuperação do quadro e de nenhuma tarefa!',
      cancelButtonLabel: 'Cancelar',
      confirmButtonLabel: 'Excluir quadro',
    );

    if (response != true) return;

    await Future.wait([
      BoardDataSource.deleteBoard(board),
      TaskDataSource.deleteAllTasksWithStatus(board.title),
    ]);
  }
}
