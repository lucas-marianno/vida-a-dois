part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

final class HandleTaskError extends TaskEvent {
  final Object error;

  const HandleTaskError(this.error);

  @override
  List<Object> get props => [error];
}

final class TaskInitialEvent extends TaskEvent {
  final BuildContext context;

  const TaskInitialEvent(this.context);

  @override
  List<Object> get props => [context];
}

final class LoadTasksEvent extends TaskEvent {
  final List<BoardEntity> boardList;

  const LoadTasksEvent(this.boardList);

  @override
  List<Object> get props => [boardList];
}

final class ReloadTasks extends TaskEvent {}

final class TaskStreamDataUpdate extends TaskEvent {
  final List<Task> updatedTasks;
  final List<BoardEntity> boardList;

  const TaskStreamDataUpdate(this.updatedTasks, this.boardList);

  @override
  List<Object> get props => [updatedTasks];
}

final class CreateTaskEvent extends TaskEvent {
  final Task newTask;

  const CreateTaskEvent(this.newTask);

  @override
  List<Object> get props => [newTask];
}

final class ReadTaskEvent extends TaskEvent {
  final Task task;

  const ReadTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

final class UpdateTaskImportanceEvent extends TaskEvent {
  final Task task;
  final TaskImportance importance;

  const UpdateTaskImportanceEvent(this.task, this.importance);

  @override
  List<Object> get props => [task, importance];
}

final class UpdateTaskAssigneeEvent extends TaskEvent {
  final Task task;
  final TaskAssignee assignee;

  const UpdateTaskAssigneeEvent(this.task, this.assignee);

  @override
  List<Object> get props => [task, assignee];
}

final class UpdateTaskStatusEvent extends TaskEvent {
  final Task task;
  final String newStatus;

  const UpdateTaskStatusEvent(this.task, this.newStatus);

  @override
  List<Object> get props => [task, newStatus];
}

final class DeleteTaskEvent extends TaskEvent {
  final Task task;

  const DeleteTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}
