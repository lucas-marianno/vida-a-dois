import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kanban/core/util/logger/logger.dart';
import 'package:kanban/features/kanban/data/remote/board_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/repository/board_repository.dart';

part 'board_event.dart';
part 'board_state.dart';

final class BoardBloc extends Bloc<BoardEvent, BoardsState> {
  BoardBloc() : super(BoardLoadingState()) {
    on<BoardInitialEvent>(_onBoardInitialEvent);
    on<LoadBoardsEvent>(_onLoadBoardsEvent);
    on<BoardStreamDataUpdate>(_onBoardStreamDataUpdate);
    on<CreateBoardEvent>(_onCreateBoardEvent);
    on<RenameBoardEvent>(_onRenameBoardEvent);
    on<EditBoardEvent>(_onEditBoardEvent);
    on<DeleteBoardEvent>(_onDeleteBoardEvent);
    on<HandleBoardException>(_onHandleBoardException);

    Log.initializing(BoardBloc);
  }

  late List<BoardEntity> _statusList;
  late StreamSubscription _boardSubscription;
  final _boardsStream = BoardDataSource.readBoards;
  late final BuildContext _context;
  late final BoardRepository _boardRepo;

  List<BoardEntity> get statusList => _statusList;

  _onBoardInitialEvent(
    BoardInitialEvent event,
    Emitter<BoardsState> emit,
  ) {
    Log.trace('$BoardBloc $BoardInitialEvent \n $event');
    try {
      _context = event.context;
      _boardRepo = BoardRepository(_context);
      add(LoadBoardsEvent());
    } catch (e) {
      add(HandleBoardException(error: e));
    }
  }

  _onLoadBoardsEvent(
    LoadBoardsEvent event,
    Emitter<BoardsState> emit,
  ) {
    Log.trace('$BoardBloc $LoadBoardsEvent \n $event');

    _boardSubscription = _boardsStream.listen(
      (snapshot) {
        _statusList = snapshot;
        add(BoardStreamDataUpdate(snapshot));
      },
      onError: (e) => add(HandleBoardException(error: e)),
      onDone: () => Log.debug('_boardSubscription is `done`!'),
      cancelOnError: true,
    );
  }

  _onBoardStreamDataUpdate(
    BoardStreamDataUpdate event,
    Emitter<BoardsState> emit,
  ) {
    Log.trace('$BoardBloc $BoardStreamDataUpdate \n $event');
    emit(BoardLoadedState(event.boards));
  }

  _onCreateBoardEvent(
    CreateBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    Log.trace('$BoardBloc $CreateBoardEvent \n $event');
    try {
      await _boardRepo.createBoard();
    } catch (e) {
      add(HandleBoardException(error: e));
    }
  }

  _onRenameBoardEvent(
    RenameBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    Log.trace('$BoardBloc $RenameBoardEvent \n $event');
    try {
      await BoardDataSource.updateBoardTitle(
        event.board,
        event.newBoardTitle,
      );
    } catch (e) {
      add(HandleBoardException(error: e));
    }
  }

  _onEditBoardEvent(
    EditBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    Log.trace('$BoardBloc $EditBoardEvent \n $event');
    try {
      await _boardRepo.updateBoard(event.board);
    } catch (e) {
      add(HandleBoardException(error: e));
    }
  }

  _onDeleteBoardEvent(
    DeleteBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    Log.trace('$BoardBloc $DeleteBoardEvent \n $event');
    try {
      await _boardRepo.deleteBoard(event.board);
    } catch (e) {
      add(HandleBoardException(error: e));
    }
  }

  _onHandleBoardException(
    HandleBoardException event,
    Emitter<BoardsState> emit,
  ) async {
    Log.debug(
      "$BoardBloc $HandleBoardException $event \n"
      " ${event.error.runtimeType}",
    );
    Log.error(event.error.runtimeType, error: event.error);

    await showDialog(
      context: _context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Algo de errado não está certo!'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('${event.error.runtimeType}'),
            const SizedBox(height: 10),
            Text(event.error.toString()),
          ]),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
  }

  @override
  Future<void> close() {
    Log.trace('$BoardBloc close()');
    _boardSubscription.cancel();
    return super.close();
  }
}
