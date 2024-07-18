part of 'column_bloc.dart';

sealed class ColumnsEvent extends Equatable {
  const ColumnsEvent();

  @override
  List<Object> get props => [];
}

class ColumnsInitialEvent extends ColumnsEvent {
  final BuildContext context;

  const ColumnsInitialEvent(this.context);

  @override
  List<Object> get props => [context];
}

class LoadColumnsEvent extends ColumnsEvent {}

class ColumnsUpdatedEvent extends ColumnsEvent {
  final List<ColumnEntity> columns;

  const ColumnsUpdatedEvent(this.columns);

  @override
  List<Object> get props => [columns];
}

class CreateColumnEvent extends ColumnsEvent {}

class RenameColumnEvent extends ColumnsEvent {
  final ColumnEntity column;
  final String newColumnTitle;

  const RenameColumnEvent(this.column, this.newColumnTitle);

  @override
  List<Object> get props => [newColumnTitle];
}

class EditColumnEvent extends ColumnsEvent {
  final ColumnEntity column;

  const EditColumnEvent(this.column);

  @override
  List<Object> get props => [column];
}

class DeleteColumnEvent extends ColumnsEvent {
  final ColumnEntity column;

  const DeleteColumnEvent(this.column);

  @override
  List<Object> get props => [column];
}

class HandleColumnsException extends ColumnsEvent {
  final String errorTitle;
  final String errorMessage;

  const HandleColumnsException({
    this.errorTitle = '',
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorTitle, errorMessage];
}
