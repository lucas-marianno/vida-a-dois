// import 'package:flutter/material.dart';

// enum TaskAssignee {
//   myself,
//   mylove,
//   anyone;

//   static TaskAssignee fromString(String? assignee) {
//     if (assignee == null) return TaskAssignee.anyone;

//     switch (assignee.toLowerCase()) {
//       case 'myself':
//         return TaskAssignee.myself;
//       case 'mylove':
//         return TaskAssignee.mylove;
//       case 'anyone':
//         return TaskAssignee.anyone;
//       default:
//         throw UnimplementedError(
//           "'$assignee' is not a type of '$TaskAssignee'! \n"
//           "Available types:\n"
//           "${TaskAssignee.values.map((e) => e.name).toSet()}",
//         );
//     }
//   }

//   / This will be removed!
//   /
//   / TODO: allow users to select and use a personal profile picture
//   IconData? get icon {
//     switch (this) {
//       case myself:
//         return Icons.person;
//       case mylove:
//         return Icons.person_outline;
//       case TaskAssignee.anyone:
//         return null;
//     }
//   }
// }
