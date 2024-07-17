import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban/features/kanban/data/remote/column_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';

part 'column_event.dart';
part 'column_state.dart';

// TODO: Implement columns CRUD
class ColumnsBloc extends Bloc<ColumnsEvent, ColumnsState> {
  static List<ColumnEntity> statusList = [];
  final _columnsStream = ColumnDataSource.readColumns;
  late final StreamSubscription _columnsSubscription;

  ColumnsBloc() : super(ColumnLoadingState()) {
    on<LoadColumnsEvent>(_onLoadColumnsEvent);
    on<ColumnsUpdatedEvent>(_onColumnsUpdatedEvent);
    on<CreateColumnEvent>(_onCreateColumnEvent);
  }

  _onLoadColumnsEvent(
    LoadColumnsEvent event,
    Emitter<ColumnsState> emit,
  ) {
    _columnsSubscription = _columnsStream.listen((snapshot) {
      statusList = snapshot;
      add(ColumnsUpdatedEvent(snapshot));
    });
  }

  _onColumnsUpdatedEvent(
    ColumnsUpdatedEvent event,
    Emitter<ColumnsState> emit,
  ) {
    emit(ColumnLoadedState(event.columns));
  }

  _onCreateColumnEvent(CreateColumnEvent event, Emitter<ColumnsState> emit) {
    ColumnDataSource.createColumn(ColumnEntity(title: 'test7', index: 2));
  }

  @override
  Future<void> close() {
    _columnsSubscription.cancel();
    return super.close();
  }
}
