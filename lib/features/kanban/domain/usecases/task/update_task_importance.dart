import 'package:vida_a_dois/features/kanban/domain/constants/enum/task_importance.dart';
import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/task_repository.dart';

class UpdateTaskImportanceUseCase {
  final TaskRepository taskRepository;

  UpdateTaskImportanceUseCase(this.taskRepository);

  Future<void> call(Task task, TaskImportance newImportance) async {
    if (task.taskImportance == newImportance) return;

    final updatedTask = task.copyWith(taskImportance: newImportance);
    await taskRepository.updateTask(updatedTask);
  }
}
