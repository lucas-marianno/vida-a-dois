import 'package:flutter/material.dart';

enum TaskAssignee {
  myself,
  mylove,
  anyone;

  static TaskAssignee fromString(String? assignee) {
    if (assignee == null) return TaskAssignee.anyone;

    switch (assignee.toLowerCase()) {
      case 'myself':
        return TaskAssignee.myself;
      case 'mylove':
        return TaskAssignee.mylove;
      case 'anyone':
        return TaskAssignee.anyone;
      default:
        throw UnimplementedError(
          "'$assignee' is not a type of '$TaskAssignee'! \n"
          "Available types:\n"
          "${TaskAssignee.values.map((e) => e.name).toSet()}",
        );
    }
  }

  IconData? get icon {
    switch (this) {
      case myself:
        return Icons.person_outline;
      case mylove:
        return Icons.favorite_outline;
      case TaskAssignee.anyone:
        return null;
    }
  }
}
