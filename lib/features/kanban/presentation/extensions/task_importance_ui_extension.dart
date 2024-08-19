import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/domain/constants/enum/task_importance.dart';

extension TaskImportanceUI on TaskImportance {
  IconData get icon {
    switch (this) {
      case TaskImportance.low:
        return Icons.keyboard_arrow_down;
      case TaskImportance.normal:
        return Icons.drag_handle;
      case TaskImportance.high:
        return Icons.keyboard_double_arrow_up;
    }
  }

  Color get color {
    switch (this) {
      case TaskImportance.low:
        return Colors.blue[600]!;
      case TaskImportance.normal:
        return Colors.amber[700]!;
      case TaskImportance.high:
        return Colors.red;
    }
  }
}
