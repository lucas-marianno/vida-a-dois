import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/data/remote/board_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/repository/board_repository.dart';

part 'board_event.dart';
part 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardsState> {
  BoardBloc() : super(BoardLoadingState()) {
    on<BoardInitialEvent>(_onBoardInitialEvent);
    on<LoadBoardsEvent>(_onLoadBoardsEvent);
    on<BoardsUpdatedEvent>(_onBoardsUpdatedEvent);
    on<CreateBoardEvent>(_onCreateBoardEvent);
    on<RenameBoardEvent>(_onRenameBoardEvent);
    on<EditBoardEvent>(_onEditBoardEvent);
    on<DeleteBoardEvent>(_onDeleteBoardEvent);
    on<HandleBoardException>(_onHandleBoardException);
  }

  late List<BoardEntity> _statusList;
  late final BuildContext _context;
  late final _boardsStream = BoardDataSource.readBoards;
  late final StreamSubscription _boardSubscription;
  late final BoardRepository _boardRepo;

  List<BoardEntity> get statusList => _statusList;

  _onBoardInitialEvent(
    BoardInitialEvent event,
    Emitter<BoardsState> emit,
  ) {
    _context = event.context;
    _boardRepo = BoardRepository(_context);
    add(LoadBoardsEvent());
  }

  _onLoadBoardsEvent(
    LoadBoardsEvent event,
    Emitter<BoardsState> emit,
  ) {
    _boardSubscription = _boardsStream.listen((snapshot) {
      _statusList = snapshot;
      add(BoardsUpdatedEvent(snapshot));
    });
  }

  _onBoardsUpdatedEvent(
    BoardsUpdatedEvent event,
    Emitter<BoardsState> emit,
  ) {
    emit(BoardLoadedState(event.boards));
  }

  _onCreateBoardEvent(
    CreateBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    try {
      await _boardRepo.createBoard();
    } catch (e) {
      throw UnimplementedError(
          "$e: \n${e.toString()} \n\n Implement error handling");
    }
  }

  _onRenameBoardEvent(
    RenameBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    await BoardDataSource.updateBoardTitle(
      event.board,
      event.newBoardTitle,
    );
  }

  _onEditBoardEvent(
    EditBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    try {
      await _boardRepo.updateBoard(event.board);
    } catch (e) {
      throw UnimplementedError(
          "$e: \n${e.toString()} \n\n Implement error handling");
    }
  }

  _onDeleteBoardEvent(
    DeleteBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    try {
      await _boardRepo.deleteBoard(event.board);
    } catch (e) {
      throw UnimplementedError(
          "$e: \n${e.toString()} \n\n Implement error handling");
    }
  }

  _onHandleBoardException(
    HandleBoardException event,
    Emitter<BoardsState> emit,
  ) async {
    //TODO: finish implementing this
    throw UnimplementedError();
  }

  @override
  Future<void> close() {
    _boardSubscription.cancel();
    return super.close();
  }
}
