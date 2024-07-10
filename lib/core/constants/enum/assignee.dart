enum Assignee {
  myself,
  mylove;

  static Assignee fromString(String assignee) {
    switch (assignee) {
      case 'myself':
        return Assignee.myself;
      case 'mylove':
        return Assignee.mylove;
      default:
        throw UnimplementedError(
          "'$assignee' is not a type of '$Assignee'! \n"
          "Available types:\n"
          "${Assignee.values.map((e) => e.name).toSet()}",
        );
    }
  }
}
