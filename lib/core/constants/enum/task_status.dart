//TODO: this should not exist as an enum as users must be able to CRUD kanban columns

enum TaskStatus {
  todo,
  inProgress,
  done,
  uninplemented;

  static TaskStatus fromString(String s) {
    switch (s.toLowerCase()) {
      case 'to do':
        return TaskStatus.todo;
      case 'in progress':
        return TaskStatus.inProgress;
      case 'done':
        return TaskStatus.done;
      default:
        return TaskStatus.uninplemented;
    }
  }
}
