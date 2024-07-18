import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_assignee.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/features/kanban/data/remote/task_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';
import 'package:kanban/features/kanban/util/parse_tasklist_into_taskmap.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  StreamSubscription? _streamSubscription;
  late TaskRepository _taskRepo;

  TaskBloc() : super(TasksLoadingState()) {
    on<TaskInitialEvent>(_onTaskInitialEvent);
    on<LoadTasksEvent>(_onLoadTaskEvent);
    on<TasksUpdatedEvent>(_onTasksUpdatedEvent);
    on<CreateTaskEvent>(_onCreateTaskEvent);
    on<ReadTaskEvent>(_onReadTaskEvent);
    on<UpdateTaskImportanceEvent>(_onUpdateTaskImportanceEvent);
    on<UpdateTaskAssigneeEvent>(_onUpdateTaskAssigneeEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
  }

  _onTaskInitialEvent(TaskInitialEvent event, Emitter<TaskState> emit) {
    _taskRepo = TaskRepository(event.context);
  }

  _onCreateTaskEvent(CreateTaskEvent event, Emitter<TaskState> emit) async {
    await _taskRepo.createTask(Task(
      title: 'Nova Tarefa',
      status: event.currentColumn.title,
    ));
  }

  _onReadTaskEvent(ReadTaskEvent event, Emitter<TaskState> emit) async {
    await _taskRepo.readTask(event.task);
  }

  _onUpdateTaskImportanceEvent(
    UpdateTaskImportanceEvent event,
    Emitter<TaskState> emit,
  ) async {
    await _taskRepo.updateTaskImportance(event.task, event.importance);
  }

  _onUpdateTaskAssigneeEvent(
    UpdateTaskAssigneeEvent event,
    Emitter<TaskState> emit,
  ) async {
    await _taskRepo.updateTaskAssignee(event.task, event.assignee);
  }

  _onDeleteTaskEvent(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    await _taskRepo.deleteTask(event.task);
  }

  _onLoadTaskEvent(LoadTasksEvent event, Emitter<TaskState> emit) {
    try {
      final taskStream = TaskDataSource.readTasks;

      _streamSubscription = taskStream.listen((data) {
        add(TasksUpdatedEvent(data, event.columnList));
      });
    } catch (e) {
      emit(TasksErrorState(e.toString()));
    }
  }

  _onTasksUpdatedEvent(TasksUpdatedEvent event, Emitter<TaskState> emit) async {
    final organized = parseListIntoMap(
      event.updatedTasks,
      event.columnList,
    );
    emit(TasksLoadedState(organized));
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
