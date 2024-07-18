import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_assignee.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';

import 'package:kanban/core/util/dialogs/alert_dialog.dart';
import 'package:kanban/features/kanban/data/remote/task_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/task_form.dart';

// CRUD
class TaskRepository {
  final BuildContext context;

  TaskRepository(this.context);

  Future<void> createTask(Task initialTask) async {
    final newTask = await TaskForm.readTask(
      initialTask,
      context,
      initAsReadOnly: false,
    );

    if (newTask == null) return;

    await TaskDataSource.createTask(newTask);
  }

  Future<void> readTask(Task task) async {
    final newTask = await TaskForm.readTask(task, context);

    if (newTask == null) return;

    await TaskDataSource.updateTask(newTask);
  }

  Future<void> updateTaskImportance(
    Task task,
    TaskImportance taskImportance,
  ) async {
    if (task.taskImportance == taskImportance) return;

    final newTask = task.copy()..taskImportance = taskImportance;

    await TaskDataSource.updateTask(newTask);
  }

  Future<void> updateTaskAssignee(Task task, TaskAssignee assignee) async {
    if (task.assingnee == assignee) return;

    final newTask = task.copy()..assingnee = assignee;

    await TaskDataSource.updateTask(newTask);
  }

  Future<void> updateTaskStatus(Task task, String newStatus) async {
    if (task.status == newStatus) return;

    await TaskDataSource.updateTask(task..status = newStatus);
  }

  Future<void> deleteTask(Task task) async {
    final response = await Dialogs(context).alertDialog(
      title: 'Excluir tarefa?',
      content: 'Tem certeza que deseja exluir a tarefa "${task.title}"?'
          '\n'
          '\n'
          'Atenção! Após excluída, não será possível a recuperação da tarefa!',
      cancelButtonLabel: 'Cancelar',
      confirmButtonLabel: 'Excluir Tarefa',
    );

    if (response != true) return;

    await TaskDataSource.deleteTask(task);
  }
}
