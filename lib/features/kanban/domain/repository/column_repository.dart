import 'package:flutter/material.dart';
import 'package:kanban/core/util/dialogs/alert_dialog.dart';
import 'package:kanban/features/kanban/data/remote/column_data_source.dart';
import 'package:kanban/features/kanban/data/remote/task_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';

//CRUD
class ColumnRepository {
  final BuildContext context;

  ColumnRepository(this.context);

  Future<void> createColumn() async {
    ColumnEntity mockColumn = ColumnEntity(title: 'test7', index: 2);
    // TODO: get name from user

    // update columns list
    await ColumnDataSource.createColumn(mockColumn);
  }

  Future<void> renameColumn(ColumnEntity column) async {
    // TODO: get name from user

    // TODO: update columns list
  }

  void updateColumn() {}

  Future<void> deleteColumn(ColumnEntity column) async {
    final response = await Dialogs(context).alertDialog(
      title: 'Excluir tarefa?',
      content: 'Tem certeza que deseja exluir a coluna "${column.title}"?'
          '\n'
          '\n'
          'Todas as tarefas marcadas com status "${column.title}" também serão excluídas.'
          '\n'
          '\n'
          'Atenção! Após a exclusão, não será possível a recuperação da coluna e de nenhuma tarefa!',
      cancelButtonLabel: 'Cancelar',
      confirmButtonLabel: 'Excluir coluna',
    );

    if (response != true) return;

    await TaskDataSource.deleteAllTasksWithStatus(column.title);

    await ColumnDataSource.deleteColumn(column);
  }
}
