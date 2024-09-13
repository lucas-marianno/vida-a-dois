import 'package:kanban/src/domain/entities/task_entity.dart';
import 'package:kanban/src/domain/repository/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository taskRepository;
  final String currentUserUID;

  CreateTaskUseCase(this.taskRepository, this.currentUserUID);

  Future<void> call(Task newTask) async {
    if (newTask.title.isEmpty) return;

    await taskRepository.createTask(newTask.copyWith(id: currentUserUID));
  }
}
