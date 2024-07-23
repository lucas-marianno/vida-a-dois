part of 'board_bloc.dart';

sealed class BoardEvent extends Equatable {
  const BoardEvent();

  @override
  List<Object> get props => [];
}

final class BoardInitialEvent extends BoardEvent {}

final class BoardStreamDataUpdate extends BoardEvent {}

final class CreateBoardEvent extends BoardEvent {
  final BoardEntity newBoard;

  const CreateBoardEvent(this.newBoard);

  @override
  List<Object> get props => [newBoard];
}

final class RenameBoardEvent extends BoardEvent {
  final BoardEntity board;
  final String newBoardTitle;

  const RenameBoardEvent(this.board, this.newBoardTitle);

  @override
  List<Object> get props => [newBoardTitle];
}

final class EditBoardEvent extends BoardEvent {
  final BoardEntity oldBoard;
  final BoardEntity newBoard;

  const EditBoardEvent(this.oldBoard, this.newBoard);

  @override
  List<Object> get props => [oldBoard, newBoard];
}

final class DeleteBoardEvent extends BoardEvent {
  final BoardEntity board;

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
