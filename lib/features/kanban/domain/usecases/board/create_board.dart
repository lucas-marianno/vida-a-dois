import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/exceptions/kanban_exception.dart';
import 'package:kanban/features/kanban/domain/repository/board_repository.dart';

class CreateBoardUseCase {
  CreateBoardUseCase(this.boardRepository);

  final BoardRepository boardRepository;
  late List<Board> currentBoards;

  Future<void> call(Board board) async {
    if (board.title.isEmpty) throw EmptyNameException();

    currentBoards = await boardRepository.getBoards();

    _checkIfIndexIsValid(board.index);

    _checkIfNameIsUnique(board.title);

    currentBoards.insert(board.index, board);

    await boardRepository.updateBoards(currentBoards);
  }

  void _checkIfIndexIsValid(int index) {
    if (index < 0 || index > currentBoards.length) throw InvalidBoardIndex();
  }

  void _checkIfNameIsUnique(String newName) {
    if (currentBoards.map((e) => e.title).contains(newName)) {
      throw NameNotUniqueException();
    }
  }
}
