import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:kanban/core/util/logger/logger.dart';
import 'package:kanban/features/kanban/domain/constants/enum/task_importance.dart';

import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/usecases/task_usecases.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/task_form.dart';
import 'package:kanban/features/kanban/util/parse_tasklist_into_taskmap.dart';

part 'task_event.dart';
part 'task_state.dart';

final class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final CreateTaskUseCase createTask;
  final UpdateTaskUseCase updateTask;
  final UpdateTaskAssigneeUidUseCase updateTaskAssigneeUid;
  final UpdateTaskImportanceUseCase updateTaskImportance;
  final UpdateTaskStatusUseCase updateTaskStatus;
  final DeleteTaskUseCase deleteTask;
  final GetTaskStreamUseCase getTaskStream;

  StreamSubscription? _streamSubscription;
  Map<String, List<Task>> _taskList = {};

  List<Board> _boardList = [];

  TaskBloc({
    required this.getTaskStream,
    required this.createTask,
    required this.updateTask,
    required this.updateTaskAssigneeUid,
    required this.updateTaskImportance,
    required this.updateTaskStatus,
    required this.deleteTask,
  }) : super(TasksLoadingState()) {
    on<_TaskInitial>(_onTaskInitialEvent);
    on<_TaskStreamDataUpdate>(_onTaskStreamDataUpdate);
    on<_HandleTaskError>(_onHandleTaskError);

    on<LoadTasksEvent>(_onLoadTaskEvent);
    on<ReloadTasks>(_onReloadTask);

    on<CreateTaskEvent>(_onCreateTaskEvent);
    on<ReadTaskEvent>(_onReadTaskEvent);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
    on<UpdateTaskAssigneeUID>(_onUpdateTaskAssigneeUID);
    on<UpdateTaskImportance>(_onUpdateTaskImportance);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);

    Log.initializing(TaskBloc);
    add(_TaskInitial());
  }

  _onTaskInitialEvent(_TaskInitial event, Emitter<TaskState> emit) {
    emit(TasksLoadingState());
    Log.trace('$TaskBloc $_TaskInitial \n $event');
  }

  _onCreateTaskEvent(CreateTaskEvent event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $CreateTaskEvent \n $event');

    final newTask =
        await TaskForm(event.context).createTask(event.initialStatus);

    if (newTask == null) return;

    createTask(newTask);
  }

  _onReadTaskEvent(ReadTaskEvent event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $ReadTaskEvent \n $event');

    final newTask = await TaskForm(event.context).readTask(event.task);

    if (newTask == null) return;

    await updateTask(event.task, newTask);
  }

  _onUpdateTaskStatus(UpdateTaskStatus event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $UpdateTaskStatus \n $event');
    await updateTaskStatus(event.task, event.newStatus);
  }

  _onUpdateTaskAssigneeUID(
      UpdateTaskAssigneeUID event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $UpdateTaskAssigneeUID \n $event');

    await updateTaskAssigneeUid(event.task, event.newAssigneeUID);
  }

  _onUpdateTaskImportance(
      UpdateTaskImportance event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $UpdateTaskImportance \n $event');

    await updateTaskImportance(event.task, event.newImportance);
  }

  _onDeleteTaskEvent(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $DeleteTaskEvent \n $event');

    await deleteTask(event.task);
  }

  _onLoadTaskEvent(LoadTasksEvent event, Emitter<TaskState> emit) {
    Log.trace('$TaskBloc $LoadTasksEvent \n $event');
    if (event.boardList == _boardList) return;
    _boardList = event.boardList;
    try {
      final taskStream = getTaskStream();

      _streamSubscription = taskStream.listen(
        (data) => add(_TaskStreamDataUpdate(data, _boardList)),
        onError: (e) => _HandleTaskError(e),
        onDone: () => Log.debug('$TaskBloc streamSubscription is Done!'),
        cancelOnError: true,
      );
    } catch (e) {
      add(_HandleTaskError(e));
    }
  }

  _onReloadTask(_, Emitter<TaskState> emit) {
    Log.info('$TaskBloc $ReloadTasks');
    emit(TasksLoadedState(_taskList));
  }

  _onTaskStreamDataUpdate(
      _TaskStreamDataUpdate event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $_TaskStreamDataUpdate\n');
    final organized = mergeIntoMap(event.updatedTasks, event.boardList);
    _taskList = Map.from(organized);
    emit(TasksLoadedState(organized));
  }

  _onHandleTaskError(_HandleTaskError event, Emitter<TaskState> emit) {
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
