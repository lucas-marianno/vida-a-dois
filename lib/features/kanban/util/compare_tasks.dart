// ignore_for_file: avoid_print

import 'package:kanban/features/kanban/domain/entities/task_entity.dart';

compareTasks(Task task1, Task task2) {
  print('----------------comparando tasks ----------------------------');
  print('\t Attribute: \t | \t task1 \t | \t task2 \t');

  for (var attribute in task1.toJson().keys) {
    final val1 = task1.toJson()[attribute];
    final val2 = task2.toJson()[attribute];
    final comparison = val1 == val2 ? '✅' : '❌';

    print('$comparison Attribute: $attribute | $val1 | $val2');
  }
  print('-------------------------------------------------------------');
}
