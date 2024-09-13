import 'package:kanban/src/domain/constants/enum/task_importance.dart';
import 'package:kanban/src/domain/entities/task_entity.dart';
import 'package:kanban/src/domain/repository/task_repository.dart';

class UpdateTaskImportanceUseCase {
  final TaskRepository taskRepository;

  UpdateTaskImportanceUseCase(this.taskRepository);

  Future<void> call(Task task, TaskImportance newImportance) async {
    if (task.importance == newImportance) return;

    final updatedTask = task.copyWith(importance: newImportance);
    await taskRepository.updateTask(updatedTask);
  }
}
