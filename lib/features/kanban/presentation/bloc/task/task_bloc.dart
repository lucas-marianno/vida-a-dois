import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban/core/util/logger/logger.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';
import 'package:kanban/features/kanban/util/parse_tasklist_into_taskmap.dart';

part 'task_event.dart';
part 'task_state.dart';

final class TaskBloc extends Bloc<TaskEvent, TaskState> {
  StreamSubscription? _streamSubscription;
  Map<String, List<Task>> _taskList = {};

  List<Board> _boardList = [];

  TaskBloc() : super(TasksLoadingState()) {
    on<TaskInitialEvent>(_onTaskInitialEvent);
    on<LoadTasksEvent>(_onLoadTaskEvent);
    on<ReloadTasks>(_onReloadTask);
    on<TaskStreamDataUpdate>(_onTaskStreamDataUpdate);
    on<CreateTaskEvent>(_onCreateTaskEvent);
    on<UpdateTaskEvent>(_onUpdateTaskEvent);
    on<UpdateTaskImportanceEvent>(_onUpdateTaskImportanceEvent);
    on<UpdateTaskAssigneeEvent>(_onUpdateTaskAssigneeEvent);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatusEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
    on<HandleTaskError>(_onHandleTaskError);

    Log.initializing(TaskBloc);
    add(TaskInitialEvent());
  }

  _onTaskInitialEvent(TaskInitialEvent event, Emitter<TaskState> emit) {
    emit(TasksLoadingState());
    Log.trace('$TaskBloc $TaskInitialEvent \n $event');
  }

  _onCreateTaskEvent(CreateTaskEvent event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $CreateTaskEvent \n $event');

    try {
      await TaskRepository.createTask(event.newTask);
    } catch (e) {
      add(HandleTaskError(e));
    }
  }

  _onUpdateTaskEvent(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $UpdateTaskEvent \n $event');

    try {
      await TaskRepository.updateTask(event.task);
    } catch (e) {
      add(HandleTaskError(e));
    }
  }

  _onUpdateTaskImportanceEvent(
    UpdateTaskImportanceEvent event,
    Emitter<TaskState> emit,
  ) async {
    Log.trace('$TaskBloc $UpdateTaskImportanceEvent \n $event');

    try {
      await TaskRepository.updateTaskImportance(event.task, event.importance);
    } catch (e) {
      add(HandleTaskError(e));
    }
  }

  _onUpdateTaskAssigneeEvent(
    UpdateTaskAssigneeEvent event,
    Emitter<TaskState> emit,
  ) async {
    Log.trace('$TaskBloc $UpdateTaskAssigneeEvent \n $event');
    try {
      await TaskRepository.updateTaskAssignee(event.task, event.assigneeUID);
    } catch (e) {
      add(HandleTaskError(e));
    }
  }

  _onUpdateTaskStatusEvent(
    UpdateTaskStatusEvent event,
    Emitter<TaskState> emit,
  ) async {
    Log.trace('$TaskBloc $UpdateTaskStatusEvent \n $event');
    try {
      await TaskRepository.updateTaskStatus(event.task, event.newStatus);
    } catch (e) {
      add(HandleTaskError(e));
    }
  }

  _onDeleteTaskEvent(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await TaskRepository.deleteTask(event.task);
    } catch (e) {
      add(HandleTaskError(e));
    }
  }

  _onLoadTaskEvent(LoadTasksEvent event, Emitter<TaskState> emit) {
    Log.trace('$TaskBloc $LoadTasksEvent \n $event');
    if (event.boardList == _boardList) return;
    _boardList = event.boardList;
    try {
      final taskStream = TaskRepository.readTasks;

      _streamSubscription = taskStream.listen(
        (data) => add(TaskStreamDataUpdate(data, _boardList)),
        onError: (e) => HandleTaskError(e),
        onDone: () => Log.debug('$TaskBloc streamSubscription is Done!'),
        cancelOnError: true,
      );
    } catch (e) {
      add(HandleTaskError(e));
    }
  }

  _onReloadTask(_, Emitter<TaskState> emit) {
    Log.info('$TaskBloc $ReloadTasks');
    emit(TasksLoadedState(_taskList));
  }

  _onTaskStreamDataUpdate(
    TaskStreamDataUpdate event,
    Emitter<TaskState> emit,
  ) async {
    Log.trace('$TaskBloc $TaskStreamDataUpdate\n');
    final organized = parseListIntoMap(event.updatedTasks, event.boardList);
    _taskList = organized;
    emit(TasksLoadedState(organized));
  }

  _onHandleTaskError(HandleTaskError event, Emitter<TaskState> emit) {
    Log.error(event.error.runtimeType, error: event.error);

    emit(TasksErrorState(event.error));
  }

  @override
  Future<void> close() {
    Log.trace('$TaskBloc close()');
    _streamSubscription?.cancel();
    return super.close();
  }
}
