import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanban/features/kanban/core/constants/firebase/firebase_constants.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';

/// [ColumnDataSource] provides CRUD functionality.
abstract class ColumnDataSource {
  static final _firestore = FireStoreConstants.mockCollectionReference;

  static final DocumentReference _columnsReference = _firestore.doc('columns');

  static final Stream<List<String>> columnStream = _firestore
      .doc('columns')
      .snapshots()
      .map((e) => List<String>.from(e['status']));

  static void createColumn(ColumnEntity? column) async {
    if (column == null) return;
    final List<String> currentColumns =
        List<String>.from((await _columnsReference.get())['status']);

    if (column.index >= currentColumns.length) {
      currentColumns.add(column.title);
    } else {
      currentColumns.insert(column.index, column.title);
    }

    await _columnsReference.set({'status': currentColumns});
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
}
