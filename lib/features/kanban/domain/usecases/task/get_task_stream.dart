import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/board_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/board_repository.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository taskRepository;
  final BoardRepository boardRepository;

  GetTasksUseCase(this.taskRepository, this.boardRepository);

  Stream<Map<String, List<Task>>> call() async* {
    List<Task> taskList = await taskRepository.getTaskList();
    List<Board> boardList = await boardRepository.getBoards();

    yield _organizeTasks(taskList, boardList);

    Stream<List<Board>> boardStream = boardRepository.readBoards();
    Stream<List<Task>> taskStream = taskRepository.readTasks();

    await for (final tasks in taskStream) {
      if (!const ListEquality().equals(tasks, taskList)) {
        taskList = tasks;
        yield _organizeTasks(taskList, boardList);
      }
    }

    await for (final boards in boardStream) {
      if (!const ListEquality().equals(boards, boardList)) {
        boardList = boards;
        yield _organizeTasks(taskList, boardList);
      }
    }
  }

  Map<String, List<Task>> _organizeTasks(List<Task> tasks, List<Board> boards) {
    return <String, List<Task>>{
      for (Board b in boards)
        b.title: tasks.where((t) => t.status == b.title).toList()
    };
  }
}
