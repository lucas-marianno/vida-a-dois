part of 'board_data_source.dart';

class _BoardDataSourceException implements Exception {
  final String? message;

  _BoardDataSourceException(this.message);

  @override
  String toString() => message ?? 'BoardDataSourceException!';
}
