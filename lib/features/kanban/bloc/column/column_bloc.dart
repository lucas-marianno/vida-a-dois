import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban/features/kanban/data/remote/firestore_service.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';

part 'column_event.dart';
part 'column_state.dart';

class ColumnsBloc extends Bloc<ColumnEvent, ColumnState> {
  late final StreamSubscription _columnsSubscription;
  ColumnsBloc() : super(ColumnLoadingState()) {
    on<LoadColumnEvent>(_onLoadKanbanEvent);
  }

  _onLoadKanbanEvent(LoadColumnEvent event, Emitter<ColumnState> emit) async {
    // Delay to simulate fetching data
    await Future.delayed(const Duration(seconds: 1));

    _columnsSubscription =
        FirestoreService.getMockKanbanStatusColumns().listen((snapshot) {
      final columns =
          snapshot.docs.map((doc) => ColumnEntity.fromJson(doc)).toList();

      add(ColumnsUpdatedEvent(columns));
    });

    try {
      final columns = await FirestoreService.getColumns();
      emit(ColumnLoadedState(columns));
    } catch (e) {
      emit(ColumnErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _columnsSubscription.cancel();
    return super.close();
  }
}
