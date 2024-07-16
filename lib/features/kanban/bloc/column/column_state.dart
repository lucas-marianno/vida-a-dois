part of 'column_bloc.dart';

sealed class ColumnState extends Equatable {
  const ColumnState();

  @override
  List<Object> get props => [];
}

final class ColumnLoadingState extends ColumnState {}

final class ColumnLoadedState extends ColumnState {
  final List<ColumnEntity> columns;

  const ColumnLoadedState(this.columns);

  @override
  List<Object> get props => [columns];
}

final class ColumnErrorState extends ColumnState {
  final String error;

  const ColumnErrorState(this.error);

  @override
  List<Object> get props => [error];
}
