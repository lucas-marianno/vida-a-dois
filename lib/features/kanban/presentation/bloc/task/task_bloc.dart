import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/util/logger/logger.dart';
import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';

import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';

import 'package:kanban/features/kanban/presentation/widgets/form/task_form.dart';

import 'package:kanban/features/kanban/util/compare_task.dart';
import 'package:kanban/features/kanban/util/parse_tasklist_into_taskmap.dart';

part 'task_event.dart';
part 'task_state.dart';

final class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  StreamSubscription? _streamSubscription;
  Map<String, List<Task>> _taskList = {};

  List<Board> _boardList = [];

  TaskBloc(this.taskRepository) : super(TasksLoadingState()) {
    on<_TaskInitial>(_onTaskInitialEvent);
    on<_TaskStreamDataUpdate>(_onTaskStreamDataUpdate);
    on<_HandleTaskError>(_onHandleTaskError);

    on<LoadTasksEvent>(_onLoadTaskEvent);
    on<ReloadTasks>(_onReloadTask);

    on<CreateTaskEvent>(_onCreateTaskEvent);
    on<ReadTaskEvent>(_onReadTaskEvent);
    on<_UpdateTask>(_onUpdateTaskEvent);
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

    final newTask = await TaskForm.readTask(
      Task(title: L10n.of(event.context).newTask, status: event.initialStatus),
      event.context,
      initAsReadOnly: false,
    );

    if (newTask == null) return;

    try {
      await taskRepository.createTask(newTask);
    } catch (e) {
      add(_HandleTaskError(e));
    }
  }

  _onReadTaskEvent(ReadTaskEvent event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $ReadTaskEvent \n $event');

    final newTask = await TaskForm.readTask(event.task, event.context);

    if (newTask == null || !compareTasks(event.task, newTask)) return;

    try {
      await taskRepository.updateTask(newTask);
    } catch (e) {
      add(_HandleTaskError(e));
    }
  }

  _onUpdateTaskEvent(_UpdateTask event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $_UpdateTask \n $event');
    await taskRepository.updateTask(event.task);
  }

  _onUpdateTaskStatus(UpdateTaskStatus event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $UpdateTaskStatus \n $event');
    if (event.task.status == event.newStatus) return;
    await taskRepository.updateTask(event.task..status = event.newStatus);
  }

  _onUpdateTaskAssigneeUID(
      UpdateTaskAssigneeUID event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $UpdateTaskAssigneeUID \n $event');
    if (event.task.assingneeUID == event.newAssigneeUID) return;

    await taskRepository.updateTask(
      event.task..assingneeUID = event.newAssigneeUID,
    );
  }

  _onUpdateTaskImportance(
      UpdateTaskImportance event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $UpdateTaskImportance \n $event');
    if (event.task.taskImportance == event.newImportance) return;

    await taskRepository.updateTask(
      event.task..taskImportance = event.newImportance,
    );
  }

  _onDeleteTaskEvent(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    Log.trace('$TaskBloc $DeleteTaskEvent \n $event');
    try {
      await taskRepository.deleteTask(event.task);
    } catch (e) {
      add(_HandleTaskError(e));
    }
  }

  _onLoadTaskEvent(LoadTasksEvent event, Emitter<TaskState> emit) {
    Log.trace('$TaskBloc $LoadTasksEvent \n $event');
    if (event.boardList == _boardList) return;
    _boardList = event.boardList;
    try {
      final taskStream = taskRepository.readTasks();

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
    final organized = parseListIntoMap(event.updatedTasks, event.boardList);
    _taskList = organized;
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
