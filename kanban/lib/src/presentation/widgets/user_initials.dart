import 'package:flutter/material.dart';

class UserInitials extends StatelessWidget {
  final String userInitials;
  const UserInitials(this.userInitials, {super.key});

  @override
  Widget build(BuildContext context) {
    if (userInitials.isEmpty) return const SizedBox();

    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Text(
        userInitials.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
