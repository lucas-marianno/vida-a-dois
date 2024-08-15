part of 'board_bloc.dart';

sealed class BoardState extends Equatable {
  const BoardState();

  @override
  List<Object> get props => [];
}

final class BoardLoadingState extends BoardState {}

final class BoardLoadedState extends BoardState {
  final List<BoardEntity> boards;

  const BoardLoadedState(this.boards);

  @override
  List<Object> get props => [boards];
}

final class BoardErrorState extends BoardState {
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
