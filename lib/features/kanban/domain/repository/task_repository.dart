import 'package:flutter/material.dart';
import 'package:kanban/core/i18n/l10n.dart';
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
    final l10n = L10n.of(context);
    final response = await Dialogs(context).alertDialog(
      title: '${l10n.delete} ${l10n.task.toLowerCase()}?',
      content: l10n.deleteTaskPromptDescription(task.title),
      cancelButtonLabel: l10n.delete,
      confirmButtonLabel: '${l10n.delete} ${l10n.task.toLowerCase()}',
    );

    if (response != true) return;

    await TaskDataSource.deleteTask(task);
  }
}
