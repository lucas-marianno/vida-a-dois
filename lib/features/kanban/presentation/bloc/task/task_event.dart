part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

final class _TaskInitial extends TaskEvent {}

final class _TaskStreamDataUpdate extends TaskEvent {
  final List<Task> updatedTasks;
  final List<Board> boardList;

  const _TaskStreamDataUpdate(this.updatedTasks, this.boardList);

  @override
  List<Object> get props => [updatedTasks];
}

final class _HandleTaskError extends TaskEvent {
  final Object error;

  const _HandleTaskError(this.error);

  @override
  List<Object> get props => [error];
}

final class LoadTasksEvent extends TaskEvent {
  final List<Board> boardList;

  const LoadTasksEvent(this.boardList);

  @override
  List<Object> get props => [boardList];
}

final class ReloadTasks extends TaskEvent {}

final class CreateTaskEvent extends TaskEvent {
  final BuildContext context;
  final String initialStatus;

  const CreateTaskEvent(this.context, this.initialStatus);

  @override
  List<Object> get props => [context, initialStatus];
}

final class ReadTaskEvent extends TaskEvent {
  final BuildContext context;
  final Task task;

  const ReadTaskEvent(this.context, this.task);

  @override
  List<Object> get props => [context, task];
}

final class _UpdateTask extends TaskEvent {
  final Task task;

  const _UpdateTask(this.task);

  @override
  List<Object> get props => [task];
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

final class DeleteTaskEvent extends TaskEvent {
  final Task task;

  const DeleteTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}
