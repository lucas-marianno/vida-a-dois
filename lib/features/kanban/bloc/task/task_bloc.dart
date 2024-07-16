import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban/features/kanban/data/remote/firestore_service.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskLoadingState()) {
    on<TaskInitialEvent>((_, __) {});
    on<LoadTasksEvent>(_onLoadTaskEvent);
  }

  _onLoadTaskEvent(LoadTasksEvent event, Emitter<TaskState> emit) async {
    // Delay to simulate fetching data
    await Future.delayed(const Duration(seconds: 1));

    try {
      List<List<Task>> taskList =
          await FirestoreService.getTasks(event.columnList);
      emit(TaskLoadedState(taskList));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }
}
