import 'package:flutter/material.dart';

class UserInitials extends StatelessWidget {
  final String? userUID;
  final String? userInitials;
  const UserInitials({this.userUID, this.userInitials, super.key});

  @override
  Widget build(BuildContext context) {
    print('------------------------------------------------');
    print('userUID: $userUID');
    print('userInitals: $userInitials');
    assert(
        (userUID != null) != (userInitials != null),
        "either '$userUID' or '$userInitials' should be provided,"
        " but not both and not neither.");

    if (userInitials != null) {
      assert(userInitials!.isNotEmpty);

      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Text(
          userInitials!.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }
    if (userUID!.isEmpty) {
      return const SizedBox();
    }
    // TODO: implement fetch initials from UID
    return CircleAvatar(
      backgroundColor: Color.fromARGB(255, 255, 0, 255),
      child: Text(userUID!),
    );
  }
}
