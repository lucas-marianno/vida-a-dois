part of 'column_bloc.dart';

sealed class ColumnsEvent extends Equatable {
  const ColumnsEvent();

  @override
  List<Object> get props => [];
}

class LoadColumnsEvent extends ColumnsEvent {}

class ColumnsUpdatedEvent extends ColumnsEvent {
  final List<ColumnEntity> columns;

  const ColumnsUpdatedEvent(this.columns);

  @override
  List<Object> get props => [columns];
}
