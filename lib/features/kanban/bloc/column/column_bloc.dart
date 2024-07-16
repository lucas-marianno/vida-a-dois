import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban/features/kanban/data/remote/firestore_service.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';

part 'column_event.dart';
part 'column_state.dart';

class ColumnsBloc extends Bloc<ColumnEvent, ColumnState> {
  final _columnsStream = FirestoreService.getColumnsStream();
  late final StreamSubscription _columnsSubscription;

  ColumnsBloc() : super(ColumnLoadingState()) {
    on<LoadColumnEvent>(_onLoadKanbanEvent);
    on<ColumnsUpdatedEvent>(_onColumnsUpdatedEvent);
  }

  _onLoadKanbanEvent(
    LoadColumnEvent event,
    Emitter<ColumnState> emit,
  ) async {
    late final List<ColumnEntity> columns;

    _columnsSubscription = _columnsStream.listen((snapshot) {
      columns = snapshot.docs.map((doc) => ColumnEntity.fromJson(doc)).toList();

      add(ColumnsUpdatedEvent(columns));
    });
  }

  _onColumnsUpdatedEvent(
    ColumnsUpdatedEvent event,
    Emitter<ColumnState> emit,
  ) async {
    emit(ColumnLoadedState(event.columns));
  }

  @override
  Future<void> close() {
    _columnsSubscription.cancel();
    return super.close();
  }
}
