import 'package:kanban/features/kanban/domain/exceptions/kanban_exception.dart';

abstract class BoardException extends KanbanException {}

final class NameNotUniqueException extends BoardException {}
