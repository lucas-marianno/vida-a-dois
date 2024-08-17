import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';

class UpdateTaskAssigneeUidUseCase {
  final TaskRepository taskRepository;

  UpdateTaskAssigneeUidUseCase(this.taskRepository);

  Future<void> call(Task task, String newAssigneeUID) async {
    if (task.assingneeUID == newAssigneeUID) return;

    await taskRepository.updateTask(task..assingneeUID = newAssigneeUID);
  }
}