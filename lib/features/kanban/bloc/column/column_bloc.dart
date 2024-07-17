import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/data/remote/column_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';
import 'package:kanban/features/kanban/domain/repository/column_repository.dart';

part 'column_event.dart';
part 'column_state.dart';

// TODO: Implement columns CRUD
class ColumnsBloc extends Bloc<ColumnsEvent, ColumnsState> {
  static List<ColumnEntity> statusList = [];
  final _columnsStream = ColumnDataSource.readColumns;
  late final StreamSubscription _columnsSubscription;
  late final ColumnRepository columnRepo;

  ColumnsBloc() : super(ColumnLoadingState()) {
    on<ColumnsInitialEvent>(_onColumnsInitialEvent);
    on<LoadColumnsEvent>(_onLoadColumnsEvent);
    on<ColumnsUpdatedEvent>(_onColumnsUpdatedEvent);
    on<CreateColumnEvent>(_onCreateColumnEvent);
    on<RenameColumnEvent>(_onRenameColumnEvent);
    on<DeleteColumnEvent>(_onDeleteColumnEvent);
  }

  _onColumnsInitialEvent(
    ColumnsInitialEvent event,
    Emitter<ColumnsState> emit,
  ) {
    columnRepo = ColumnRepository(event.context);
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
      await columnRepo.createColumn();
    } catch (e) {
      emit(ColumnErrorState(e.toString()));
    }
  }

  _onRenameColumnEvent(
    RenameColumnEvent event,
    Emitter<ColumnsState> emit,
  ) async {
    try {
      await columnRepo.renameColumn(event.column);
    } catch (e) {
      emit(ColumnErrorState(e.toString()));
    }
  }

  _onDeleteColumnEvent(
    DeleteColumnEvent event,
    Emitter<ColumnsState> emit,
  ) async {
    try {
      await columnRepo.deleteColumn(event.column);
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
