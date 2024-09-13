import 'package:kanban/src/domain/entities/board_entity.dart';
import 'package:kanban/src/domain/entities/task_entity.dart';
import 'package:kanban/src/domain/repository/board_repository.dart';
import 'package:kanban/src/domain/repository/task_repository.dart';

class DeleteBoardUseCase {
  final BoardRepository boardRepo;
  final TaskRepository taskRepo;
  DeleteBoardUseCase({required this.boardRepo, required this.taskRepo});

  Future<void> call(Board board) async {
    final currentBoards = await boardRepo.getBoards();

    currentBoards.removeWhere((e) => e.title == board.title);

    await boardRepo.updateBoards(currentBoards);

    _deleteAllTasksWithStatus(board.title);
  }

  Future<void> _deleteAllTasksWithStatus(String status) async {
    final allTasks = await taskRepo.getTaskList();
    final allTasksWithStatus = allTasks
        .map((task) => task.status == status ? task : null)
        .nonNulls
        .toList();

    await Future.wait(
        [for (Task task in allTasksWithStatus) taskRepo.deleteTask(task)]);
  }
}
