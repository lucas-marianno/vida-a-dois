//TODO: this should not exist as an enum as users must be able to CRUD kanban columns

enum TaskStatus {
  todo,
  inProgress,
  done,
  uninplemented;

  String get name {
    switch (this) {
      case TaskStatus.todo:
        return 'To do';
      case TaskStatus.inProgress:
        return 'In progress';
      case TaskStatus.done:
        return 'Done';
      case TaskStatus.uninplemented:
        return 'UNINPLEMENTED STATUS';
    }
  }

  static TaskStatus fromString(String s) {
    switch (s) {
      case 'To do':
        return TaskStatus.todo;
      case 'In progress':
        return TaskStatus.inProgress;
      case 'Done':
        return TaskStatus.done;
      default:
        return TaskStatus.uninplemented;
    }
  }
}
