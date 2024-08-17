import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/exceptions/kanban_exception.dart';
import 'package:kanban/features/kanban/domain/repository/board_repository.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';

class RenameBoardUseCase {
  final BoardRepository boardRepository;
  final TaskRepository taskRepository;

  RenameBoardUseCase({
    required this.boardRepository,
    required this.taskRepository,
  });

  late List<Board> currentBoards;

  Future<void> call(Board board, String newTitle) async {
    if (newTitle == board.title) return;

    currentBoards = await boardRepository.getBoards();

    _checkIfNameIsUnique(newTitle);

    final oldTitle = board.title;

    currentBoards[board.index] = board..title = newTitle;

    Future.wait([
      taskRepository.updateTasksStatusToNewStatus(oldTitle, newTitle),
      boardRepository.updateBoards(currentBoards),
    ]);
  }

  void _checkIfNameIsUnique(String newName) {
    if (currentBoards.map((e) => e.title).contains(newName)) {
      throw NameNotUniqueException();
    }
  }
}
