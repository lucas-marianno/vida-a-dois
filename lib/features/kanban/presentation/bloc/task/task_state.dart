part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

final class TaskLoading extends TaskState {}

final class TasksLoaded extends TaskState {
  final Map<String, List<Task>> mappedTasks;

  const TasksLoaded(this.mappedTasks);

  @override
  List<Object> get props => [mappedTasks];
}

final class ReadingTask extends TaskState {
  final Task task;
  final bool isNewTask;

  const ReadingTask(this.task, this.isNewTask);

  @override
  List<Object> get props => [isNewTask];
}

final class TaskError extends TaskState {
  final Object error;

  const TaskError(this.error);

  @override
  List<Object> get props => [error];
}
