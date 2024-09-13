enum TaskImportance {
  low,
  normal,
  high;

  static TaskImportance fromString(String? taskImportance) {
    switch (taskImportance?.toLowerCase()) {
      case 'low':
        return TaskImportance.low;
      case 'high':
        return TaskImportance.high;
      default:
        return TaskImportance.normal;
    }
  }
}
