import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban/core/util/logger/logger.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/usecases/board/create_board.dart';
import 'package:kanban/features/kanban/domain/usecases/board/delete_board.dart';
import 'package:kanban/features/kanban/domain/usecases/board/read_boards.dart';
import 'package:kanban/features/kanban/domain/usecases/board/rename_board.dart';
import 'package:kanban/features/kanban/domain/usecases/board/update_board_index.dart';

part 'board_event.dart';
part 'board_state.dart';

final class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final RenameBoardUseCase renameBoard;
  final CreateBoardUseCase createBoard;
  final ReadBoardsUseCase readBoards;
  final UpdateBoardIndexUseCase updateBoardIndex;
  final DeleteBoardUseCase deleteBoard;

  List<Board> _statusList = [];
  late StreamSubscription _boardSubscription;

  BoardBloc({
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
    on<HandleBoardException>(_onHandleBoardException);
    on<ReloadBoards>(_onReloadBoards);

    Log.initializing(BoardBloc);
    add(BoardInitialEvent());
  }

  _onBoardInitialEvent(
    BoardInitialEvent event,
    Emitter<BoardState> emit,
  ) {
    Log.trace('$BoardBloc $BoardInitialEvent \n $event');
    emit(BoardLoadingState());

    try {
      _boardSubscription = readBoards().listen(
        (snapshot) => add(BoardsListUpdate(snapshot)),
        onError: (e) => add(HandleBoardException(error: e)),
        onDone: () => Log.debug('_boardSubscription is `done`!'),
        cancelOnError: true,
      );
    } catch (e) {
      add(HandleBoardException(error: e));
    }
  }

  /// Similar to [BoardsListUpdate].
  /// Except it will emit a [BoardLoadedState] even if there were no changes
  /// to [_statusList].
  ///
  /// [ReloadBoards] emits a [BoardLoadedState]
  /// with the last known `List<ColumnEntity>`.
  ///
  /// This event should only be called after an error has been properly
  /// handled by [HandleBoardException] event.
  _onReloadBoards(_, Emitter<BoardState> emit) {
    Log.info("$BoardBloc $ReloadBoards");
    emit(BoardLoadedState(_statusList));
  }

  _onBoardStreamDataUpdate(
      BoardsListUpdate event, Emitter<BoardState> emit) async {
    if (event.boardsList == _statusList) return;

    _statusList = event.boardsList;

    Log.trace('$BoardBloc $BoardsListUpdate\n$_statusList');
    emit(BoardLoadedState(_statusList));
  }

  _onCreateBoardEvent(
    CreateBoardEvent event,
    Emitter<BoardState> emit,
  ) async {
    Log.trace('$BoardBloc $CreateBoardEvent \n $event');
    try {
      await createBoard(event.newBoard);
    } catch (e) {
      add(HandleBoardException(error: e));
    }
  }

  _onRenameBoardEvent(
    RenameBoardEvent event,
    Emitter<BoardState> emit,
  ) async {
    Log.info('$BoardBloc $RenameBoardEvent \n $event');

    try {
      await renameBoard(event.board, event.newBoardTitle);
    } catch (e) {
      add(HandleBoardException(error: e));
    }
  }

  _onEditBoardEvent(
    EditBoardEvent event,
    Emitter<BoardState> emit,
  ) async {
    emit(BoardLoadingState());
    Log.trace('$BoardBloc $EditBoardEvent \n $event');
    final oldB = event.oldBoard;
    final newB = event.newBoard;
    try {
      if (oldB.title != newB.title) renameBoard(oldB, newB.title);
      if (oldB.index != newB.index) updateBoardIndex(oldB, newB.index);
    } catch (e) {
      add(HandleBoardException(error: e));
    }
  }

  _onDeleteBoardEvent(
    DeleteBoardEvent event,
    Emitter<BoardState> emit,
  ) async {
    Log.trace('$BoardBloc $DeleteBoardEvent \n $event');
    try {
      await deleteBoard(event.board);
    } catch (e) {
      add(HandleBoardException(error: e));
    }
  }

  _onHandleBoardException(
    HandleBoardException event,
    Emitter<BoardState> emit,
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
