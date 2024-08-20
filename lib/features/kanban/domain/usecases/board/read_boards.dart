import 'package:vida_a_dois/features/kanban/domain/entities/board_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/board_repository.dart';

class ReadBoardsUseCase {
  final BoardRepository boardRepository;

  ReadBoardsUseCase(this.boardRepository);

  Stream<List<Board>> call() => boardRepository.readBoards();
}
