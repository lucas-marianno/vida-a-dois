import 'package:kanban/src/domain/entities/task_entity.dart';
import 'package:kanban/src/domain/repository/task_repository.dart';

class UpdateTaskStatusUseCase {
  final TaskRepository taskRepository;

  UpdateTaskStatusUseCase(this.taskRepository);

  Future<void> call(Task task, String newStatus) async {
    if (task.status == newStatus) return;

    final updatedTask = task.copyWith(status: newStatus);
    await taskRepository.updateTask(updatedTask);
  }
}
