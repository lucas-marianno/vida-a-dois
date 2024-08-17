import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/exceptions/kanban_exception.dart';
import 'package:kanban/features/kanban/domain/repository/board_repository.dart';

class UpdateBoardIndexUseCase {
  UpdateBoardIndexUseCase(this.boardRepository);

  final BoardRepository boardRepository;
  late List<Board> currentBoards;

  Future<void> call(Board board, int newIndex) async {
    if (board.index == newIndex) return;

    currentBoards = await boardRepository.getBoards();

    _checkIfIndexIsValid(newIndex);

    // TODO: get rid of 'mAgIcC'
    // i dont remember why this is here, evaluate this later
    newIndex = board.index <= newIndex ? newIndex - 1 : newIndex;

    final oldIndex = board.index;

    currentBoards.removeAt(oldIndex);

    board.index = newIndex;

    currentBoards.insert(newIndex, board);

    await boardRepository.updateBoards(currentBoards);
  }

  void _checkIfIndexIsValid(int index) {
    if (index < 0 || index > currentBoards.length) throw InvalidBoardIndex();
  }
}
