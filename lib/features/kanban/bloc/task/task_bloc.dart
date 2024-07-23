import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kanban/core/util/logger/logger.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_assignee.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/features/kanban/data/remote/task_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';
import 'package:kanban/features/kanban/util/parse_tasklist_into_taskmap.dart';

part 'task_event.dart';
part 'task_state.dart';

final class TaskBloc extends Bloc<TaskEvent, TaskState> {
  StreamSubscription? _streamSubscription;
  late TaskRepository _taskRepo;

  TaskBloc() : super(TasksLoadingState()) {
    on<TaskInitialEvent>(_onTaskInitialEvent);
    on<LoadTasksEvent>(_onLoadTaskEvent);
    on<TaskStreamDataUpdate>(_onTaskStreamDataUpdate);
    on<CreateTaskEvent>(_onCreateTaskEvent);
    on<ReadTaskEvent>(_onReadTaskEvent);
    on<UpdateTaskImportanceEvent>(_onUpdateTaskImportanceEvent);
    on<UpdateTaskAssigneeEvent>(_onUpdateTaskAssigneeEvent);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatusEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
    on<HandleTaskError>(_onHandleTaskError);

    Log.initializing(TaskBloc);
  }

  _onTaskInitialEvent(TaskInitialEvent event, Emitter<TaskState> emit) {
    Log.trace('$TaskBloc $TaskInitialEvent \n $event');
    _taskRepo = TaskRepository(event.context);
  }

  _onCreateTaskEvent(CreateTaskEvent event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $CreateTaskEvent \n $event');

    try {
      await _taskRepo.createTask(event.newTask);
    } catch (e) {
      add(HandleTaskError(e));
    }
  }

  _onReadTaskEvent(ReadTaskEvent event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $ReadTaskEvent \n $event');

    try {
      await _taskRepo.readTask(event.task);
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
      await _taskRepo.updateTaskImportance(event.task, event.importance);
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
      await _taskRepo.updateTaskAssignee(event.task, event.assignee);
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
      await _taskRepo.updateTaskStatus(event.task, event.newStatus);
    } catch (e) {
      add(HandleTaskError(e));
    }
  }

  _onDeleteTaskEvent(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await _taskRepo.deleteTask(event.task);
    } catch (e) {
      add(HandleTaskError(e));
    }
  }

  _onLoadTaskEvent(LoadTasksEvent event, Emitter<TaskState> emit) {
    Log.trace('$TaskBloc $LoadTasksEvent \n $event');
    emit(TasksLoadingState());
    try {
      final taskStream = TaskDataSource.readTasks;

      _streamSubscription = taskStream.listen(
        (data) {
          add(TaskStreamDataUpdate(data, event.boardList));
        },
        onError: (e) => HandleTaskError(e),
        onDone: () => Log.debug('$TaskBloc streamSubscription is Done!'),
        cancelOnError: true,
      );
    } catch (e) {
      add(HandleTaskError(e));
    }
  }

  _onTaskStreamDataUpdate(
      TaskStreamDataUpdate event, Emitter<TaskState> emit) async {
    final organized = parseListIntoMap(
      event.updatedTasks,
      event.boardList,
    );
    Log.trace('$TaskBloc $TaskStreamDataUpdate \n $event \n $TasksLoadedState');
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
