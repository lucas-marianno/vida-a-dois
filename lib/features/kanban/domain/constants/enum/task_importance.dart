enum TaskImportance {
  low,
  normal,
  high;

  static TaskImportance fromString(String? taskImportance) {
    switch (taskImportance?.toLowerCase()) {
      case null || '' || 'normal':
        return TaskImportance.normal;
      case 'low':
        return TaskImportance.low;
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
