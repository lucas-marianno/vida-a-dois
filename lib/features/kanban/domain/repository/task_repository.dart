import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/data/remote/firestore_service.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/presentation/widgets/create_task_form.dart';

// CRUD
class TaskRepository {
  final BuildContext context;

  TaskRepository(this.context);

  void createTask() async {
    final newTask = await TaskFromModalBottomForm.newTask(context);

    if (newTask != null) {
      FirestoreService.addTaskToColumn(newTask);
    }
  }

  void editTask(Task task) async {
    final newTask = await TaskFromModalBottomForm.editTask(task, context);

    if (newTask == null) return;

    if (task.status != newTask.status) {
      FirestoreService.deleteTask(task);
      FirestoreService.addTaskToColumn(newTask);
    } else {
      FirestoreService.editTask(newTask);
    }
  }

  void deleteTask(Task task) async {
    FirestoreService.deleteTask(task);
  }
}

comparandoTasks(Task task1, Task task2) {
  // print('----------------comparando tasks ----------------------------');
  // print('\t Attribute: \t | \t task1 \t | \t task2 \t');

  // for (var attribute in task1.toJson().keys) {
  //   final val1 = task1.toJson()[attribute];
  //   final val2 = task2.toJson()[attribute];
  //   final comparison = val1 == val2 ? '✅' : '❌';

  //   print('$comparison Attribute: $attribute | $val1 | $val2');
  // }
  // print('-------------------------------------------------------------');
}
