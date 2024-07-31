part of 'board_data_source.dart';

abstract class _BoardDataException implements Exception {}

class _NameNotUniqueException extends _BoardDataException {}
