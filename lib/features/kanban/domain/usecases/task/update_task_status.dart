import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/task_repository.dart';

class UpdateTaskStatusUseCase {
  final TaskRepository taskRepository;

  UpdateTaskStatusUseCase(this.taskRepository);

  Future<void> call(Task task, String newStatus) async {
    if (task.status == newStatus) return;

    final updatedTask = task.copyWith(status: newStatus);
    await taskRepository.updateTask(updatedTask);
  }
}
