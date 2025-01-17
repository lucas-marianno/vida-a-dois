import 'package:vida_a_dois/features/kanban/data/data_sources/board_data_source.dart';
import 'package:vida_a_dois/features/kanban/data/models/board_model.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/board_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/board_repository.dart';

class BoardRepositoryImpl extends BoardRepository {
  final BoardDataSource boardDataSource;

  BoardRepositoryImpl(this.boardDataSource);

  @override
  Future<List<Board>> getBoards() async {
    return (await boardDataSource.getBoards())
        .map((e) => e.toEntity())
        .toList();
  }

  @override
  Stream<List<Board>> readBoards() {
    return boardDataSource.readBoards().map(
          (list) => list.map((model) => model.toEntity()).toList(),
        );
  }

  @override
  Future<void> updateBoards(List<Board> boardsList) async {
    List<BoardModel> boardModelList = [];
    for (Board board in boardsList) {
      boardModelList.add(BoardModel.fromEntity(board));
    }
    await boardDataSource.updateBoards(boardModelList);
  }
}
