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

  void createTask() async {
    final newTask = await TaskForm.newTask(context);

    if (newTask != null) {
      TaskDataSource.createTask(newTask);
    }
  }

  void readTask(Task task) async {
    final newTask = await TaskForm.readTask(task, context);

    if (newTask == null) return;

    if (task.status != newTask.status) {
      TaskDataSource.deleteTask(task);
      TaskDataSource.createTask(newTask);
    } else {
      TaskDataSource.updateTask(newTask);
    }
  }

  void updateTaskImportance(Task task, TaskImportance taskImportance) {
    if (task.taskImportance == taskImportance) return;

    final newTask = task.copy()..taskImportance = taskImportance;

    TaskDataSource.updateTask(newTask);
  }

  void updateTaskAssignee(Task task, TaskAssignee assignee) {
    if (task.assingnee == assignee) return;

    final newTask = task.copy()..assingnee = assignee;

    TaskDataSource.updateTask(newTask);
  }

  void updateTaskStatus(Task task, String newStatus) {
    if (task.status == newStatus) return;

    final newTask = task.copy()..status = newStatus;

    TaskDataSource.deleteTask(task);
    TaskDataSource.createTask(newTask);
  }

  void deleteTask(Task task) async {
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

    TaskDataSource.deleteTask(task);
  }
}
