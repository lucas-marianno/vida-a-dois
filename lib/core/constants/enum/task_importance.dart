enum TaskImportance {
  low,
  normal,
  high;

  static TaskImportance fromString(String? taskImportance) {
    if (taskImportance == null) return TaskImportance.normal;

    switch (taskImportance.toLowerCase()) {
      case 'low':
        return TaskImportance.low;
      case 'normal':
        return TaskImportance.normal;
      case 'high':
        return TaskImportance.high;
      default:
        throw UnimplementedError(
          "'$taskImportance' is not a type of '$TaskImportance'! \n"
          "Available types:\n"
          "${TaskImportance.values.map((e) => e.name).toSet()}",
        );
    }
  }
}
