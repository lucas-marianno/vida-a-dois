import 'package:flutter/material.dart';

class FormTitle extends StatelessWidget {
  final String title;
  final void Function() onIconPressed;
  final IconData? icon;
  final Color? color;

  const FormTitle({
    required this.title,
    required this.onIconPressed,
    required this.icon,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: icon == null
          ? null
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color ?? Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onIconPressed,
              child: Icon(icon),
            ),
    );
  }
}
