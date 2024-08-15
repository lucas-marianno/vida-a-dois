part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

final class TasksLoadingState extends TaskState {}

final class TasksLoadedState extends TaskState {
  final Map<String, List<Task>> mappedTasks;

  const TasksLoadedState(this.mappedTasks);

  @override
  List<Object> get props => [mappedTasks];
}

final class TasksErrorState extends TaskState {
  final Object error;

  const TasksErrorState(this.error);

  @override
  List<Object> get props => [error];
}
