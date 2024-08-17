import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';

class GetTaskStreamUseCase {
  final TaskRepository taskRepository;

  GetTaskStreamUseCase(this.taskRepository);

  Stream<List<Task>> call() => taskRepository.readTasks();
}
