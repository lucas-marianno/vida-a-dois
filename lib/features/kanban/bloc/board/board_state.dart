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
  final Object error;
  final String errorTitle;
  final String errorMessage;

  const BoardErrorState(
    this.errorMessage, {
    this.error = '',
    this.errorTitle = '',
  });

  @override
  List<Object> get props => [errorMessage, error, errorTitle];
}
