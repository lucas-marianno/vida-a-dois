part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

final class _TaskInitial extends TaskEvent {}

final class _TaskStreamUpdate extends TaskEvent {
  final List<Task> updatedTasks;
  final List<Board> boardList;

  const _TaskStreamUpdate(this.updatedTasks, this.boardList);

  @override
  List<Object> get props => [updatedTasks, boardList];
}

final class _HandleTaskError extends TaskEvent {
  final Object error;

  const _HandleTaskError(this.error);

  @override
  List<Object> get props => [error];
}

final class LoadTasks extends TaskEvent {
  final List<Board> boardList;

  const LoadTasks(this.boardList);

  @override
  List<Object> get props => [boardList];
}

final class ReloadTasks extends TaskEvent {}

final class ReadTask extends TaskEvent {
  final Task task;
  final bool isNewTask;

  const ReadTask(this.task, {this.isNewTask = false});

  @override
  List<Object> get props => [task, isNewTask];
}

final class UpdateTask extends TaskEvent {
  final Task task;
  final bool isNewTask;

  const UpdateTask(this.task, {this.isNewTask = false});

  @override
  List<Object> get props => [task, isNewTask];
}

final class UpdateTaskAssigneeUID extends TaskEvent {
  final Task task;
  final String newAssigneeUID;

  const UpdateTaskAssigneeUID(this.task, this.newAssigneeUID);

  @override
  List<Object> get props => [task, newAssigneeUID];
}

final class UpdateTaskImportance extends TaskEvent {
  final Task task;
  final TaskImportance newImportance;

  const UpdateTaskImportance(this.task, this.newImportance);

  @override
  List<Object> get props => [task, newImportance];
}

final class UpdateTaskStatus extends TaskEvent {
  final Task task;
  final String newStatus;

  const UpdateTaskStatus(this.task, this.newStatus);

  @override
  List<Object> get props => [task, newStatus];
}

final class DeleteTask extends TaskEvent {
  final Task task;

  const DeleteTask(this.task);

  @override
  List<Object> get props => [task];
}
