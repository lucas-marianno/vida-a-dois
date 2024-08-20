import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/task_repository.dart';

class UpdateTaskStatusUseCase {
  final TaskRepository taskRepository;

  UpdateTaskStatusUseCase(this.taskRepository);

  Future<void> call(Task task, String newStatus) async {
    if (task.status == newStatus) return;

    await taskRepository.updateTask(task..status = newStatus);
  }
}
