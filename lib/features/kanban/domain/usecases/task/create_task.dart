import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository taskRepository;

  CreateTaskUseCase(this.taskRepository);

  Future<void> call(Task newTask) async {
    if (newTask.title.isEmpty) return;

    await taskRepository.createTask(newTask);
  }
}
