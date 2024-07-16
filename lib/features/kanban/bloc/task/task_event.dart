part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class TaskInitialEvent extends TaskEvent {}

class LoadTasksEvent extends TaskEvent {
  final List<ColumnEntity> columnList;

  const LoadTasksEvent(this.columnList);

  @override
  List<Object> get props => [columnList];
}

class TasksUpdatedEvent extends TaskEvent {
  final Map<String, List<Task>> mappedTasks;

  const TasksUpdatedEvent(this.mappedTasks);

  @override
  List<Object> get props => [mappedTasks];
}
