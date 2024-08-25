import 'package:vida_a_dois/features/kanban/domain/entities/task_entity.dart';
import 'package:vida_a_dois/features/kanban/domain/repository/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository taskRepository;

  UpdateTaskUseCase(this.taskRepository);

  Future<void> call(Task task) async {
    assert(task.title.isNotEmpty);
    assert(task.id != null);

    taskRepository.updateTask(task.copyWith());
  }
}
