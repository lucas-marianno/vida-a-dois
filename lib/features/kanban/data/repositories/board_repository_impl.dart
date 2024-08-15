import 'package:kanban/features/kanban/data/data_sources/board_data_source.dart';
import 'package:kanban/features/kanban/data/data_sources/task_data_source.dart';
import 'package:kanban/features/kanban/data/models/board_model.dart';
import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/repository/board_repository.dart';

class BoardRepositoryImpl extends BoardRepository {
  final BoardDataSource boardDataSource;
  final TaskDataSource taskDataSource;

  BoardRepositoryImpl({
    required this.taskDataSource,
    required this.boardDataSource,
  });

  @override
  Future<void> createBoard(BoardEntity newBoard) async {
    if (newBoard.title.isEmpty) return;

    await boardDataSource.createBoard(BoardModel.fromEntity(newBoard));
  }

  @override
  Stream<List<BoardEntity>> get readBoards => boardDataSource.readBoards;

  @override
  Future<void> updateBoard(BoardEntity oldBoard, BoardEntity newBoard) async {
    await boardDataSource.updateBoard(
      BoardModel.fromEntity(oldBoard),
      BoardModel.fromEntity(newBoard),
    );
  }

  @override
  Future<void> updateBoardTitle(BoardEntity board, String newTitle) async {
    await boardDataSource.updateBoardTitle(
      BoardModel.fromEntity(board),
      newTitle,
    );
  }

  @override
  Future<void> deleteBoard(BoardEntity board) async {
    await Future.wait([
      boardDataSource.deleteBoard(BoardModel.fromEntity(board)),
      taskDataSource.deleteAllTasksWithStatus(board.title),
    ]);
  }
}
