/// [TaskStatus] is a temporary enum!
///
/// TODO: this should not exist as an enum as users must be able to
/// CRUD kanban columns.
///
/// extract this into a user configuration collection in firebase.
///
enum TaskStatus {
  todo,
  inProgress,
  done;

  static TaskStatus fromString(String? s) {
    if (s == null) return TaskStatus.todo;

    switch (s.toLowerCase()) {
      case 'to do' || 'todo':
        return TaskStatus.todo;
      case 'in progress' || 'inprogress':
        return TaskStatus.inProgress;
      case 'done':
        return TaskStatus.done;
      default:
        throw UnimplementedError(
          "'$s' is not a type of '$TaskStatus'! \n"
          "Available types:\n"
          "${TaskStatus.values.map((e) => e.name).toSet()}",
        );
    }
  }
}
