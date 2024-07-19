part of 'board_bloc.dart';

sealed class BoardEvent extends Equatable {
  const BoardEvent();

  @override
  List<Object> get props => [];
}

class BoardInitialEvent extends BoardEvent {
  final BuildContext context;

  const BoardInitialEvent(this.context);

  @override
  List<Object> get props => [context];
}

class LoadBoardsEvent extends BoardEvent {}

class BoardsUpdatedEvent extends BoardEvent {
  final List<BoardEntity> boards;

  const BoardsUpdatedEvent(this.boards);

  @override
  List<Object> get props => [boards];
}

class CreateBoardEvent extends BoardEvent {}

class RenameBoardEvent extends BoardEvent {
  final BoardEntity board;
  final String newBoardTitle;

  const RenameBoardEvent(this.board, this.newBoardTitle);

  @override
  List<Object> get props => [newBoardTitle];
}

class EditBoardEvent extends BoardEvent {
  final BoardEntity board;

  const EditBoardEvent(this.board);

  @override
  List<Object> get props => [board];
}

class DeleteBoardEvent extends BoardEvent {
  final BoardEntity board;

  const DeleteBoardEvent(this.board);

  @override
  List<Object> get props => [board];
}

class HandleBoardException extends BoardEvent {
  final String errorTitle;
  final String errorMessage;

  const HandleBoardException({
    this.errorTitle = '',
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorTitle, errorMessage];
}
