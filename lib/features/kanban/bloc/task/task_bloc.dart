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
  late StreamSubscription streamSubscription;
  late TaskRepository taskRepo;

  TaskBloc() : super(TasksLoadingState()) {
    on<TaskInitialEvent>(
        (event, __) => taskRepo = TaskRepository(event.context));
    on<LoadTasksEvent>(_onLoadTaskEvent);
    on<TasksUpdatedEvent>(_onTasksUpdatedEvent);
    on<CreateTaskEvent>(_onCreateTaskEvent);
    on<ReadTaskEvent>(_onReadTaskEvent);
    on<UpdateTaskImportanceEvent>(_onUpdateTaskImportanceEvent);
    on<UpdateTaskAssigneeEvent>(_onUpdateTaskAssigneeEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
  }
  _onCreateTaskEvent(CreateTaskEvent event, Emitter<TaskState> emit) {
    throw Exception("some weird behavior is happening");
    print("new task event");
    taskRepo.createTask();
  }

  _onReadTaskEvent(ReadTaskEvent event, Emitter<TaskState> emit) {
    taskRepo.readTask(event.task);
  }

  _onUpdateTaskImportanceEvent(
    UpdateTaskImportanceEvent event,
    Emitter<TaskState> emit,
  ) {
    taskRepo.updateTaskImportance(event.task, event.importance);
  }

  _onUpdateTaskAssigneeEvent(
    UpdateTaskAssigneeEvent event,
    Emitter<TaskState> emit,
  ) {
    taskRepo.updateTaskAssignee(event.task, event.assignee);
  }

  _onDeleteTaskEvent(DeleteTaskEvent event, Emitter<TaskState> emit) {
    taskRepo.deleteTask(event.task);
  }

  _onLoadTaskEvent(LoadTasksEvent event, Emitter<TaskState> emit) {
    try {
      final taskStream = TaskDataSource.readTasks;

      streamSubscription = taskStream.listen((data) {
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
    streamSubscription.cancel();
    return super.close();
  }
}
