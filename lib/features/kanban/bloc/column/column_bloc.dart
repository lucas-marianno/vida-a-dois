import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/data/remote/column_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';
import 'package:kanban/features/kanban/domain/repository/column_repository.dart';

part 'column_event.dart';
part 'column_state.dart';

class ColumnsBloc extends Bloc<ColumnsEvent, ColumnsState> {
  /// Do not use [statusList]!
  ///
  /// A new way to quickly access the latest statusList without new API calls
  /// must be implemented.
  @Deprecated("statusList should not be used!")
  static List<ColumnEntity> statusList = [];

  final _columnsStream = ColumnDataSource.readColumns;
  late final StreamSubscription _columnsSubscription;
  late final ColumnRepository _columnRepo;

  ColumnsBloc() : super(ColumnLoadingState()) {
    on<ColumnsInitialEvent>(_onColumnsInitialEvent);
    on<LoadColumnsEvent>(_onLoadColumnsEvent);
    on<ColumnsUpdatedEvent>(_onColumnsUpdatedEvent);
    on<CreateColumnEvent>(_onCreateColumnEvent);
    on<RenameColumnEvent>(_onRenameColumnEvent);
    on<DeleteColumnEvent>(_onDeleteColumnEvent);
    on<HandleColumnsException>(_onHandleColumnsException);
  }

  _onColumnsInitialEvent(
    ColumnsInitialEvent event,
    Emitter<ColumnsState> emit,
  ) {
    _columnRepo = ColumnRepository(event.context);
    add(LoadColumnsEvent());
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

  _onCreateColumnEvent(
    CreateColumnEvent event,
    Emitter<ColumnsState> emit,
  ) async {
    try {
      await _columnRepo.createColumn();
    } catch (e) {
      throw UnimplementedError(
          "$e: \n${e.toString()} \n\n Implement error handling");
    }
  }

  _onRenameColumnEvent(
    RenameColumnEvent event,
    Emitter<ColumnsState> emit,
  ) async {
    try {
      await _columnRepo.updateColumn(event.column);
    } catch (e) {
      throw UnimplementedError(
          "$e: \n${e.toString()} \n\n Implement error handling");
    }
  }

  _onDeleteColumnEvent(
    DeleteColumnEvent event,
    Emitter<ColumnsState> emit,
  ) async {
    try {
      await _columnRepo.deleteColumn(event.column);
    } catch (e) {
      throw UnimplementedError(
          "$e: \n${e.toString()} \n\n Implement error handling");
    }
  }

  _onHandleColumnsException(
    HandleColumnsException event,
    Emitter<ColumnsState> emit,
  ) async {
    //TODO: finish implementing this
    throw UnimplementedError();
  }

  @override
  Future<void> close() {
    _columnsSubscription.cancel();
    return super.close();
  }
}
