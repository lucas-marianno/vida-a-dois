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

  TaskBloc() : super(TasksLoadingState()) {
    on<TaskInitialEvent>((_, __) {});
    on<LoadTasksEvent>(_onLoadTaskEvent);
    on<TasksUpdatedEvent>(_onTasksUpdatedEvent);
  }

  _onLoadTaskEvent(LoadTasksEvent event, Emitter<TaskState> emit) {
    try {
      final taskStream = FirestoreService.getTasksStream();

      streamSubscription = taskStream.listen((data) {
        add(TasksUpdatedEvent(data, event.columnList));
      });
    } catch (e) {
      emit(TasksErrorState(e.toString()));
    }
  }

  _onTasksUpdatedEvent(TasksUpdatedEvent event, Emitter<TaskState> emit) async {
    final organized = FirestoreService.organizeList(
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
