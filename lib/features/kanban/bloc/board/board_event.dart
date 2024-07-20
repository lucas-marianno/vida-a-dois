part of 'board_bloc.dart';

sealed class BoardEvent extends Equatable {
  const BoardEvent();

  @override
  List<Object> get props => [];
}

final class BoardInitialEvent extends BoardEvent {
  final BuildContext context;

  const BoardInitialEvent(this.context);

  @override
  List<Object> get props => [context];
}

final class LoadBoardsEvent extends BoardEvent {}

final class BoardStreamDataUpdate extends BoardEvent {
  final List<BoardEntity> boards;

  const BoardStreamDataUpdate(this.boards);

  @override
  List<Object> get props => [boards];
}

final class CreateBoardEvent extends BoardEvent {}

final class RenameBoardEvent extends BoardEvent {
  final BoardEntity board;
  final String newBoardTitle;

  const RenameBoardEvent(this.board, this.newBoardTitle);

  @override
  List<Object> get props => [newBoardTitle];
}

final class EditBoardEvent extends BoardEvent {
  final BoardEntity board;

  const EditBoardEvent(this.board);

  @override
  List<Object> get props => [board];
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
