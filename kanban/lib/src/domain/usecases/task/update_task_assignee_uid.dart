import 'package:kanban/src/domain/entities/task_entity.dart';
import 'package:kanban/src/domain/repository/task_repository.dart';

class UpdateTaskAssigneeUidUseCase {
  final TaskRepository taskRepository;

  UpdateTaskAssigneeUidUseCase(this.taskRepository);

  Future<void> call(Task task, String newAssigneeUID) async {
    if (task.assingneeUID == newAssigneeUID) return;

    final updatedTask = task.copyWith(assingneeUID: newAssigneeUID);
    await taskRepository.updateTask(updatedTask);
  }
}
