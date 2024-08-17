abstract class KanbanException implements Exception {
  final String? message;

  KanbanException([this.message]);
}

final class NameNotUniqueException extends KanbanException {
  NameNotUniqueException([super.message]);
}

final class EmptyNameException extends KanbanException {
  EmptyNameException([super.message]);
}

final class InvalidBoardIndex extends KanbanException {
  InvalidBoardIndex([super.message]);
}
