import 'package:kanban/features/kanban/domain/entities/board_entity.dart';

//CRUD
abstract class BoardRepository {
  Future<void> createBoard(Board newBoard);

  Stream<List<Board>> get readBoards;

  Future<void> updateBoard(Board oldBoard, Board newBoard);

  Future<void> updateBoardTitle(Board board, String newTitle);

  Future<void> deleteBoard(Board board);
}
