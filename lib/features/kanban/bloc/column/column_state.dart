part of 'column_bloc.dart';

sealed class ColumnsState extends Equatable {
  const ColumnsState();

  @override
  List<Object> get props => [];
}

final class ColumnLoadingState extends ColumnsState {}

final class ColumnLoadedState extends ColumnsState {
  final List<ColumnEntity> columns;

  const ColumnLoadedState(this.columns);

  @override
  List<Object> get props => [columns];
}

final class ColumnErrorState extends ColumnsState {
  final String error;

  const ColumnErrorState(this.error);

  @override
  List<Object> get props => [error];
}
