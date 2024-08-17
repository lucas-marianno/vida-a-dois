import 'package:kanban/features/kanban/core/constants/enum/task_importance.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';

class UpdateTaskImportanceUseCase {
  final TaskRepository taskRepository;

  UpdateTaskImportanceUseCase(this.taskRepository);

  Future<void> call(Task task, TaskImportance newImportance) async {
    if (task.taskImportance == newImportance) return;

    await taskRepository.updateTask(task..taskImportance = newImportance);
  }
}
