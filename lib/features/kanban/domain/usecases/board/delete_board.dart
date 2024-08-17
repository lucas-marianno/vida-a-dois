import 'package:kanban/features/kanban/domain/entities/board_entity.dart';
import 'package:kanban/features/kanban/domain/repository/board_repository.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';

class DeleteBoardUseCase {
  final BoardRepository boardRepository;
  final TaskRepository taskRepository;
  DeleteBoardUseCase({
    required this.boardRepository,
    required this.taskRepository,
  });

  Future<void> call(Board board) async {
    final currentBoards = await boardRepository.getBoards();

    currentBoards.removeWhere((e) => e.title == board.title);

    await boardRepository.updateBoards(currentBoards);

    // TODO: must delete all tasks with board.status
    throw UnimplementedError();
  }
}
