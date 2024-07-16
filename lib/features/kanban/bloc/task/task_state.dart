part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

final class TaskLoadingState extends TaskState {}

final class TaskLoadedState extends TaskState {
  final List<List<Task>> taskList;

  const TaskLoadedState(this.taskList);

  @override
  List<Object> get props => [taskList];
}

final class TaskErrorState extends TaskState {
  final String error;

  const TaskErrorState(this.error);

  @override
  List<Object> get props => [error];
}
