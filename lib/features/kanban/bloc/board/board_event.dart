part of 'board_bloc.dart';

sealed class BoardEvent extends Equatable {
  const BoardEvent();

  @override
  List<Object> get props => [];
}

final class BoardInitialEvent extends BoardEvent {}

final class BoardsListUpdate extends BoardEvent {
  final List<Board> boardsList;

  const BoardsListUpdate(this.boardsList);

  @override
  // TODO: implement props
  List<Object> get props => [boardsList];
}

final class CreateBoardEvent extends BoardEvent {
  final Board newBoard;

  const CreateBoardEvent(this.newBoard);

  @override
  List<Object> get props => [newBoard];
}

final class RenameBoardEvent extends BoardEvent {
  final Board board;
  final String newBoardTitle;

  const RenameBoardEvent(this.board, this.newBoardTitle);

  @override
  List<Object> get props => [newBoardTitle];
}

final class EditBoardEvent extends BoardEvent {
  final Board oldBoard;
  final Board newBoard;

  const EditBoardEvent(this.oldBoard, this.newBoard);

  @override
  List<Object> get props => [oldBoard, newBoard];
}

final class DeleteBoardEvent extends BoardEvent {
  final Board board;

  const DeleteBoardEvent(this.board);

  @override
  List<Object> get props => [board];
}

final class HandleBoardException extends BoardEvent {
  final Object error;

  const HandleBoardException({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

final class ReloadBoards extends BoardEvent {}
