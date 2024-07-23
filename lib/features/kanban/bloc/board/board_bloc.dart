import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban/core/util/logger/logger.dart';
import 'package:kanban/features/kanban/data/remote/board_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/repository/board_repository.dart';

part 'board_event.dart';
part 'board_state.dart';

final class BoardBloc extends Bloc<BoardEvent, BoardsState> {
  BoardBloc() : super(BoardLoadingState()) {
    on<BoardInitialEvent>(_onBoardInitialEvent);
    on<BoardStreamDataUpdate>(_onBoardStreamDataUpdate);
    on<CreateBoardEvent>(_onCreateBoardEvent);
    on<RenameBoardEvent>(_onRenameBoardEvent);
    on<EditBoardEvent>(_onEditBoardEvent);
    on<DeleteBoardEvent>(_onDeleteBoardEvent);
    on<HandleBoardException>(_onHandleBoardException);

    Log.initializing(BoardBloc);
    add(BoardInitialEvent());
  }

  List<BoardEntity> _statusList = [];
  late StreamSubscription _boardSubscription;
  final _boardsStream = BoardDataSource.readBoards;

  List<BoardEntity> get statusList => _statusList;

  _onBoardInitialEvent(
    BoardInitialEvent event,
    Emitter<BoardsState> emit,
  ) {
    emit(BoardLoadingState());
    Log.trace('$BoardBloc $BoardInitialEvent \n $event');

    _boardSubscription = _boardsStream.listen(
      (snapshot) {
        if (snapshot == _statusList) return;

        _statusList = snapshot;
      },
      onError: (e) => add(HandleBoardException(error: e)),
      onDone: () => Log.debug('_boardSubscription is `done`!'),
      cancelOnError: true,
    );

    add(BoardStreamDataUpdate());
  }

  _onBoardStreamDataUpdate(_, Emitter<BoardsState> emit) {
    Log.trace('$BoardBloc $BoardStreamDataUpdate\n$_statusList');
    emit(BoardLoadedState(_statusList));
  }

  _onCreateBoardEvent(
    CreateBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    Log.trace('$BoardBloc $CreateBoardEvent \n $event');
    try {
      await BoardRepository.createBoard(event.newBoard);
    } catch (e) {
      add(HandleBoardException(error: e));
    }
  }

  _onRenameBoardEvent(
    RenameBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    Log.info('$BoardBloc $RenameBoardEvent \n $event');
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
      await BoardRepository.updateBoard(event.oldBoard, event.newBoard);
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
      await BoardRepository.deleteBoard(event.board);
    } catch (e) {
      add(HandleBoardException(error: e));
    }
  }

  _onHandleBoardException(
    HandleBoardException event,
    Emitter<BoardsState> emit,
  ) async {
    final error = event.error;
    Log.error(error.runtimeType, error: error);
    emit(BoardErrorState(error.runtimeType.toString(), error: error));
  }

  @override
  Future<void> close() {
    Log.trace('$BoardBloc close()');
    _boardSubscription.cancel();
    return super.close();
  }
}
