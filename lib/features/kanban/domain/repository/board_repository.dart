import 'package:kanban/features/kanban/domain/entities/board_entity.dart';

//CRUD
abstract class BoardRepository {
  Future<void> createBoard(BoardEntity newBoard);

  Stream<List<BoardEntity>> get readBoards;

  Future<void> updateBoard(BoardEntity oldBoard, BoardEntity newBoard);

  Future<void> updateBoardTitle(BoardEntity board, String newTitle);

  Future<void> deleteBoard(BoardEntity board);
}
