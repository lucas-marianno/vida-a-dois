import 'package:vida_a_dois/features/kanban/domain/entities/board_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/exceptions/kanban_exception.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/board_repository.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/task_repository.dart';

class RenameBoardUseCase {
  final BoardRepository boardRepo;

  final TaskRepository taskRepo;

  RenameBoardUseCase({required this.boardRepo, required this.taskRepo});

  late List<Board> currentBoards;

  Future<void> call(Board board, String newTitle) async {
    if (newTitle.isEmpty) return;
    if (newTitle == board.title) return;

    currentBoards = await boardRepo.getBoards();

    _checkIfNameIsUnique(newTitle);

    final oldTitle = board.title;

    currentBoards[board.index] =
        currentBoards[board.index].copyWith(title: newTitle);

    Future.wait([
      _updateTasksStatusToNewStatus(oldTitle, newTitle),
      boardRepo.updateBoards(currentBoards),
    ]);
  }

  void _checkIfNameIsUnique(String newName) {
    if (currentBoards.map((e) => e.title).contains(newName)) {
      throw NameNotUniqueException();
    }
  }

  Future<void> _updateTasksStatusToNewStatus(
    String status,
    String newStatus,
  ) async {
    final allTasks = await taskRepo.getTaskList();
    final updatedTasks = allTasks
        .map((task) {
          return task.status == status
              ? (task.copyWith(status: newStatus))
              : null;
        })
        .nonNulls
        .toList();

    await Future.wait([
      for (Task task in updatedTasks) taskRepo.updateTask(task),
    ]);
  }
}
