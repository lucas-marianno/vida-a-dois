import 'package:kanban/src/domain/repository/board_repository.dart';

class CreateInitialBoardUseCase {
  final BoardRepository boardRepository;
  CreateInitialBoardUseCase(this.boardRepository);

  Future<void> call() async => await boardRepository.updateBoards([]);
}
