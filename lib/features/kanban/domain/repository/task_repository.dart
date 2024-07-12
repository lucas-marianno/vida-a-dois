import 'package:flutter/material.dart';
import 'package:kanban/core/constants/enum/task_assignee.dart';
import 'package:kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/core/constants/enum/task_status.dart';
import 'package:kanban/features/kanban/data/remote/firestore_service.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/task_form.dart';

// CRUD
class TaskRepository {
  final BuildContext context;

  TaskRepository(this.context);

  void createTask() async {
    final newTask = await TaskForm.newTask(context);

    if (newTask != null) {
      FirestoreService.addTaskToColumn(newTask);
    }
  }

  void editTask(Task task) async {
    final newTask = await TaskForm.editTask(task, context);

    if (newTask == null) return;

    if (task.status != newTask.status) {
      FirestoreService.deleteTask(task);
      FirestoreService.addTaskToColumn(newTask);
    } else {
      FirestoreService.editTask(newTask);
    }
  }

  void updateTaskImportance(Task task, TaskImportance taskImportance) {
    if (task.taskImportance == taskImportance) return;

    final newTask = task.copy()..taskImportance = taskImportance;

    FirestoreService.editTask(newTask);
  }

  void updateTaskAssignee(Task task, TaskAssignee assignee) {
    if (task.assingnee == assignee) return;

    final newTask = task.copy()..assingnee = assignee;

    FirestoreService.editTask(newTask);
  }

  void updateTaskStatus(Task task, TaskStatus newStatus) {
    if (task.status == newStatus) return;

    final newTask = task.copy()..status = newStatus;

    FirestoreService.deleteTask(task);
    FirestoreService.addTaskToColumn(newTask);
  }

  void deleteTask(Task task) async {
    FirestoreService.deleteTask(task);
  }
}
