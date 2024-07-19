part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class TaskInitialEvent extends TaskEvent {
  final BuildContext context;

  const TaskInitialEvent(this.context);

  @override
  List<Object> get props => [context];
}

class LoadTasksEvent extends TaskEvent {
  final List<BoardEntity> boardList;

  const LoadTasksEvent(this.boardList);

  @override
  List<Object> get props => [boardList];
}

class TasksUpdatedEvent extends TaskEvent {
  final List<Task> updatedTasks;
  final List<BoardEntity> boardList;

  const TasksUpdatedEvent(this.updatedTasks, this.boardList);

  @override
  List<Object> get props => [updatedTasks];
}

class CreateTaskEvent extends TaskEvent {
  final BoardEntity currentBoard;

  const CreateTaskEvent(this.currentBoard);

  @override
  List<Object> get props => [currentBoard];
}

class ReadTaskEvent extends TaskEvent {
  final Task task;

  const ReadTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTaskImportanceEvent extends TaskEvent {
  final Task task;
  final TaskImportance importance;

  const UpdateTaskImportanceEvent(this.task, this.importance);

  @override
  List<Object> get props => [task, importance];
}

class UpdateTaskAssigneeEvent extends TaskEvent {
  final Task task;
  final TaskAssignee assignee;

  const UpdateTaskAssigneeEvent(this.task, this.assignee);

  @override
  List<Object> get props => [task, assignee];
}

class DeleteTaskEvent extends TaskEvent {
  final Task task;

  const DeleteTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}
// TODO: implement CRUD events