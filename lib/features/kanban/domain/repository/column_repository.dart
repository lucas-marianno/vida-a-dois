import 'package:flutter/material.dart';
import 'package:kanban/core/util/dialogs/alert_dialog.dart';
import 'package:kanban/features/kanban/data/remote/column_data_source.dart';
import 'package:kanban/features/kanban/data/remote/task_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/column_form.dart';

//CRUD
class ColumnRepository {
  final BuildContext context;

  ColumnRepository(this.context);

  Future<void> createColumn() async {
    final newColumn = await ColumnForm.newColumn(context);

    if (newColumn == null || newColumn.title.isEmpty) return;

    // update columns list
    await ColumnDataSource.createColumn(newColumn);
  }

  Future<void> updateColumn(ColumnEntity column) async {
    final newColumn = await ColumnForm.readColumn(column, context);

    if (newColumn == null || newColumn.equals(column)) return;

    await ColumnDataSource.updateColumn(column, newColumn);
  }

  Future<void> deleteColumn(ColumnEntity column) async {
    final response = await Dialogs(context).alertDialog(
      title: 'Excluir coluna?',
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

    await Future.wait([
      ColumnDataSource.deleteColumn(column),
      TaskDataSource.deleteAllTasksWithStatus(column.title),
    ]);
  }
}
