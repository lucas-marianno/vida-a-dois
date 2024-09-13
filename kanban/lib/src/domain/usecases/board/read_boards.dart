import 'package:kanban/src/domain/entities/board_entity.dart';
import 'package:kanban/src/domain/repository/board_repository.dart';

class ReadBoardsUseCase {
  final BoardRepository boardRepository;

  ReadBoardsUseCase(this.boardRepository);

  Stream<List<Board>> call() => boardRepository.readBoards();
}
