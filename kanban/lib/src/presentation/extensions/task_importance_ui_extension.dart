import 'package:flutter/material.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/src/domain/constants/enum/task_importance.dart';

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

  String localizeName(BuildContext context) {
    final l10n = L10n.of(context);
    switch (this) {
      case TaskImportance.low:
        return l10n.low;
      case TaskImportance.normal:
        return l10n.normal;
      case TaskImportance.high:
        return l10n.high;
    }
  }

  static TaskImportance fromLocalizedName(
    String? taskImportance,
    BuildContext context,
  ) {
    taskImportance = taskImportance?.toLowerCase();
    final l10n = L10n.of(context);

    if (taskImportance == l10n.low.toLowerCase()) return TaskImportance.low;
    if (taskImportance == l10n.high.toLowerCase()) return TaskImportance.high;
    return TaskImportance.normal;
  }
}
