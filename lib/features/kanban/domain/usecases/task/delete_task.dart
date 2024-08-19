import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository taskRepository;

  DeleteTaskUseCase(this.taskRepository);

  Future<void> call(Task task) async {
    assert(task.id != null);
    assert(task.id!.isNotEmpty);

    await taskRepository.deleteTask(task);
  }
}
