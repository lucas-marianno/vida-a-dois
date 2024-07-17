import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/data/remote/column_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/column_entity.dart';

//CRUD
class ColumnRepository {
  final BuildContext context;

  ColumnRepository(this.context);

  void createColumn() {
    ColumnEntity mockColumn = ColumnEntity(title: 'test7', index: 2);

    ColumnDataSource.createColumn(mockColumn);
  }

  void updateColumn() {}

  void deleteColumn(ColumnEntity column) {
    //TODO: implement deleteColumn

    // prompt user if they are sure

    // delete all tasks marked with column status

    // delete column itself
  }
}
