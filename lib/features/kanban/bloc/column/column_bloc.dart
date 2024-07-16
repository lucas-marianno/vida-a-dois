import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban/features/kanban/data/remote/firestore_service.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';

part 'column_event.dart';
part 'column_state.dart';

class ColumnsBloc extends Bloc<ColumnsEvent, ColumnsState> {
  static List<ColumnEntity> statusList = [];
  final _columnsStream = FirestoreService.getColumnsStream();
  late final StreamSubscription _columnsSubscription;

  ColumnsBloc() : super(ColumnLoadingState()) {
    on<LoadColumnsEvent>(_onLoadColumnsEvent);
    on<ColumnsUpdatedEvent>(_onColumnsUpdatedEvent);
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

  @override
  Future<void> close() {
    _columnsSubscription.cancel();
    return super.close();
  }
}
