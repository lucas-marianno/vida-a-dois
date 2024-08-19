import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository taskRepository;

  UpdateTaskUseCase(this.taskRepository);

  Future<void> call(Task task, Task newTask) async {
    if (task == newTask) return;

    assert(task.id == newTask.id);

    taskRepository.updateTask(newTask);
  }
}
