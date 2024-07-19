part of 'board_bloc.dart';

sealed class BoardsState extends Equatable {
  const BoardsState();

  @override
  List<Object> get props => [];
}

final class BoardLoadingState extends BoardsState {}

final class BoardLoadedState extends BoardsState {
  final List<BoardEntity> boards;

  const BoardLoadedState(this.boards);

  @override
  List<Object> get props => [boards];
}

final class BoardErrorState extends BoardsState {
  final String error;

  const BoardErrorState(this.error);

  @override
  List<Object> get props => [error];
}
