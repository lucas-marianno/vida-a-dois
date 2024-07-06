// ignore_for_file: prefer_const_constructors

import '../../../core/constants/enum/task_status.dart';
import '../domain/entities/task_entity.dart';

List<Task> todo = [
  Task(title: 'todo 1', status: TaskStatus.todo),
  Task(title: 'todo 2', status: TaskStatus.todo),
  Task(title: 'todo 3', status: TaskStatus.todo),
];
List<Task> inProgress = [
  Task(title: 'in progress 1', status: TaskStatus.inProgress),
  Task(title: 'in progress 2', status: TaskStatus.inProgress),
  Task(title: 'in progress 3', status: TaskStatus.inProgress),
  Task(title: 'in progress 4', status: TaskStatus.inProgress),
  Task(title: 'in progress 5', status: TaskStatus.inProgress),
  Task(title: 'in progress 6', status: TaskStatus.inProgress),
];
List<Task> done = [
  // Task(title: 'done 1'),
];
