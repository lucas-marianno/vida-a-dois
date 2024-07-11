enum Assignee {
  myself,
  mylove,
  anyone;

  static Assignee fromString(String? assignee) {
    if (assignee == null) return Assignee.anyone;

    switch (assignee.toLowerCase()) {
      case 'myself':
        return Assignee.myself;
      case 'mylove':
        return Assignee.mylove;
      case 'anyone':
        return Assignee.anyone;
      default:
        throw UnimplementedError(
          "'$assignee' is not a type of '$Assignee'! \n"
          "Available types:\n"
          "${Assignee.values.map((e) => e.name).toSet()}",
        );
    }
  }
}
