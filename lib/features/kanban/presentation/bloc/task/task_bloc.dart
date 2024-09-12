import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:vida_a_dois/core/util/logger/logger.dart';
import 'package:vida_a_dois/features/kanban/domain/constants/enum/task_importance.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/board_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/usecases/task_usecases.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final CreateTaskUseCase _createTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final UpdateTaskAssigneeUidUseCase _updateTaskAssigneeUidUseCase;
  final UpdateTaskImportanceUseCase _updateTaskImportanceUseCase;
  final UpdateTaskStatusUseCase _updateTaskStatusUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final GetTasksUseCase _getTaskStreamUseCase;

  StreamSubscription? _streamSubscription;
  Map<String, List<Task>> _lastEmittetMappedTaskList = {};

  List<Board> _boardList = [];

  TaskBloc({
    required GetTasksUseCase getTaskStream,
    required CreateTaskUseCase createTask,
    required UpdateTaskUseCase updateTask,
    required UpdateTaskAssigneeUidUseCase updateTaskAssigneeUID,
    required UpdateTaskImportanceUseCase updateTaskImportance,
    required UpdateTaskStatusUseCase updateTaskStatus,
    required DeleteTaskUseCase deleteTask,
  })  : _updateTaskAssigneeUidUseCase = updateTaskAssigneeUID,
        _updateTaskImportanceUseCase = updateTaskImportance,
        _updateTaskStatusUseCase = updateTaskStatus,
        _getTaskStreamUseCase = getTaskStream,
        _deleteTaskUseCase = deleteTask,
        _updateTaskUseCase = updateTask,
        _createTaskUseCase = createTask,
        super(TaskLoading()) {
    on<_TaskInitial>(_onTaskInitialEvent);
    on<_TaskStreamUpdate>(_onTaskStreamDataUpdate);
    on<_HandleTaskError>(_onHandleTaskError);

    on<LoadTasks>(_onLoadTaskEvent);
    on<ReloadTasks>(_onReloadTask);

    on<ReadTask>(_onReadTaskEvent);
    on<UpdateTask>(_updateTask);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
    on<UpdateTaskAssigneeUID>(_onUpdateTaskAssigneeUID);
    on<UpdateTaskImportance>(_onUpdateTaskImportance);
    on<DeleteTask>(_onDeleteTaskEvent);

    add(_TaskInitial());
  }

  _onTaskInitialEvent(_, Emitter<TaskState> emit) {
    emit(TaskLoading());
  }

  _onReadTaskEvent(ReadTask event, Emitter<TaskState> emit) async {
    emit(ReadingTask(event.task, event.isNewTask));
    emit(TasksLoaded(_lastEmittetMappedTaskList));
  }

  _updateTask(UpdateTask event, _) async {
    if (event.isNewTask) {
      await _createTaskUseCase(event.task);
    } else {
      await _updateTaskUseCase(event.task);
    }
  }

  _onUpdateTaskStatus(UpdateTaskStatus event, _) async {
    await _updateTaskStatusUseCase(event.task, event.newStatus);
  }

  _onUpdateTaskAssigneeUID(UpdateTaskAssigneeUID event, _) async {
    await _updateTaskAssigneeUidUseCase(event.task, event.newAssigneeUID);
  }

  _onUpdateTaskImportance(UpdateTaskImportance event, _) async {
    await _updateTaskImportanceUseCase(event.task, event.newImportance);
  }

  _onDeleteTaskEvent(DeleteTask event, _) async {
    await _deleteTaskUseCase(event.task);
  }

  _onLoadTaskEvent(LoadTasks event, _) async {
    if (event.boardList == _boardList) return;
    _boardList = List.from(event.boardList);

    try {
      _streamSubscription = _getTaskStreamUseCase().listen(
        (data) => add(_TaskStreamUpdate(data)),
        onError: (e) => _HandleTaskError(e),
        onDone: () => logger.debug('$TaskBloc streamSubscription is Done!'),
        cancelOnError: true,
      );
    } catch (e) {
      add(_HandleTaskError(e));
    }
  }

  _onReloadTask(_, Emitter<TaskState> emit) {
    emit(TasksLoaded(_lastEmittetMappedTaskList));
  }

  _onTaskStreamDataUpdate(
      _TaskStreamUpdate event, Emitter<TaskState> emit) async {
    if ('${event.updatedTasks}' == '$_lastEmittetMappedTaskList') return;

    _lastEmittetMappedTaskList = Map.from(event.updatedTasks);
    emit(TasksLoaded(_lastEmittetMappedTaskList));
  }

  _onHandleTaskError(_HandleTaskError event, Emitter<TaskState> emit) {
    emit(TaskError(event.error));
  }

  @override
  void onChange(Change<TaskState> change) {
    logger.debug(
      '$TaskBloc ${change.nextState.runtimeType}\n'
      '${change.nextState}',
    );
    super.onChange(change);
  }

  @override
  void onEvent(TaskEvent event) {
    switch (event) {
      case _TaskInitial():
        logger.initializing(TaskBloc);
        break;
      case _HandleTaskError():
        final error = event.error;
        logger.error('$TaskBloc ${error.runtimeType}', error: error);
        break;
      default:
        logger.trace('$TaskBloc ${event.runtimeType} \n $event');
    }

    super.onEvent(event);
  }

  @override
  Future<void> close() {
    logger.trace('$TaskBloc close()');
    _streamSubscription?.cancel();
    return super.close();
  }
}
