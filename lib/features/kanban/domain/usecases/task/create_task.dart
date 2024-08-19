import 'package:kanban/features/auth/data/auth_data.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repository/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository taskRepository;

  CreateTaskUseCase(this.taskRepository);

  Future<void> call(Task newTask) async {
    if (newTask.title.isEmpty) return;

    final currentUserUID = AuthData.currentUser!.uid;

    await taskRepository.createTask(newTask..id = currentUserUID);
  }
}
