// ignore_for_file: avoid_print

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
  late StreamSubscription _boardSubscription;
  final _boardsStream = BoardDataSource.readBoards;
  late final BuildContext _context;
  late final BoardRepository _boardRepo;

  List<BoardEntity> get statusList => _statusList;

  _onBoardInitialEvent(
    BoardInitialEvent event,
    Emitter<BoardsState> emit,
  ) {
    print(event);
    try {
      _context = event.context;
      _boardRepo = BoardRepository(_context);
      add(LoadBoardsEvent());
    } catch (e) {
      add(HandleBoardException(error: e, errorMessage: e.toString()));
    }
  }

  _onLoadBoardsEvent(
    LoadBoardsEvent event,
    Emitter<BoardsState> emit,
  ) {
    print(event);
    print('a');
    _boardSubscription = _boardsStream.listen(
      (snapshot) {
        print('boardStream');
        _statusList = snapshot;
        add(BoardsUpdatedEvent(snapshot));
      },
      onError: (e) {
        add(HandleBoardException(
          error: e,
          errorMessage: e.toString(),
        ));
      },
      onDone: () {
        print('done');
      },
      cancelOnError: true,
    );
  }

  _onBoardsUpdatedEvent(
    BoardsUpdatedEvent event,
    Emitter<BoardsState> emit,
  ) {
    print(event);
    emit(BoardLoadedState(event.boards));
  }

  _onCreateBoardEvent(
    CreateBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    print(event);
    try {
      await _boardRepo.createBoard();
    } catch (e) {
      add(HandleBoardException(error: e, errorMessage: e.toString()));
    }
  }

  _onRenameBoardEvent(
    RenameBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    print(event);
    try {
      await BoardDataSource.updateBoardTitle(
        event.board,
        event.newBoardTitle,
      );
    } catch (e) {
      add(HandleBoardException(error: e, errorMessage: e.toString()));
    }
  }

  _onEditBoardEvent(
    EditBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    print(event);
    try {
      await _boardRepo.updateBoard(event.board);
    } catch (e) {
      add(HandleBoardException(error: e, errorMessage: e.toString()));
    }
  }

  _onDeleteBoardEvent(
    DeleteBoardEvent event,
    Emitter<BoardsState> emit,
  ) async {
    print(event);
    try {
      await _boardRepo.deleteBoard(event.board);
    } catch (e) {
      add(HandleBoardException(error: e, errorMessage: e.toString()));
    }
  }

  _onHandleBoardException(
    HandleBoardException event,
    Emitter<BoardsState> emit,
  ) async {
    print(event);
    print("An error has ocurred--------------------------------------------- \n"
        "\n"
        "${event.error.runtimeType}"
        "\n"
        "${event.errorMessage}\n"
        "----------------------------------------------------------------- \n");

    await showDialog(
      context: _context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Algo de errado não está certo!'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('${event.error.runtimeType}'),
            const SizedBox(height: 10),
            Text(event.errorMessage),
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
    // emit(BoardErrorState(
    //   error: event.error,
    //   event.errorMessage,
    // ));
  }

  @override
  Future<void> close() {
    print('BoardBloc close');
    _boardSubscription.cancel();
    return super.close();
  }
}
