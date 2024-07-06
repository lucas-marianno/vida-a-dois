import '../../data/mock_data.dart';
import '../entities/task_entity.dart';
import '../../../../core/constants/enum/task_status.dart';

Map<TaskStatus, List<Task>> getTaskListFromData = {
  TaskStatus.todo: todo,
  TaskStatus.inProgress: inProgress,
  TaskStatus.done: done,
};

void removeTaskFromColumn(Task task) {
  getTaskListFromData[task.status]!.remove(task);
  // TODO: call setStatus after this.
}
