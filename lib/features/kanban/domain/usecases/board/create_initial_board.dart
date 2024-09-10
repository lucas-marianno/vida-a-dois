import 'package:vida_a_dois/features/kanban/domain/repository/board_repository.dart';

class CreateInitialBoardUseCase {
  final BoardRepository boardRepository;
  CreateInitialBoardUseCase(this.boardRepository);

  Future<void> call() async => await boardRepository.updateBoards([]);
}
