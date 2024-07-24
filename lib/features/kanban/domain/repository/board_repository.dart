import 'package:kanban/features/kanban/data/remote/board_data_source.dart';
import 'package:kanban/features/kanban/data/remote/task_data_source.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';

//CRUD
class BoardRepository {
  static Future<void> createBoard(Board newBoard) async {
    if (newBoard.title.isEmpty) return;

    await BoardDataSource.createBoard(newBoard);
  }

  static Stream<List<Board>> get readBoards => BoardDataSource.readBoards;

  static Future<void> updateBoard(
    Board oldBoard,
    Board newBoard,
  ) async {
    await BoardDataSource.updateBoard(oldBoard, newBoard);
  }

  static Future<void> updateBoardTitle(
    Board board,
    String newTitle,
  ) async {
    await BoardDataSource.updateBoardTitle(board, newTitle);
  }

  static Future<void> deleteBoard(Board board) async {
    await Future.wait([
      BoardDataSource.deleteBoard(board),
      TaskDataSource.deleteAllTasksWithStatus(board.title),
    ]);
  }
}
