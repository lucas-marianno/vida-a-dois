part of 'column_data_source.dart';

class _ColumnDataSourceException implements Exception {
  final String? message;

  _ColumnDataSourceException(this.message);

  @override
  String toString() => message ?? 'ColumnDataSourceException!';
}
