import 'package:kanban/src/domain/entities/board_entity.dart';

abstract class BoardRepository {
  Future<List<Board>> getBoards();
  Stream<List<Board>> readBoards();
  Future<void> updateBoards(List<Board> boardsList);
}
