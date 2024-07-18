import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/features/kanban/core/constants/firebase/firebase_constants.dart';
import 'package:kanban/features/kanban/data/remote/task_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';

part 'column_data_source_exception.dart';

/// [ColumnDataSource] provides Firebase integration for CRUD operations
abstract class ColumnDataSource {
  static final _firestore = FireStoreConstants.mockCollectionReference;

  static final DocumentReference _columnsReference = _firestore.doc('columns');

  static Future<void> createColumn(ColumnEntity? column) async {
    if (column == null) return;
    final List<ColumnEntity> columns = await _getColumns;

    if (columns.map((e) => e.title).contains(column.title)) {
      throw _ColumnDataSourceException(
        "As colunas não podem ter nomes repetidos",
      );
    }
    column.index = column.index.clamp(0, columns.length);

    if (column.index >= columns.length) {
      columns.add(column);
    } else {
      columns.insert(column.index, column);
    }
    await _updateColumns(columns);
  }

  static Future<void> updateColumn(
    ColumnEntity column,
    ColumnEntity newColumn,
  ) async {
    if (column.equals(newColumn)) return;

    await _updateColumnTitle(column, newColumn.title);
    await _updateColumnIndex(column..title = newColumn.title, newColumn.index);
  }

  static Future<void> _updateColumnTitle(
    ColumnEntity column,
    String newTitle,
  ) async {
    if (column.title == newTitle) return;

    await TaskDataSource.updateTasksStatusToNewStatus(column.title, newTitle);

    final columns = await _getColumns;
    columns[column.index] = (column..title = newTitle);

    await _updateColumns(columns);
  }

  static Future<void> _updateColumnIndex(
    ColumnEntity column,
    int newIndex,
  ) async {
    if (column.index == newIndex) return;

    newIndex = column.index <= newIndex ? newIndex - 1 : newIndex;

    await deleteColumn(column);
    await createColumn(column..index = newIndex);
  }

  static Future<void> _updateColumns(List<ColumnEntity> columnsList) async {
    final columns = [];
    for (ColumnEntity element in columnsList) {
      columns.add(element.title);
    }

    await _columnsReference.set({'status': columns});
  }

  static Stream<List<ColumnEntity>> get readColumns {
    final stream = _columnsReference.snapshots().map((snapshot) {
      final List<ColumnEntity> a = [];
      for (int i = 0; i < snapshot['status'].length; i++) {
        a.add(ColumnEntity(title: snapshot['status'][i], index: i));
      }
      return a;
    });
    return stream;
  }

  static Future<void> deleteColumn(ColumnEntity column) async {
    final columns = await _getColumns;
    columns.removeWhere((e) => e.title == column.title);
    return _updateColumns(columns);
  }

  static Future<List<ColumnEntity>> get _getColumns async {
    final a = List<String>.from((await _columnsReference.get())['status']);

    return a.map((e) => ColumnEntity(title: e, index: a.indexOf(e))).toList();
  }
}
