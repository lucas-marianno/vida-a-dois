import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban/features/kanban/data/remote/firestore_service.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  late StreamSubscription streamSubscription;

  TaskBloc() : super(TaskLoadingState()) {
    on<TaskInitialEvent>((_, __) {});
    on<LoadTasksEvent>(_onLoadTaskEvent);
    on<TasksUpdatedEvent>(_onTasksUpdatedEvent);
  }

  /// TODO: refactor this!
  ///
  /// This is a dumb way to achieve real-time screen updates.
  ///
  /// Everytime a column updates, [TasksUpdatedEvent] is called twice,
  /// since two columns are actually being updated. (deleteTask + createTask).
  ///
  /// The database should probably be updated to store all tasks in a single
  /// collection, and then the UI should separate them according to each
  /// taskStatus, or something like it.
  _onLoadTaskEvent(LoadTasksEvent event, Emitter<TaskState> emit) async {
    final stream = FirestoreService.getTasksStream(event.columnList);

    streamSubscription = stream.listen((_) {
      add(TasksUpdatedEvent(event.columnList));
    });
  }

  _onTasksUpdatedEvent(
    TasksUpdatedEvent event,
    Emitter<TaskState> emit,
  ) async {
    List<ColumnEntity> columnList = event.columnList;

    try {
      List<List<Task>> taskList = await FirestoreService.getTasks(columnList);
      emit(TaskLoadedState(taskList));
      // add(TaskInitSubscriptionEvent(columnList));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
