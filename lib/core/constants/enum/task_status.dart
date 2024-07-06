//TODO: this should not exist as an enum as users must be able to CRUD kanban columns

enum TaskStatus {
  todo,
  inProgress,
  done;

  String get name {
    switch (this) {
      case TaskStatus.todo:
        return 'To do';
      case TaskStatus.inProgress:
        return 'In progress';
      case TaskStatus.done:
        return 'Done';
    }
  }
}
