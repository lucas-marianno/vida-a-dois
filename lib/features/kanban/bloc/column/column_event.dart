part of 'column_bloc.dart';

sealed class ColumnEvent extends Equatable {
  const ColumnEvent();

  @override
  List<Object> get props => [];
}

class LoadColumnEvent extends ColumnEvent {}

class ColumnsUpdatedEvent extends ColumnEvent {
  final List<ColumnEntity> columns;

  const ColumnsUpdatedEvent(this.columns);

  @override
  List<Object> get props => [columns];
}
