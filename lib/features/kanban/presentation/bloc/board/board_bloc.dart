import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vida_a_dois/core/util/logger/logger.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/board_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/usecases/board_usecases.dart';

part 'board_event.dart';
part 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final RenameBoardUseCase renameBoard;
  final CreateBoardUseCase createBoard;
  final CreateInitialBoardUseCase createInitialBoard;
  final ReadBoardsUseCase readBoards;
  final UpdateBoardIndexUseCase updateBoardIndex;
  final DeleteBoardUseCase deleteBoard;

  List<Board> _statusList = [];
  late StreamSubscription _boardSubscription;

  BoardBloc({
    required this.createInitialBoard,
    required this.createBoard,
    required this.readBoards,
    required this.renameBoard,
    required this.updateBoardIndex,
    required this.deleteBoard,
  }) : super(BoardLoadingState()) {
    on<BoardInitialEvent>(_onBoardInitialEvent);
    on<BoardsListUpdate>(_onBoardStreamDataUpdate);
    on<CreateBoardEvent>(_onCreateBoardEvent);
    on<RenameBoardEvent>(_onRenameBoardEvent);
    on<EditBoardEvent>(_onEditBoardEvent);
    on<DeleteBoardEvent>(_onDeleteBoardEvent);
    on<_BoardException>(_onHandleBoardException);

    add(BoardInitialEvent());
  }

  _onBoardInitialEvent(_, Emitter<BoardState> emit) {
    emit(BoardLoadingState());

    try {
      _boardSubscription = readBoards().listen(
        (snapshot) => add(BoardsListUpdate(snapshot)),
        onError: (e) => add(_BoardException(error: e)),
        onDone: () => logger.debug('_boardSubscription is `done`!'),
      );
    } catch (e) {
      add(_BoardException(error: e));
    }
  }

  _onBoardStreamDataUpdate(
      BoardsListUpdate event, Emitter<BoardState> emit) async {
    if (event.boardsList == _statusList) return;

    _statusList = event.boardsList;

    emit(BoardLoadedState(_statusList));
  }

  _onCreateBoardEvent(CreateBoardEvent event, _) async {
    try {
      await createBoard(event.newBoard);
    } catch (e) {
      add(_BoardException(error: e));
    }
  }

  _onRenameBoardEvent(RenameBoardEvent event, _) async {
    try {
      await renameBoard(event.board, event.newBoardTitle);
    } catch (e) {
      add(_BoardException(error: e));
    }
  }

  _onEditBoardEvent(
    EditBoardEvent event,
    Emitter<BoardState> emit,
  ) async {
    emit(BoardLoadingState());
    final oldB = event.oldBoard;
    final newB = event.newBoard;
    try {
      if (oldB.title != newB.title) renameBoard(oldB, newB.title);
      if (oldB.index != newB.index) updateBoardIndex(oldB, newB.index);
    } catch (e) {
      add(_BoardException(error: e));
    }
  }

  _onDeleteBoardEvent(DeleteBoardEvent event, _) async {
    try {
      await deleteBoard(event.board);
    } catch (e) {
      add(_BoardException(error: e));
    }
  }

  _onHandleBoardException(
    _BoardException event,
    Emitter<BoardState> emit,
  ) async {
    emit(BoardLoadingState());

    final error = event.error;

    if (error is StateError) {
      await createInitialBoard();
      return;
    }

    emit(BoardErrorState(error.runtimeType.toString(), error: error));
    emit(BoardLoadedState(_statusList));
  }

  @override
  void onEvent(BoardEvent event) {
    switch (event) {
      case BoardInitialEvent():
        logger.initializing(BoardBloc);
        break;
      case _BoardException():
        if (event.error is StateError) break;
        logger.info('$BoardBloc $_BoardException', error: event.error);
        break;
      default:
        logger.trace('$BoardBloc ${event.runtimeType} \n $event');
    }

    super.onEvent(event);
  }

  @override
  void onChange(Change<BoardState> change) {
    logger.debug(
      '$BoardBloc ${change.nextState.runtimeType}\n'
      '${change.nextState}',
    );

    super.onChange(change);
  }

  @override
  Future<void> close() {
    logger.trace('$BoardBloc close()');
    _boardSubscription.cancel();
    return super.close();
  }
}
